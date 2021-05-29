import * as functions from "firebase-functions"
import * as admin from "firebase-admin"

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
      
      const statesActive = ["open", "motion_detected"] // Estados activos de los dispositivos que no son de tipo alarma
      // const statesInactive = ["close", "no_motion"] // Estados activos de los dispositivos que no son de tipo alarma
      const alarmaActivada = "on" // Estado en el que está la alarma cuando está activada
      const alarmaDesactivada = "off" // Estado en el que está la alarma cuando está desactivada

      const nuevoEstadoDispositivo: string = after.estado.toLowerCase()
      if(alarmaActivada === nuevoEstadoDispositivo){
        // Si se ha activado una alarma, comprobar que se encuentra en una habitación, e indicar 
        // que hay una alarma activada en la habitación

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

          const tokens = await getTokens(after.uid)
          
          const payload = {
            notification: {
              title: "Se ha activado una alarma",
              body: `Se ha activado la alarma ${after.nombre} de la habitacion ${dataHabitacion.nombre}`,
              click_action: 'FLUTTER_NOTIFICATION_CLICK'
            },
            data: {
              idDispositivo: after.id,
              idHabitacion: after.habitacion
            }
          }
  
          return await fcm.sendToDevice(tokens, payload, {
            // Required for background/quit data-only messages on iOS
            // contentAvailable: true,
            // Required for background/quit data-only messages on Android
            priority: "high",
          })
          .then(() => console.log("Usuario avisado de activacion de alarma"))
          .catch(err => console.log("Error avisando al usuario de activacion de alarma: ", err))
        }
      }else if(alarmaDesactivada === nuevoEstadoDispositivo){
        // Si se ha desactivado una alarma, comprobar que se encuentra en una habitación, e indicar 
        // que ya no hay una alarma activada en la habitación, si fuera necesario 

        let ultimo: boolean = false
        // Coger todos los dispositivos de la habitación del usuario que sean del tipo alarma y estén activadas
        await db.collection('dispositivos')
          .where('habitacion', '==', after.habitacion)
          .where('tipo', '==', 'alarma')
          .where('estado', '==', 'on')
          .get()
          .then((snapshot) => {
            if(snapshot.empty){
              ultimo = true
            }
          }).catch(err => {
            console.log("Algo ha salido mal viendo las alarmas activadas en la habitacion ", err)
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
      }else if (statesActive.includes(nuevoEstadoDispositivo)) {
        // Se ha activado un dispositivo de tipo movimiento o apertura

        const idHabitacion: string = after.habitacion
        cambiarEstadoAlarma(idHabitacion, true)
      }else{ // statesInactive.includes(nuevoEstadoDispositivo) || nuevoEstadoDispositivo === "disconnected"
        // Se ha desactivado o desconectado un dispositivo

        let ultimo: boolean = false
        // Coger todos los dispositivos de la habitación del usuario que no sean del tipo alarma y estén activados
        await db.collection('dispositivos')
          .where('habitacion', '==', after.habitacion)
          .where('tipo', '!=', 'alarma')
          .where('estado', 'in', statesActive)
          .get()
          .then((snapshot) => {
            if(snapshot.empty){
              ultimo = true
            }
          }).catch(err => {
            console.log("Algo ha salido mal viendo los dispositivos activados en la habitacion ", err)
          })
        
        if(ultimo){
          // Si no quedan dispositivos activos en la habitación, desconectamos la alarma si hubiera
        
          const idHabitacion: string = after.habitacion
          cambiarEstadoAlarma(idHabitacion, false)
        }
      }

      return null
    })

async function cambiarEstadoAlarma(idHabitacion: string, activar: boolean): Promise<void> {
  await db.collection('dispositivos')
    .where('habitacion', '==', idHabitacion)
    .where('tipo', '==', 'alarma')
    .get()
    .then((snapshot) => {
      if(snapshot.empty){
        console.log("No hay alarmas para cambiar el estado en la habitacion")
        return
      }
      snapshot.forEach((doc) => {
        let nuevoEstado = "off"
        let viejoEstado = "on"
        if(activar){
          nuevoEstado = "on"
          viejoEstado = "off"
        }
        const data = doc.data()
        if(data.estado.toLowerCase() === viejoEstado){
          doc.ref.update({estado: nuevoEstado})
          console.log(`Alarma ${activar ? "activada" : "desactivada"}`)
        }
      })
    }).catch(err => {
      console.log("Algo ha salido mal al cambiar el estado de las alarmas ", err)
    })
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
