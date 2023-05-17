const express = require("express");
const app = express();
const path = require("path");
const mysql = require("mysql");
const dotenv = require('dotenv');
const bcrypt = require("bcrypt");

// Serve static files from the "public" folder
app.use(express.static(path.join(__dirname, "../public")));

const connection = mysql.createConnection({
  host: 'localhost',
  user: 'root',
  password: 'root',
  database: 'university'
});

app.set("view engine", "ejs");

app.get('/login', (req, res) => {
  res.render("login.ejs");
});

app.get('/homepage', (req, res) => {
  res.render("index.js");
});

app.get('/login', (req, res) => {
  const { email, password } = req.query;

  const query = 'SELECT id, password_hash FROM users WHERE email = ?';

  connection.query(query, [email], (error, results) => {
    if (error) {
      console.error('Error executing the query:', error);
      return;
    }

    // Check if a user with the provided email exists
    if (results.length === 0) {
      console.log('User not found');
      return;
    }

    const user = results[0];
    const hashedPassword = user.password_hash;

    // Compare the provided password with the hashed password
    if (bcrypt.compareSync(password, hashedPassword)) {
      // Passwords match, login successful
      console.log('Login successful');
      // You can perform further actions or redirect the user to a dashboard page
      res.redirect('/homepage');
    } else {
      // Passwords don't match, login failed
      console.log('Invalid password');
      res.send('Invalid password');
    }
  });
});

app.listen(3000);
