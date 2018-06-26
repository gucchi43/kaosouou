
'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();

exports.sendFollowerNotification = functions.firestore.document('version/1/user/{userId}/notificationItems/{notificationItemId}')
    .onCreate((snapshot, context) => {
        const userId = context.params.userId;
        const notificationItemId = context.params.notificationItemId;
        const getNotificationItemPromise = admin.firestore().collection('version/1/notificationitem').doc(notificationItemId).get()
        const getToUserPromise = admin.firestore().collection('version/1/user').doc(userId).get()
        let notificationItem;
        let toUser;
        let toGender;
        let fromUser;
        let num;
        let token;
        let fromUserName;
        let payload;
        return Promise.all([getNotificationItemPromise, getToUserPromise])
            .then(results => {
                notificationItem = results[0];
                num = notificationItem.data().num;
                toUser = results[1];
                toGender = toUser.data().gender;
                token = toUser.data().fcmToken;
                const getFromUserPromise = notificationItem.data().from.get();
                return Promise.all([getFromUserPromise])
                    .then(results => {
                        fromUser = results[0];
                        fromUserName = fromUser.data().displayName;
                        if (toGender === 1) {
                            payload = {
                                notification: {
                                    title: fromUserName,
                                    body: 'あなたは' + num + '番目にイケメンだわ！'
                                }
                            };
                        } else {
                            payload = {
                                notification: {
                                    title: fromUserName,
                                    body: '君は' + num + '番目にカワイイよ！'
                                }
                            };
                        }
                        return admin.messaging().sendToDevice(token, payload)
                            .then(pushResponse => {
                                return console.log("Successfully sent message:", pushResponse);
                            })
                            .catch(error => {
                                console.log("Error sending message:", error);
                            });
                    })
            })
    });
