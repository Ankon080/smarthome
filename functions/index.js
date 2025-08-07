const functions = require("firebase-functions");
const admin = require("firebase-admin");

admin.initializeApp();

exports.sendNotification = functions.database
    .ref("/smoke_detection/smokestatus")
    .onUpdate((change, context) => {
      const newValue = change.after.val();

      if (newValue === 1) {
        return admin.messaging().sendToTopic("smoke-alert", {
          notification: {
            title: "Smoke Alert",
            body: "Smoke detected!",
          },
        });
      }

      return null;
    });
