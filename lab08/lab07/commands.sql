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
-- A realistic situation could be for a hotel's booking system making sure no one can double book a room. 