import * as functions from "firebase-functions"
import * as admin from "firebase-admin"
// const serviceAccount = require("C:\\Users\\javie\\Documents\\project-domotica\\backendFirebase\\service-account-key.json")

admin.initializeApp({
  credential: admin.credential.applicationDefault(),
})

const db = admin.firestore()
const fcm = admin.messaging()

export const devicesStates = functions.region('europe-west1').firestore
    .document('dispositivos/{did}')
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
      
      if(states.includes(after.estado.toLowerCase())){
        const refHabitacion = await db
          .collection('habitaciones')
          .doc(after.habitacion)
          .get()

        const dataHabitacion = refHabitacion.data()

        if(dataHabitacion === undefined) {
          console.log("La habitacion no existe")
          return null
        }
        
        if(!dataHabitacion.activo){
          refHabitacion.ref.update({
            activo: true
          })
        }
      }else{
        let ultimo: boolean = false
        await db.collection('dispositivos')
          .where('uid', '==', after.uid)
          .where('habitacion', '==', after.habitacion)
          .where('tipo', '==', 'alarma')
          .get()
          .then((snapshot) => {
            if(snapshot.size == 1){
              ultimo = true
            }
          }).catch(err => {
            console.log("Algo ha salido mal viendo los dispositivos en una habitacion ", err)
          })
        
        if(ultimo){
          const refHabitacion = await db
            .collection('habitaciones')
            .doc(after.habitacion)
            .get()

          const dataHabitacion = refHabitacion.data()

          if(dataHabitacion === undefined) {
            console.log("La habitacion no existe")
            return null
          }
          
          if(dataHabitacion.activo){
            refHabitacion.ref.update({
              activo: false
            })
          }
        }
      }

      if (after.estado.toLowerCase() === "disconnected" || states.includes(after.estado.toLowerCase())) {
        const tokens = await getTokens(after.uid)

        const refHabitacion = await db
          .collection('habitaciones')
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
              body: `Se ha desconectado el dispositivo ${after.nombre} de la habitacion ${dataHabitacion.nombre}`,
              click_action: 'FLUTTER_NOTIFICATION_CLICK'
            },
            data: {
              idDispositivo: after.id,
              idHabitacion: ""
            }
          }
        }
        else {
          if(after.tipo.toLowerCase() !== "alarma"){
            const idHabitacion = after.habitacion
            const uidDispositivo = after.uid
            activaAlarmaSiHay(idHabitacion, uidDispositivo)
          }
          payload = {
            notification: {
              title: "Se ha activado un dispositivo",
              body: `Se ha activado el dispositivo ${after.nombre} de la habitacion ${dataHabitacion.nombre}`,
              click_action: 'FLUTTER_NOTIFICATION_CLICK'
            },
            data: {
              idDispositivo: after.id,
              idHabitacion: after.habitacion
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

async function activaAlarmaSiHay(idHabitacion: string, uidDispositivo: string): Promise<void> {
  const refHabitacion = await db.collection('habitaciones').doc(idHabitacion).get()
  const dataHabitacion = refHabitacion.data()

  if(dataHabitacion !== undefined){
    await db.collection('dispositivos')
      .where('uid', '==', uidDispositivo)
      .where('habitacion', '==', idHabitacion)
      .where('tipo', '==', 'alarma')
      .get()
      .then((snapshot) => {
        if(snapshot.empty){
          console.log("No hay alarmas para activar en la habitacion")
          return
        }
        snapshot.forEach((doc) => {
          const data = doc.data()
          if(data.estado.toLowerCase() === "off"){
            doc.ref.update({estado: "on"})
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
