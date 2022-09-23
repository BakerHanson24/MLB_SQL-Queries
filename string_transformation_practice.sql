WITH mariners01 AS (
SELECT * FROM Lahman.dbo.Batting WHERE yearID = 2001 AND teamID = 'sea'
)


SELECT playerID,
	   REPLACE(playerID,
		LEFT(playerID, CHARINDEX('0', playerID) - 1),
	   'EliseIsAMegaHottie')
FROM mariners01

