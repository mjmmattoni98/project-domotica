import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();

const db = admin.firestore();
const fcm = admin.messaging();

export const sendToTopic = functions.firestore
  .document('puppies/{puppyId}')
  .onCreate(async snapshot => {
    const puppy = snapshot.data();

    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'New Puppy!',
        body: `${puppy.name} is ready for adoption`,
        icon: 'your-icon-url',
        click_action: 'FLUTTER_NOTIFICATION_CLICK' // required only for onResume or onLaunch callbacks
      }
    };

    return fcm.sendToTopic('puppies', payload);
  });

export const sendToDevice = functions.firestore
  .document('orders/{orderId}')
  .onCreate(async snapshot => { 

    const order = snapshot.data();

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

    return fcm.sendToDevice(tokens, payload);
  });

export const cleanUpNewReviews = functions.firestore
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
  })

