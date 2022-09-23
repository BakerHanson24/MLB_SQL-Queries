CREATE TABLE softball (
  lineup INT,
  player VARCHAR(30),
  l_r VARCHAR(10),
  birthdate DATE
  )


INSERT INTO softball
(lineup, player, l_r, birthdate)
VALUES
(2, 'Elise Hanson', 'L', '1994-11-18'),
(3, 'Courtney Hacker', 'R', '1989-12-14')

SELECT *
FROM softball
ORDER BY lineup

UPDATE
  softball
SET lineup = 3
WHERE player LIKE 'R%'

DELETE FROM
  softball
WHERE
  lineup = 2

DECLARE @lineup INT
DECLARE @birthdate DATE

SET @lineup = 4
SET @birthdate = '1991-01-01'

SELECT *
FROM softball
WHERE @lineup >= lineup 
   AND @birthdate > birthdate