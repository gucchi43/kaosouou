
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
        let toBadgeNum;
        let currentBadgeNum;
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
                currentBadgeNum = toUser.data().badgeNum;
                console.log("currentBadgeNum :", currentBadgeNum);
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
                                    body: 'あなたは' + num + '番目にイケメンだわ！',
                                    badge: String(currentBadgeNum + 1),
                                    sound: 'scrach.m4a'
                                }
                                // data: {
                                //     badge: '1',
                                //     notificationId: notificationItemId
                                // }
                            };
                        } else {
                            payload = {
                                notification: {
                                    title: fromUserName,
                                    body: '君は' + num + '番目にカワイイよ！',
                                    badge: String(currentBadgeNum + 1),
                                    sound: 'scrach.m4a'
                                }
                                // data: {
                                //     badge: '1',
                                //     notificationId: notificationItemId
                                // }
                            };
                        }

                        
                        // return toUser.set({
                        //     badgeNum: currentBadgeNum + 1
                        // })
                        return admin.firestore().collection('version/1/user').doc(toUser.data().id).update
                            badgeNum: currentBadgeNum + 1
                            // console.log("badgeNum udpate!!!", currentBadgeNum + 1);
                        })
                            .then(pushResponse => {
                                console.log("Successfully update toUser:", pushResponse);
                                return admin.messaging.sendToDevice(token, payload)
                                .then(pushResponse => {
                                    return console.log("Successfully sent message:", pushResponse);
                                })
                                .catch(error => {
                                    console.log("Error sending message:", error);
                                });
                        })
                        .catch(error => {
                            console.log("Error update toUser:", error);
                        });
                    })
            })
    });
