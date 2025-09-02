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
 * Formats game type names by removing "Reports" and formatting to Title Case.
 * Examples:
 * - "sightWordReports" → "Sight Word"
 * - "placesReports" → "Places"
 * - "colorsReports" → "Colors"
 * @param {string} gameType - The game type string to format.
 * @return {string} The formatted game name without "Reports".
 */
function formatGameType(gameType: string): string {
  return gameType
    .replace(/Reports$/, "")
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
      "placesReports",
      "objectsReports",
      "foodsReports",
      "feelingsReports",
      "colorsReports",
      "actionsReports",
      "shapesReports",
      "mixedLettersReports",
      "uppercaseLettersReports",
      "lowercaseLettersReports",
      "numbersReports",
    ];
    const summary: Record<string, unknown> = {};
    const collectionsToDelete: admin.firestore.CollectionReference[] = [];

    for (const game of gameTypes) {
      const gameCollection = db
        .collection("users")
        .doc(userId)
        .collection(game);

      const reportsSnapshot = await gameCollection.get();

      // Skip if no reports for this game
      if (reportsSnapshot.empty) {
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

    // Check if there's any activity to report
    const hasActivity = Object.keys(summary).length > 0;

    let emailContent: string;
    if (hasActivity) {
      const tableRows = Object.entries(summary)
        .map(([key, value], index) => {
          if (typeof value === "object" && value !== null) {
            const data = value as {
              roundsPlayed: number,
              totalCorrect: number,
              totalIncorrect: number,
              averageDuration: number
            };
            const rowBg = index % 2 === 0 ? "#f9f9f9" : "#ffffff";
            const gameName = formatGameType(key);
            const duration = `${data.averageDuration} seconds`;
            return `
              <tr style="background-color: ${rowBg};">
                <td style="padding: 12px 15px; border-bottom: 1px solid 
                  #e0e0e0; font-weight: 500; color: #333;">${gameName}</td>
                <td style="padding: 12px 15px; text-align: center; 
                  border-bottom: 1px solid #e0e0e0; color: #555;">
                  ${data.roundsPlayed}</td>
                <td style="padding: 12px 15px; text-align: center; 
                  border-bottom: 1px solid #e0e0e0; color: #4CAF50; 
                  font-weight: 500;">${data.totalCorrect}</td>
                <td style="padding: 12px 15px; text-align: center; 
                  border-bottom: 1px solid #e0e0e0; color: #f44336; 
                  font-weight: 500;">${data.totalIncorrect}</td>
                <td style="padding: 12px 15px; text-align: center; 
                  border-bottom: 1px solid #e0e0e0; color: #555;">
                  ${duration}</td>
              </tr>
            `;
          }
          return "";
        })
        .join("");

      emailContent = `
        <div style="font-family: Arial, sans-serif; 
          color: #333; padding: 20px;">
          <h2 style="color: #4CAF50;">Your Weekly Game Summary</h2>
          <p>Hi there! Here's what you achieved this week:</p>

          <table style="width: 100%; border-collapse: collapse; 
            margin: 20px 0; background-color: #fff; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.1); 
            border-radius: 8px; overflow: hidden;">
            <thead>
              <tr style="background: linear-gradient(135deg, #4CAF50, 
                #45a049); color: white;">
                <th style="padding: 15px; text-align: left; 
                  font-weight: 600; border-bottom: 2px solid #fff;">
                  Game</th>
                <th style="padding: 15px; text-align: center; 
                  font-weight: 600; border-bottom: 2px solid #fff;">
                  Rounds Played</th>
                <th style="padding: 15px; text-align: center; 
                  font-weight: 600; border-bottom: 2px solid #fff;">
                  Correct</th>
                <th style="padding: 15px; text-align: center; 
                  font-weight: 600; border-bottom: 2px solid #fff;">
                  Incorrect</th>
                <th style="padding: 15px; text-align: center; 
                  font-weight: 600; border-bottom: 2px solid #fff;">
                  Avg Duration</th>
              </tr>
            </thead>
            <tbody>
              ${tableRows}
            </tbody>
          </table>

          <p style="margin-top: 20px;">Keep up the great work! 🚀</p>
          <hr />
          <p style="font-size: 12px; color: #888;">
            This is an automated message from your app.
          </p>
        </div>
      `;
    } else {
      emailContent = `
        <div style="font-family: Arial, sans-serif; 
          color: #333; padding: 20px;">
          <h2 style="color: #4CAF50;">Your Weekly Game Summary</h2>
          <p>Hi there!</p>
          
          <div style="background-color: #f5f5f5; padding: 15px; 
            border-radius: 8px; text-align: center;">
            <p style="font-size: 18px; color: #666; margin: 0;">
              📊 No activity for this week</p>
          </div>

          <p style="margin-top: 20px;">
            We'd love to see you back in the game soon! 🎮</p>
          <hr />
          <p style="font-size: 12px; color: #888;">
            This is an automated message from your app.
          </p>
        </div>
      `;
    }

    await db.collection("mail").add({
      to: email,
      message: {
        subject: "Verbal Autism Weekly Game Summary 🎮",
        text: "Here's your weekly game summary!",
        html: emailContent,
      },
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
    });

    console.log(`✅ Weekly email queued for ${email}`);

    // Delete all documents from the collections after email is queued
    for (const collection of collectionsToDelete) {
      try {
        await deleteAllDocuments(collection);
        console.log(`🗑️ Deleted documents for user ${userId}`);
      } catch (deleteError) {
        const errorMsg = `❌ Error deleting documents for user ${userId}:`;
        console.error(errorMsg, deleteError);
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
