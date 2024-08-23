const mysql = require("mysql2/promise");

const connection = mysql.createPool({
  host: "localhost",
  user: "root",
  password: "scarman708",
  database: "social",
});

module.exports = connection;
