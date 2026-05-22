const db = require("./app/models");

db.mongoose.set("strictQuery", false);

const dbName = process.env.MONGO_DB_NAME || db.dbName || "app";
let finalUri = process.env.MONGO_URI || db.url;
const options = {};

if (process.env.MONGO_USER && process.env.MONGO_PASS) {
  if (!finalUri.includes("@")) {
    const encodedPass = encodeURIComponent(process.env.MONGO_PASS);
    const user = process.env.MONGO_USER;
    const isSrv = finalUri.startsWith("mongodb+srv://");
    const cleanHost = finalUri.replace(/^mongodb(\+srv)?:\/\//, "");
    const protocol = isSrv ? "mongodb+srv://" : "mongodb://";

    finalUri = `${protocol}${user}:${encodedPass}@${cleanHost}`;
  }
}

if (finalUri.startsWith("mongodb+srv://")) {
  options.dbName = dbName;
} else {
  if (!finalUri.includes(`/${dbName}`)) {
    finalUri = finalUri.replace(/\/+$/, "");
    finalUri = `${finalUri}/${dbName}`;
  }
}
console.log(finalUri, options);
db.mongoose
  .connect(finalUri, options)
  .then(() => {
    console.log(`Connected successfully to database: ${dbName}`);
  })
  .catch((err) => {
    console.log("Error: Cannot connect to the database...see: ", err);
    process.exit(1);
  });

module.exports = db;
