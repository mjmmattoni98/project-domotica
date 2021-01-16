import * as functions from "firebase-functions"
import * as admin from "firebase-admin"

admin.initializeApp()

const db = admin.firestore()
const fcm = admin.messaging()

export const devicesStates = functions.firestore
    .document('dispositivo/{did}')
    .onUpdate(async (change, context) => {
      const before = change.before.data()
      const after = change.after.data()
      if (before.estado === after.estado) {
        console.log("El estado del dispositivo no ha cambiado")
        return null
      }

      if (after.habitacion.length === 0) {
        console.log("El dispositivo no se encuentra en ninguna habitacion")
        return null
      }

      const states = ["open", "motion_detected", "on"]
      if (after.estado.toLowerCase() === "disconnected" || states.includes(after.estado.toLowerCase())) {
        const tokens = await getTokens(after.uid)

        const refHabitacion = await db
          .collection('habitacion')
          .doc(after.habitacion)
          .get()

        const dataHabitacion = refHabitacion.data()

        if(dataHabitacion === undefined) {
          console.log("La habitacion no existe")
          return null
        }

        let payload: admin.messaging.MessagingPayload
        if (after.estado.toLowerCase() === "disconnected") {
          payload = {
            notification: {
              title: "DISPOSITIVO DESCONECTADO!!!!!!!",
              body: `Se ha desconectado el dispositivo de tipo ${after.tipo} de la habitacion ${dataHabitacion.nombre}`,
              click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
          }
        }
        else {
          if(after.tipo.toLowerCase() !== "alarma"){
            const idHabitacion = after.habitacion
            activaAlarmaSiHay(idHabitacion)
          }
          payload = {
            notification: {
              title: "Se ha activado un dispositivo",
              body: `Se ha activado el dispositivo de tipo ${after.tipo} de la habitacion ${dataHabitacion.nombre}`,
              click_action: 'FLUTTER_NOTIFICATION_CLICK'
            }
          }
        }

        return await fcm.sendToDevice(tokens, payload, {
          // Required for background/quit data-only messages on iOS
          // contentAvailable: true,
          // Required for background/quit data-only messages on Android
          priority: "high",
        })
        .then(() => console.log("Usuario avisado de activacion de dispositivo"))
        .catch(err => console.log("Error avisando al usuario de activacion de dispositivo: ", err))
      }
      return null
    })

async function activaAlarmaSiHay(idHabitacion: string): Promise<void> {
  const refHabitacion = await db.collection('habitacion').doc(idHabitacion).get()
  const dataHabitacion = refHabitacion.data()

  if(dataHabitacion !== undefined){
    const dispositivos = dataHabitacion.dispositivos.split(":")
    await db.collection('dispositivo').where(admin.firestore.FieldPath.documentId(), 'in', dispositivos).where('tipo', '==', 'alarma').get()
      .then((snapshot) => {
        if(snapshot.empty){
          console.log("No hay alarmas para activar en la habitacion")
          return
        }
        snapshot.forEach((doc) => {
          const data = doc.data()
          if(data.estado.toLowerCase() === "off"){
            doc.ref.update({estado: "ON"})
            console.log("Alarma activada")
          }
        })
      }).catch(err => {
        console.log("Algo ha salido mal al activar las alarmas ", err)
      })
  }
}

async function getTokens(uid: string): Promise<string[]>{
  const querySnapshotTokens = await db
          .collection('users')
          .doc(uid)
          .collection('tokens')
          .get()

  const tokens = querySnapshotTokens.docs.map((snap) => snap.id)
  
  return tokens
}

export const constrolarConexionHub = functions.pubsub.schedule('every 2 min').onRun(async (context) => {
  await db.collection('hub').get()
    .then((snapshot) => {
      if(snapshot.empty){
        console.log("Error accediendo a los hub")
        return
      }
      snapshot.forEach(async (doc) => {
        const data = doc.data()
        
        const tokens = await getTokens(data.uid)

        let consultasNuevas: number = 0
        if (data.estado.toLowerCase() === "pong"){
          if(data.consultas > 0){
            const payload: admin.messaging.MessagingPayload = {
              notification: {
                title: "Conexion HUB restablecida",
                body: "Se ha recuperado la conexión con el HUB",
                click_action: "FLUTTER_NOTIFICATION_CLICK"
              }
            }
            fcm.sendToDevice(tokens, payload, {
              // Required for background/quit data-only messages on iOS
              // contentAvailable: true,
              // Required for background/quit data-only messages on Android
              priority: "high",
            })
          }
          console.log("El hub esta en estado PONG")
        } 
        else{
          if(data.consultas == 0){
            const payload: admin.messaging.MessagingPayload = {
              notification: {
                title: "Conexion HUB perdida",
                body: "Se ha perdido la conexión con el HUB",
                click_action: "FLUTTER_NOTIFICATION_CLICK"
              }
            }
            fcm.sendToDevice(tokens, payload, {
              // Required for background/quit data-only messages on iOS
              // contentAvailable: true,
              // Required for background/quit data-only messages on Android
              priority: "high",
            })
          }
          consultasNuevas = data.consultas + 1
          console.log("El hub esta en estado PING")
        }
        await doc.ref.update({estado: "PING", consultas: consultasNuevas})
        .then(() => console.log("Actualizado el estado del hub"))
        .catch(err => console.log("Error al intentar actualizar el estado del hub: ", err))
      })
    })
    .catch((err) => {
      console.log("Ha habido un error al comprobar la conexion del hub ", err)
    })
})


