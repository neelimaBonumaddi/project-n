const greeting = (name) => {
    console.log( `hello ${name}`);
};

const addDays = require("date-fns/addDays");
const result = addDays(new Date(2021, 0, 11), 10);

console.log(result);

greeting("neelima");
greeting("yaswanth");
greeting("vamsi");


const express = require("express");
const path = require("path");

const { open } = require("sqlite");
const sqlite3 = require("sqlite3");
const app = express();

const dbPath = path.join(__dirname, "goodreads.db");

let db = null;

const initializeDBAndServer = async () => {
  try {
    db = await open({
      filename: dbPath,
      driver: sqlite3.Database,
    });
    app.listen(3000, () => {
      console.log("Server Running at http://localhost:3000/");
    });
  } catch (e) {
    console.log(`DB Error: ${e.message}`);
    process.exit(1);
  }
};

initializeDBAndServer();