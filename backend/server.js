const express = require('express');
const app = express();
const session = require('express-session');
const path = require('path');
const dotenv = require('dotenv');
const connection = require('./database.js');

dotenv.config();

app.use(session({
  secret: 'secret',
  resave: true,
  saveUninitialized: true
}));

app.use(express.static(path.join(__dirname, '../public')));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

app.set('view engine', 'ejs');

app.get('/login', (req, res) => {
  res.render('login');
});
app.get('/homegape', (req, res) => {
  res.render('homepage');
});

app.post('/login', (req, res) => { // Change the route to handle POST requests to "/login"
  const email = req.body.email;
  const password = req.body.password;

  if (email && password) {
    connection.query('SELECT * FROM users WHERE email = ? AND password = ?', [email, password], (error, results, fields) => {
      if (error) throw error;

      if (results.length > 0) {
        req.session.loggedin = true;
        req.session.email = email;
        res.redirect('/homepage');
      } else {
        res.send('Incorrect Username and/or Password!');
      }
    });
  } else {
    res.send('Please enter Username and Password!');
  }
});

app.get('/homepage', (req, res) => {
  if (req.session.loggedin) {
    res.send('Welcome back, ' + req.session.email + '!');
  } else {
    res.send('Please login to view this page!');
  }
});

app.listen(3000, () => {
  console.log('Server started on port 3000');
});
