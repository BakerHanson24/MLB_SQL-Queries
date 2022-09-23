---- Round 3 for WHILE LOOPS ----

---- CREATE A WHILE LOOP that spits out the HR leader for every Mariners team since 1977 ----

USE Lahman

DECLARE @yearID smallint = 1977
WHILE @yearID <= 2021
	BEGIN
		SELECT TOP (1) playerID, yearID, HR
		FROM Batting
		WHERE teamID = 'SEA' and @yearID = yearID
		ORDER BY HR desc
		SET @yearID = @yearID + 1
	END






----- No matter what, I want to increase the yearID by 1 each time.
----- But, I want different queries to run depending on IF 
----- the top HR hitter was OVER or UNDER 40 HR



--- Step 1:  increase the year by 1 no matter what


GO

DECLARE @yearID smallint = 1977
SET NOCOUNT ON

WHILE @yearID < 2022
	SELECT IIF(MAX(HR)>39,