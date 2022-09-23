----- My second WHILE LOOP ---- (to be continued...)
---- My goal is to have multiple conditions:
--- IF @@ROWCOUNT is 0 for any given year THEN move to the next year


   --GET RID OF THE SILVERFISH :)

USE Lahman
DECLARE @yearID smallint
SET NOCOUNT ON
SET @yearID = (SELECT MIN(yearID) FROM Batting)
WHILE @yearID <= 2021
	BEGIN 
	
		SELECT P.FullName, B.yearID, HR
		FROM Batting as B
		JOIN AllPlayers as P on B.playerID = P.playerID and B.yearID = P.yearID
		WHERE @yearID = B.yearID and HR >= 60
		GROUP BY P.FullName, B.yearID, HR
	
	PRINT 'The number of players who hit 60+ Home Runs in ' + convert(varchar(10),@yearID) + ' was ' + convert(varchar(10),@@ROWCOUNT)
	SET @yearID = @yearID + 1
	
	END



	SELECT COUNT(1), yearID
	FROM Batting
	WHERE yearID >= 1996 and HR >= 60
	GROUP BY yearID












