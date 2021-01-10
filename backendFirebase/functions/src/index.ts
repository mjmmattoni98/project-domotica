import * as functions from "firebase-functions";
import * as admin from "firebase-admin";
import { snapshotConstructor } from "firebase-functions/lib/providers/firestore";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

/* export const sendToTopic = functions.firestore
  .document('puppies/{puppyId}')
  .onCreate(async snapshot => {
    const puppy = snapshot.data();

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Puppy!',
        body: `${puppy.name} is ready for adoption`,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
      },
    };

    return fcm.sendToTopic('puppies', payload);
  });*/

/*exports.listFruit = functions.https.onCall((data, context) => {
  return ["Apple", "Banana", "Cherry", "Date", "Fig", "Grapes"]
});*/

/*export const sendToDevice = functions.firestore
  .document('orders/{orderId}')
  .onWrite(async (change, context) => { 

    const order = change.after.data();
    
    const querySnapshot = await db
      .collection('users')
      .doc(order.seller)
      .collection('tokens')
      .get();

    const tokens = querySnapshot.docs.map(snap => snap.id);

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Order!',
        body: `you sold a ${order.product} for ${order.total}`,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return fcm.sendToDevice(tokens, payload,{
      // Required for background/quit data-only messages on iOS
      //contentAvailable: true,
      // Required for background/quit data-only messages on Android
      priority: "high",
    });
  });*/

/*export const cleanUpNewReviews = functions.firestore
.document('some_path')
.onWrite((change, context) => {
    const reviewData = change.after.data();
    if(reviewData){
        const reviewText = reviewData.text;
        const updatedText = 'Some text';
        if(reviewText === updatedText){
          console.log("i have nothing to do!");
          return null;
        }
        return change.after.ref.update({text: updatedText});
    }
    else{
        return null;
    }
})*/

export const devicesStates = functions.firestore
  .document('dispositivo/{did}')
  .onUpdate(async (change, context) => {
    const before = change.before.data();
    const after = change.after.data();
    if (before.estado === after.estado) {
      console.log("El estado del dispositivo no ha cambiado");
      return null;
    }

    if (after.habitacion.length === 0) {
      console.log("El dispositivo no se encuentra en ninguna habitacion");
      return null;
    }

    const states = ["open", "motion_detected", "on"];
    if (after.estado.toLowerCase() === "disconnected" || states.includes(after.estado.toLowerCase())) {
      const querySnapshotTokens = await db
        .collection('users')
        .doc(after.uid)
        .collection('tokens')
        .get();

      const tokens = querySnapshotTokens.docs.map(snap => snap.id);

      const refHabitacion = await db
        .collection('habitacion')
        .doc(after.habitacion)
        .get();

      const dataHabitacion = refHabitacion.data();

      let payload: admin.messaging.MessagingPayload;

      if(dataHabitacion === undefined){
        console.log("La habitacion no existe");
        return null;
      }

      if (after.estado.toLowerCase() === "disconnected") {
        payload = {
          notification: {
            title: "DISPOSITIVO DESCONECTADO!!!!!!!",
            body: `Se ha desconectado el dispositivo de tipo ${after.tipo} de la habitacion ${dataHabitacion.nombre}`,
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
          }
        };
      }
      else {
        if(after.tipo.toLowerCase() !== "alarma"){
          const idHabitacion = after.habitacion;
          await activaAlarmaSiHay(idHabitacion);
        }
        payload = {
          notification: {
            title: "Se ha activado un dispositivo",
            body: `Se ha activado el dispositivo de tipo ${after.tipo} de la habitacion ${dataHabitacion.nombre}`,
            click_action: 'FLUTTER_NOTIFICATION_CLICK'
          }
        };
      }

      return fcm.sendToDevice(tokens, payload, {
        // Required for background/quit data-only messages on iOS
        //contentAvailable: true,
        // Required for background/quit data-only messages on Android
        priority: "high",
      });
    }
    return null;
  });

async function activaAlarmaSiHay(idHabitacion: string): Promise<void> {
  const refHabitacion = await db.collection('habitacion').doc(idHabitacion).get();
  const dataHabitacion = refHabitacion.data();

  if(dataHabitacion !== undefined){
    const dispositivos = dataHabitacion.dispositivos.split(":");
    const refDispositivos = db.collection('dispositivo').where('id', 'in', dispositivos).where('tipo', '==', 'alarma').get()
      .then(snapshot => {
        if(snapshot.empty){
          console.log("No hay alarmas para activar en la habitacion");
          return;
        }
        snapshot.forEach(doc => {
          const data = doc.data();
          if(data.estado.toLowerCase() === "off"){
            doc.ref.update({estado: "ON"});
          }
        })
      });
  }

}


