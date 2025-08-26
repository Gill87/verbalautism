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
/**
 * Formats a camelCase or PascalCase string into a Title Case label.
 * Inserts spaces before capital letters and capitalizes the first character.
 * Examples:
 * - "sightWordReports" → "Sight Word Reports"
 * - "totalCorrect" → "Total Correct"
 * - "averageDuration" → "Average Duration"
 * @param {string} key - The camelCase or PascalCase string to format.
 * @return {string} The formatted, human-readable label.
 */
function formatKey(key: string): string {
  return key
    .replace(/([A-Z])/g, " $1")
    .replace(/^./, (str: string) => str.toUpperCase())
    .trim();
}

/**
 * Helper function to delete all documents in a collection
 * @param {admin.firestore.CollectionReference} collectionRef - Collection ref
 */
async function deleteAllDocuments(
  collectionRef: admin.firestore.CollectionReference
) {
  const snapshot = await collectionRef.get();

  if (snapshot.empty) {
    return;
  }

  // Create batch to delete documents efficiently
  const batch = db.batch();
  snapshot.docs.forEach((doc) => {
    batch.delete(doc.ref);
  });

  await batch.commit();
  console.log(`✅ Deleted ${snapshot.docs.length} documents from collection`);
}

/**
 * Main logic for processing weekly email summaries
 */
async function runWeeklyEmailSummaryLogic() {
  console.log("Running weekly email summary...");

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
    const summary: Record<string, unknown> = {};
    const collectionsToDelete: admin.firestore.CollectionReference[] = [];

    for (const game of gameTypes) {
      const gameCollection = db
        .collection("users")
        .doc(userId)
        .collection(game);

      const reportsSnapshot = await gameCollection.get();

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
        roundsPlayed > 0 ?
          +(durationSum / roundsPlayed).toFixed(1) : 0;

      summary[game] = {
        roundsPlayed,
        totalCorrect,
        totalIncorrect,
        averageDuration,
      };

      // Store collection reference for deletion after email is sent
      collectionsToDelete.push(gameCollection);
    }


    await db.collection("mail").add({
      to: email,
      message: {
        subject: "🎮 Weekly Game Summary",
        text: "Here's your weekly game summary!",
        html: `
          <div style="font-family: Arial, sans-serif; 
            color: #333; padding: 20px;">
            <h2 style="color: #4CAF50;">Your Weekly Game Summary</h2>
            <p>Hi there! Here's what you achieved this week:</p>

            <ul style="line-height: 1.6;">
              ${Object.entries(summary)
    .map(([key, value]) => {
      if (typeof value === "object" && value !== null) {
        return `
                      <li>
                        <strong>${formatKey(key)}:</strong>
                        <ul style="margin-left: 20px; line-height: 1.4;">
                          ${Object.entries(value)
    .map(
      ([subKey, subVal]) =>
        `<li><strong>${formatKey(subKey)}:</strong> ${subVal}</li>`
    )
    .join("")}
                        </ul>
                      </li>
                    `;
      } else {
        return `<li><strong>${formatKey(key)}:</strong> ${value}</li>`;
      }
    })
    .join("")}
            </ul>

            <p style="margin-top: 20px;">Keep up the great work! 🚀</p>
            <hr />
            <p style="font-size: 12px; color: #888;">
              This is an automated message from your app.
            </p>
          </div>
        `,
      },
    });

    console.log(`✅ Weekly email queued for ${email}`);

    // Delete all documents from the collections after email is queued
    for (const collection of collectionsToDelete) {
      try {
        await deleteAllDocuments(collection);
        console.log(`🗑️ Deleted documents for user ${userId}`);
      } catch (deleteError) {
        console.error(`❌ Error deleting documents for user ${userId}:`,
          deleteError);
        // Continue processing other users even if deletion fails
      }
    }
  }

  console.log("Weekly email summary completed for all users.");
}

// Scheduled function: runs every Sunday at 8am
export const weeklyEmailSummary = onSchedule({
  schedule: "0 8 * * 0", // Sunday 8:00 AM
  timeZone: "America/Los_Angeles",
}, async () => {
  try {
    await runWeeklyEmailSummaryLogic();
  } catch (error) {
    console.error("Error running weekly email summary:", error);
  }
});

// Test endpoint using v2 syntax
export const testWeeklyEmailSummary = onRequest(
  async (req, res) => {
    try {
      await runWeeklyEmailSummaryLogic();
      res.send("✅ Weekly email summary triggered successfully!");
    } catch (error) {
      console.error("Error in test function:", error);
      res.status(500).send(`❌ Error: ${error}`);
    }
  });
