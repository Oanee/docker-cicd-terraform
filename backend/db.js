const db = require("./app/models");

db.mongoose.set("strictQuery", false);

const uri = `${db.url}/${db.dbName}`;

db.mongoose
  .connect(uri)
  .then(() => {
    console.log("connected to database");
  })
  .catch((err) => {
    console.log("Error: Cannot connect to the database...see: ", err);
    process.exit(1);
  });

module.exports = db;
