module.exports = {
  url: process.env.MONGO_URI || "mongodb://127.0.0.1:27017",
  dbName: process.env.DATABASE_NAME || "app",
};
