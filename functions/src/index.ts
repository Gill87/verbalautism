/**
 * Import function triggers from their respective submodules:
 *
 * import {onCall} from "firebase-functions/v2/https";
 * import {onDocumentWritten} from "firebase-functions/v2/firestore";
 *
 * See a full list of supported triggers at https://firebase.google.com/docs/functions
 */

import {onSchedule} from "firebase-functions/v2/scheduler";
import {onRequest} from "firebase-functions/v2/https";
import * as admin from "firebase-admin";

admin.initializeApp();
const db = admin.firestore();

// Scheduled function: runs every Sunday at 8am
export const weeklyEmailSummary = onSchedule({
  schedule: "0 8 * * 0", // Sunday 8:00 AM
  timeZone: "America/Los_Angeles",
}, async (event) => {
  console.log("Running weekly email summary...");

  try {
    const usersSnapshot = await db.collection("users").get();

    for (const userDoc of usersSnapshot.docs) {
      const userId = userDoc.id;
      const userData = userDoc.data();
      const email = userData.email;

      if (!email) {
        console.log(`Skipping user ${userId}: no email found.`);
        continue;
      }

      const gameTypes = [
        "sightWordReports",
      ];
      const summary: Record<string, any> = {};

      for (const game of gameTypes) {
        const reportsSnapshot = await db
          .collection("users")
          .doc(userId)
          .collection(game)
          .get();

        if (reportsSnapshot.empty) {
          summary[game] = {
            roundsPlayed: 0,
            totalCorrect: 0,
            totalIncorrect: 0,
            averageDuration: 0,
          };
          continue;
        }

        let totalCorrect = 0;
        let totalIncorrect = 0;
        let durationSum = 0;
        const roundsPlayed = reportsSnapshot.docs.length;

        for (const doc of reportsSnapshot.docs) {
          const data = doc.data();
          totalCorrect += data.correct || 0;
          totalIncorrect += data.incorrect || 0;
          durationSum += data.averageDuration || 0;
        }

        const averageDuration =
          roundsPlayed > 0 ? +(durationSum / roundsPlayed).toFixed(1) : 0;

        summary[game] = {
          roundsPlayed,
          totalCorrect,
          totalIncorrect,
          averageDuration,
        };
      }

      // Add email to Firestore "mail" collection for Firebase Email Extension
      await db.collection("mail").add({
        to: email,
        message: {
          subject: "Weekly Game Summary",
          text: JSON.stringify(summary, null, 2),
        },
      });

      console.log(`✅ Weekly email queued for ${email}`);
    }

    console.log("Weekly email summary completed for all users.");
  } catch (error) {
    console.error("Error running weekly email summary:", error);
  }
});

// Test endpoint using v2 syntax
export const testWeeklyEmailSummary = onRequest(
  async (req, res) => {
    try {
      // For testing, we'll call the function logic directly
      // Note: You can't directly call scheduled functions in v2
      await weeklyEmailSummary({} as any, {} as any);
      res.send("✅ Weekly email summary triggered successfully!");
    } catch (error) {
      console.error(error);
      res.status(500).send("❌ Error triggering weekly email summary");
    }
  });