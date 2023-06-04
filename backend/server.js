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

app.get('/homepage', (req, res) => {
  if (req.session.loggedin) {
    connection.query('SELECT * FROM Classroom', (error, results) => {
      if (error) {
        console.error('Error executing the query: ' + error.stack);
        res.send('An error occurred while fetching data from the database');
      } else {
        console.log(results); // Check the query results
        res.render('homepage', { data: results });
      }
    });
  } else {
    res.redirect('/login');
  }
});

app.get('/classroom/:name', (req, res) => {
  if (req.session.loggedin) {
    const classroomName = req.params.name;

    connection.query('SELECT * FROM Classroom WHERE name = ?', [classroomName], (error, classroomResults) => {
      if (error) {
        console.error('Error executing the query: ' + error.stack);
        res.send('An error occurred while fetching classroom details from the database');
      } else {
        if (classroomResults.length > 0) {
          const classroom = classroomResults[0];

          connection.query('SELECT * FROM Reservation WHERE classroom_name = ?', [classroomName], (error, reservationResults) => {
            if (error) {
              console.error('Error executing the query: ' + error.stack);
              res.send('An error occurred while fetching reservations from the database');
            } else {
              res.render('classroom', { classroom: classroom, reservations: reservationResults });
            }
          });
        } else {
          res.send('Classroom not found');
        }
      }
    });
  } else {
   // res.redirect('/login');
  }
});

app.post('/login', (req, res) => {
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


app.listen(3000, () => {
  console.log('Server started on port 3000');
});