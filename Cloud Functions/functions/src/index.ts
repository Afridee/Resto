import * as functions from 'firebase-functions';
import * as admin from 'firebase-admin';
admin.initializeApp();

//const db = admin.firestore();
const fcm = admin.messaging();

export const sendToDevice = functions.firestore
  .document('pushNotes/{docID}')
  .onCreate(snapshot => {


    const order = snapshot.data();


    var token = order?.fcmToken;
    var status = order?.status;


    const payload: admin.messaging.MessagingPayload = {
      notification: {
        title: 'Your Order Status',
        body: `Your order is ${status}`,
        icon: 'https://firebasestorage.googleapis.com/v0/b/resto-2f342.appspot.com/o/playstore.png?alt=media&token=11d3f277-69ce-47e8-9b23-e0199bcacfb6',
        click_action: 'FLUTTER_NOTIFICATION_CLICK'
      }
    };

    return fcm.sendToDevice(token, payload);


  });