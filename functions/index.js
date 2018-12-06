
// 'use strict';

const functions = require('firebase-functions');
const admin = require('firebase-admin');
admin.initializeApp();
const firestore = admin.firestore()

console.log("load start");
exports.sendFollowerNotification = functions.firestore.document(`version/1/user/{userId}/notificationItems/{notificationItemId}`)
.onCreate((snapshot, context) => {
  // console.log("notificationItem :", context);
  const userId = context.params.userId;
  const notificationItemId = context.params.notificationItemId;
  const getNotificationItemPromise = firestore.collection(`version/1/notificationitem`).doc(notificationItemId).get()
  const getToUserPromise = firestore.collection(`version/1/user`).doc(userId).get()
  let notificationItem;
  let toUser;
  let toGender;
  let toBadgeNum;
  let toUserOriginId;
  let currentBadgeNum;
  let fromUser;
  let num;
  let token;
  let fromUserName;
  let payload;
  return Promise.all([getNotificationItemPromise, getToUserPromise])
  .then(results => {
    notificationItem = results[0];
    toUser = results[1];
    console.log("getNotificationItemPromise notificationItem :", notificationItem)
    console.log("getToUserPromise toUser :", toUser)
    console.log("getToUserPromise toUser その２:", toUser.data())
    num = notificationItem.data().num;
    toGender = toUser.data().gender;
    toUserOriginId = toUser.data().originId;
    console.log("toUserOriginId:", toUserOriginId)
    currentBadgeNum = toUser.data().badgeNum;
    token = toUser.data().fcmToken;
    const getFromUserPromise = notificationItem.data().from.get();
    return Promise.all([getFromUserPromise])
    .then(results => {
      fromUser = results[0];
      console.log("getFromUserPromise fromUser (最後のPromise):", fromUser);
      fromUserName = fromUser.data().displayName;
      if (toGender === 1) {
        payload = {
          notification: {
            title: '@' + fromUserName + '「あなたは?番目にイケメンだわ！」',
            body: '今すぐ順位をチェック！',
            badge: String(currentBadgeNum + 1),
            sound: 'scrach.m4a',
          },
          data: {
            fromName: fromUserName,
            toUserOriginId: toUserOriginId,
            num: num,
          }
        };
      } else {
        payload = {
          notification: {
            title:  '@' + fromUserName + '「君は?番目にカワイイよ！」',
            body: '今すぐ順位をチェック！',
            badge: String(currentBadgeNum + 1),
            sound: 'scrach.m4a'
          },
          data: {
            fromName: fromUserName,
            toUserOriginId: toUserOriginId,
            num: num,
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
    .catch(error => {
        console.log("Error update toUser:", error);
      })
    })
  })
