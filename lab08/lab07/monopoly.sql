SET search_path TO monopoly;

-- Drop previous versions of the tables if they exist, in reverse order of foreign keys.
DROP TABLE IF EXISTS PlayerProperty;
DROP TABLE IF EXISTS House;
DROP TABLE IF EXISTS Hotel;
DROP TABLE IF EXISTS Property;
DROP TABLE IF EXISTS PlayerGame;
DROP TABLE IF EXISTS Player;
DROP TABLE IF EXISTS Game;

-- Create the schema.
CREATE TABLE Game (
    ID SERIAL PRIMARY KEY,
    time timestamp
);

CREATE TABLE Player (
    ID SERIAL PRIMARY KEY,
    emailAddress varchar(50) NOT NULL,
    name varchar(50),
    cash INTEGER,
    position INTEGER
);

CREATE TABLE PlayerGame (
    gameID integer REFERENCES Game(ID),
    playerID integer REFERENCES Player(ID),
    score integer
);

CREATE TABLE Property (
    ID SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    cost INTEGER NOT NULL,
    ownerID INTEGER REFERENCES Player(ID)
);

CREATE TABLE House (
    ID SERIAL PRIMARY KEY,
    propertyID INTEGER REFERENCES Property(ID)
);

CREATE TABLE Hotel (
    ID SERIAL PRIMARY KEY,
    propertyID INTEGER REFERENCES Property(ID)
);

CREATE TABLE PlayerProperty (
    playerID INTEGER REFERENCES Player(ID),
    propertyID INTEGER REFERENCES Property(ID),
    houses INTEGER,
    hotels INTEGER
);

-- Grant access to the tables
GRANT SELECT ON Game TO PUBLIC;
GRANT SELECT ON Player TO PUBLIC;
GRANT SELECT ON PlayerGame TO PUBLIC;
GRANT SELECT ON Property TO PUBLIC;
GRANT SELECT ON House TO PUBLIC;
GRANT SELECT ON Hotel TO PUBLIC;
GRANT SELECT ON PlayerProperty TO PUBLIC;

-- Add sample records for the original tables
INSERT INTO Game (time) VALUES ('2006-06-27 08:00:00');
INSERT INTO Game (time) VALUES ('2006-06-28 13:20:00');
INSERT INTO Game (time) VALUES ('2006-06-29 18:41:00');
INSERT INTO Game (time) VALUES ('2024-10-29 09:23:00');

INSERT INTO Player(ID, emailAddress, name, cash, position) VALUES (1, 'me@calvin.edu', 'Me', 1500, 0);
INSERT INTO Player(ID, emailAddress, name, cash, position) VALUES (2, 'king@gmail.edu', 'The King', 1500, 0);
INSERT INTO Player(ID, emailAddress, name, cash, position) VALUES (3, 'dog@gmail.edu', 'Dogbreath', 1500, 0);
INSERT INTO Player(ID, emailAddress, name, cash, position) VALUES (4, 'crv37@calvin.edu', 'Chase', 1500, 0);
INSERT INTO Player(ID, emailAddress, name, cash, position) VALUES (5, 'null@calvin.edu', NULL, 1500, 0);
INSERT INTO Player(ID, emailAddress, name, cash, position) VALUES (6, 'smith@calvin.edu', 'Smith', 1500, 0);
INSERT INTO Player(ID, emailAddress, name, cash, position) VALUES (7, 'brad@gmail.com', 'Brad', 1500, 0);


INSERT INTO PlayerGame(gameID, playerID, score) VALUES (1, 1, 0);
INSERT INTO PlayerGame(gameID, playerID, score) VALUES (1, 2, 9999);
INSERT INTO PlayerGame(gameID, playerID, score) VALUES (1, 3, 2350);
INSERT INTO PlayerGame(gameID, playerID, score) VALUES (2, 1, 1000);
INSERT INTO PlayerGame(gameID, playerID, score) VALUES (2, 2, 0);
INSERT INTO PlayerGame(gameID, playerID, score) VALUES (2, 3, 500);
INSERT INTO PlayerGame(gameID, playerID, score) VALUES (3, 2, 100);
INSERT INTO PlayerGame(gameID, playerID, score) VALUES (3, 3, 5500);
INSERT INTO PlayerGame(gameID, playerID, score) VALUES (4, 6, 3000);
INSERT INTO PlayerGame(gameID, playerID, score) VALUES (4, 7, 2999);

-- Add sample records for the new tables
INSERT INTO Property (name, cost, ownerID) VALUES ('Boardwalk', 400, 1);
INSERT INTO House (propertyID) VALUES (1);
INSERT INTO Hotel (propertyID) VALUES (1);
INSERT INTO PlayerProperty (playerID, propertyID, houses, hotels) VALUES (1, 1, 1, 1);


-- Exercise 8.1
SELECT * FROM Game
ORDER BY time DESC;

SELECT * FROM Game
WHERE time >= NOW() - INTERVAL '7 days';

SELECT * FROM Player
WHERE name IS NOT NULL;

SELECT DISTINCT playerID FROM PlayerGame
WHERE score > 2000;

SELECT * FROM Player
WHERE emailAddress LIKE '%@gmail.com';


-- Exercise 8.2
SELECT score
FROM PlayerGame
JOIN Player ON PlayerGame.playerID = Player.ID
WHERE Player.name = 'The King'
ORDER BY score DESC;

SELECT Player.name
FROM PlayerGame
JOIN Player ON PlayerGame.playerID = Player.ID
WHERE PlayerGame.gameID = (
  SELECT ID FROM Game WHERE time = '2006-06-28 13:20:00'
)
ORDER BY PlayerGame.score DESC
LIMIT 1;

-- What does that P1.ID < P2.ID clause do in the last example query 
-- P1.ID < P2.ID makes sure there are none of the same ID's to avoid duplicates.

-- Can you think of a realistic situation in which you’d want to join a table to itself?
-- A realistic situation could be for a hotel's booking system making sure no one can double book