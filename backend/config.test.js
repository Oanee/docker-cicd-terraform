describe("config can come from env", function () {
  test("Config comes", function () {
    process.env.SECRET_JWT_KEY = "123";
    process.env.PORT = "5001";
    process.env.MONGO_DB_NAME = "Something";
    process.env.NODE_ENV = "Something";

    const config = require("./config");
    expect(config.SECRET_JWT_KEY).toEqual("123");
    expect(config.PORT).toEqual("5001");
    expect(config.MONGO_DB_NAME).toEqual("Something");
    expect(config.BCRYPT_WORK_FACTOR).toEqual(12);

    delete process.env.SECRET_JWT_KEY;
    delete process.env.PORT;
    delete process.env.BCRYPT_WORK_FACTOR;
    delete process.env.MONGO_DB_NAME;

    expect(config.getDatabaseUri()).toEqual("app");
    process.env.NODE_ENV = "test";
    expect(config.getDatabaseUri()).toEqual("app_test");
  });
});
