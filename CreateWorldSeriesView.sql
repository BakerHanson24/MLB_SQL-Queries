-- Take a look at SeriesPost and Teams tables --
SELECT * 
FROM SeriesPost 
WHERE yearID >= 1903 and round = 'ws'

SELECT *
FROM Teams as T
WHERE yearID >= 1903 and WSWin = 'y'


---- Creating the World Series View!! :) -----
CREATE VIEW WorldSeries on dbo.SeriesPost as


SELECT ROW_NUMBER() over (ORDER BY SP.yearID) as WS_id,
		sp.yearID as yearID,
		[round],
		name,
		teamIDwinner as WinningFranchise,
		lgIDwinner,
		teamIDloser as LosingTeam,
		lgIDloser,
		wins,
		wins + losses as wsLength,
		divID,
		Rank,
		G,
		ROUND((W/G)*1.0,3) as winPerc,
		W, L,
		ROUND((AB/H)*1.0,3) as AVG,
		(AB + BB + HBP + SF) as PA,
		AB, R, H, _2B, _3B, HR, SO, SB, CS, HBP, SF, RA, ER, ERA, CG, SHO, SV, IPouts*1.0/3 as IP, HA, HRA, BBA, SOA, E, DP, FP, park as ballpark, attendance, BPF, PPF
FROM SeriesPost as SP
LEFT join Teams as T on SP.yearID = t.yearID and sp.teamIDwinner = t.franchID
WHERE sp.yearID >= 1903 and [round] = 'WS'
ORDER BY sp.yearID


SELECT * FROM SeriesPost WHERE yearID >= 1903 and round = 'ws'
SELECT *
FROM Teams as T
WHERE yearID >= 1903 and WSWin = 'y'


---- Simplified World Series View (for now) ----
---------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------
SELECT * FROM WorldSeries
SELECT * FROM Teams
SELECT * FROM SeriesPost
INSERT INTO WorldSeries

CREATE VIEW WorldSeries as
SELECT ROW_NUMBER() over (ORDER BY T.yearID) as WS_id,
		t.yearID, sp.round, lgIDwinner, teamIDwinner, franchID as winning_fran, lgIDloser, sp.wins, sp.losses, t.R, t.RA, W, L, (t.r - t.ra) as run_diff,
		t.ERA, t.name, t.park as ballpark, t.attendance as season_attendance
FROM Teams as T
LEFT JOIN SeriesPost as sp 
ON t.yearID = sp.yearID
WHERE T.yearID >= 1903 and sp.round = 'WS' and t.WSWin = 1

DROP TABLE WorldSeries
DROP VIEW WorldSeries
----------------------------------------------------------------------------------

-- even SIMPLER version --

SELECT * FROM Teams
SELECT * FROM SeriesPost

USE Lahman
DROP VIEW dbo.WorldSeries
GO
CREATE VIEW WorldSeries AS
WITH Win AS (
SELECT ROW_NUMBER() over (ORDER BY SP.yearID) as WS_id,
		SP.yearID as Year,
		name as Winner,
		(SP.wins + SP.losses) as Games
FROM SeriesPost as SP
JOIN Teams as T
ON SP.yearID = T.yearID
WHERE SP.yearID >= 1903 and WSWin = 1 and SP.round = 'WS'
)
,
	Loss AS (
SELECT ROW_NUMBER() over (ORDER BY SP.yearID) as WS_id,
		SP.yearID as Year,
		name as Loser
FROM SeriesPost as SP
LEFT JOIN Teams as T
ON SP.yearID = T.yearID
WHERE SP.yearID >= 1903 and WSWin = 0 and LgWin = 'Y' and SP.round = 'WS'
)

SELECT Win.WS_id, Win.Year, Win.Winner, Loss.Loser, Win.Games
FROM Win
JOIN Loss
ON Win.WS_id = Loss.WS_id and Win.Year = Loss.Year


GO


SELECT * FROM WorldSeries

DECLARE @streak tinyint = 1
;
GO
CREATE VIEW WorldSeriesStreaks AS
WITH Step1 AS
(
SELECT WS_id, Year, LAG(Winner) over (ORDER BY WS_id) as LastWinner,
		Winner,
		1 as Streak,
		Loser,
		Games
FROM WorldSeries
)
,
Step2 AS
(
SELECT WS_id, Year, Winner, IIF(LAG(Winner) over (ORDER BY WS_id) = Winner, LAG(Streak) over (ORDER BY WS_id) + 1, 1) as Streak, Loser, Games
FROM Step1
)
,
Step3 AS
(
SELECT WS_id, Year, Winner, IIF(LAG(Winner) over (ORDER BY WS_id) = Winner, LAG(Streak) over (ORDER BY WS_id) + 1, 1) as Streak, Loser, Games
FROM Step2
)
,
Step4 AS
(
SELECT WS_id, Year, Winner, IIF(LAG(Winner) over (ORDER BY WS_id) = Winner, LAG(Streak) over (ORDER BY WS_id) + 1, 1) as Streak, Loser, Games
FROM Step3
)
,
Step5 AS
(
SELECT WS_id, Year, Winner, IIF(LAG(Winner) over (ORDER BY WS_id) = Winner, LAG(Streak) over (ORDER BY WS_id) + 1, 1) as Streak, Loser, Games
FROM Step4
)
SELECT *
FROM Step5
--ORDER BY WS_id
GO


--- Alright, Lord, how do I calculate a Streak??

-- IF the previous row is identical to the current row
			-- THEN I want to increase the streak value by 1
			-- ELSE I want the streak value to reset to 1


SELECT WS_id,
		Year,
		(SELECT LAG(Winner) OVER (PARTITION BY Winner ORDER BY WS_id) FROM WorldSeries) as LastYear
FROM WorldSeries



SELECT Streak, COUNT(1) as NumTeams
FROM WorldSeriesStreaks
GROUP BY Streak