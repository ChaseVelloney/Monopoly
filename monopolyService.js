const pgp = require('pg-promise')();
const express = require('express');
const cors = require('cors');

const db = pgp({
  host: process.env.DB_SERVER,
  port: 5432, // Port for PostgreSQL
  database: process.env.DB_DATABASE,
  user: process.env.DB_USER,
  password: process.env.DB_PASSWORD,
  ssl: { rejectUnauthorized: false },
});

const app = express();
const port = process.env.PORT || 3000;

app.use(cors()); // Enable CORS for all routes
app.use(express.json());

// Define routes
app.get('/', (req, res) => {
  res.send('Hello, CS 262 Monopoly service!');
});

app.get('/players', async (req, res, next) => {
  try {
    const data = await db.many('SELECT id, emailaddress AS email, name, cash, position FROM Player');
    res.send(data);
  } catch (err) {
    next(err);
  }
});

app.get('/players/:id', async (req, res, next) => {
  try {
    const data = await db.oneOrNone('SELECT * FROM Player WHERE id=${id}', req.params);
    if (data) {
      res.send(data);
    } else {
      res.sendStatus(404);
    }
  } catch (err) {
    next(err);
  }
});

app.get('/playerScores', async (req, res, next) => {
  try {
    const data = await db.many(`
      SELECT Player.name, Player.emailAddress, PlayerGame.score
      FROM Player
      JOIN PlayerGame ON Player.ID = PlayerGame.playerID
    `);
    res.send(data);
  } catch (err) {
    next(err);
  }
});

app.put('/players/:id', async (req, res, next) => {
  try {
    const data = await db.oneOrNone('UPDATE Player SET email=${body.email}, name=${body.name}, cash=${body.cash}, position=${body.position} WHERE id=${params.id} RETURNING id', req);
    if (data) {
      res.send(data);
    } else {
      res.sendStatus(404);
    }
  } catch (err) {
    next(err);
  }
});

app.post('/players', async (req, res, next) => {
  try {
    const data = await db.one('INSERT INTO Player(email, name, cash, position) VALUES (${email}, ${name}, ${cash}, ${position}) RETURNING id', req.body);
    res.send(data);
  } catch (err) {
    next(err);
  }
});

app.delete('/players/:id', async (req, res, next) => {
  try {
    const data = await db.oneOrNone('DELETE FROM Player WHERE id=${id} RETURNING id', req.params);
    if (data) {
      res.send(data);
    } else {
      res.sendStatus(404);
    }
  } catch (err) {
    next(err);
  }
});

app.listen(port, () => console.log(`Listening on port ${port}`));
