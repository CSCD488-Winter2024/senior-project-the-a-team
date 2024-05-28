/**
 * Import function triggers from their respective submodules:
 *
 * const {onCall} = require("firebase-functions/v2/https");
 * const {onDocumentWritten} = require("firebase-functions/v2/firestore");
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

// const {onRequest} = require("firebase-functions/v2/https");
// const logger = require("firebase-functions/logger");

const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.deleteUser = functions.https.onCall(async (data, context) => {
  const uid = data.uid;
  try {
    await admin.auth().deleteUser(uid);
    return {message: "Successfully deleted user"};
  } catch (error) {
    // throw new functions.https.HttpsError("unknown", error.message, error);
  }
});

exports.deleteUserByEmail = functions.https.onCall(async (data, context) => {
  const identifier = data.identifier;
  try {
    const userRecord = await admin.auth().getUserByEmail(identifier);
    await admin.auth().deleteUser(userRecord.uid);
    return {message: "Successfully deleted user"};
  } catch (error) {
    // throw new functions.https.HttpsError("unknown", error.message, error);
  }
});

exports.sendPostNotification = functions.firestore.document('_posts/{PostID}').onWrite((change, context) => {
    const postID = context.params.PostID;

    if (!change.after.exists) { //Post deleted
        console.log('Post removed :(');
        return null;
    }

    const db = admin.firestore();
    const postRef = db.collection('_posts').doc(postID);

    return postRef.get().then(doc => {
        if (!doc.exists) {
            console.log('No such document!');
            return null;
        }

        const postData = doc.data();
        const header = postData.header;
        let body = postData.body;
        if (body.length > 20) body = body.substring(0, 20) + '...';
        const type = postData.type;
        const tags = postData.tags;

        const usersRef = db.collection('users').where('notificationToken', '!=', 'none');
        return usersRef.get().then(snapshot => {
            if (snapshot.empty) {
                console.log('No matching documents.');
                return null;
            }

            let tokens = [];
            console.log('post tags:', tags);

            snapshot.forEach(userDoc => {
                const userData = userDoc.data();
                const userTags = userData.tags;

                if (type === 'Alert') {
                    tokens.push(userData.notificationToken);
                } 
                else if (type === 'Post' || type === 'Event') {
                    tags.forEach(tag => {
                        if (userTags.includes(tag)) {
                            tokens.push(userData.notificationToken);
                        }
                    });
                }
                else{ //no notifs for job or volunteer
                    return null;
                }
            });

            if (tokens.length === 0) {
                return null;
            }
            if(!change.before.exists){ //Post is new, not update
                const notification = {
                    title: `New Post: ${header}`,
                    body: body,
                    image: "http://drive.google.com/uc?id=1SviebrgUNmd6dZVEwLTKJ3PiYt41pHqx"
                };
            }
            else{ //Post is update
                const notification = {
                    title: `Post Updated: ${header}`,
                    body: body,
                    image: "http://drive.google.com/uc?id=1SviebrgUNmd6dZVEwLTKJ3PiYt41pHqx"
                };
            }

            let messages = tokens.map(token => ({
                token: token,
                notification: notification,
            }));

            return admin.messaging().sendAll(messages).then(batchResponse => {
                if (batchResponse.failureCount > 0) {
                    batchResponse.responses.forEach((resp, idx) => {
                        if (!resp.success) {
                            console.error('Failure sending message to', messages[idx].token, resp.error);
                        }
                    });
                }
                return null;
            }).catch(error => {
                console.error('Error sending messages:', error);
            });
        });
    }).catch(error => {
        console.error('Error getting document:', error);
    });
});

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
