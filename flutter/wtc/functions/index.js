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

// Create and deploy your first functions
// https://firebase.google.com/docs/functions/get-started

// exports.helloWorld = onRequest((request, response) => {
//   logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
