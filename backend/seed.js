require("dotenv").config();
const csv = require("csv-parser");
const fs = require("fs");
const MongoClient = require("mongodb").MongoClient;
const bcrypt = require("bcrypt");
const { BCRYPT_WORK_FACTOR } = require("./config.js");
const db = require("./app/models");
const Homes = db.Homes;

const url = process.env.MONGO_URI;
if (!url) {
  console.error("❌ MONGO_URI is missing from .env");
  process.exit(1);
}

const dbName = process.env.MONGO_DB_NAME || "app";

function seedFile(filePath, processRowFn) {
  return new Promise((resolve, reject) => {
    const promises = [];
    fs.createReadStream(filePath)
      .pipe(csv())
      .on("data", (row) => {
        promises.push(processRowFn(row));
      })
      .on("end", async () => {
        try {
          await Promise.all(promises);
          resolve();
        } catch (error) {
          reject(error);
        }
      })
      .on("error", (err) => reject(err));
  });
}

MongoClient.connect(url)
  .then(async (client) => {
    const dbo = client.db(dbName);

    try {
      await seedFile("./seed_data/redfin_data.csv", async (row) => {
        const homeToInsert = new Homes(row);
        await dbo.collection("houses").insertOne(homeToInsert);
      });

      await seedFile("./seed_data/user_data.csv", async (row) => {
        const myObj = { ...row };
        myObj.password = await bcrypt.hash(myObj.password, BCRYPT_WORK_FACTOR);
        myObj.isAdmin = true;
        await dbo.collection("users").insertOne(myObj);
      });

      console.log("CSV files have been processed successfully");
    } catch (err) {
      console.error(err);
    } finally {
      await client.close();
    }
  })
  .catch((err) => {
    console.error(err);
  });
