--Creating the World Series Table--
DROP TABLE IF EXISTS Lahman.dbo.WorldSeries
SELECT  ROW_NUMBER () OVER(ORDER BY b.yearID) as WS_id,
		b.yearID,
		b.round,
		a.lgID as winning_lg,
		a.teamID as winning_team,
		a.franchID as winning_fran,
		b.lgIDloser as losing_lg,
		b.teamIDloser as losing_team,
		b.wins,
		b.losses,
		a.R, 
		a.RA, 
		a.R-a.RA as run_diff, 
		a.ERA, 
		a.name, 
		a.park, 
		a.attendance as season_attendance
INTO Lahman.dbo.WorldSeries
FROM Lahman.dbo.Teams as a
JOIN Lahman.dbo.SeriesPost as b
ON a.yearID = b.yearID
WHERE a.WSWin = 'Y' AND b.yearID >= 1903 AND b.round = 'WS'
ORDER BY b.yearID


--Fun with World Series Queries--

SELECT WS_id,
		yearID,
		winning_lg,		
		COUNT(*) OVER (PARTITION BY winning_lg ORDER BY WS_id) as League_Count,
		winning_fran,
		COUNT(*) OVER (PARTITION BY winning_fran ORDER BY WS_id) as Franchise_Count,
		name
FROM Lahman.dbo.WorldSeries
ORDER BY WS_id




-- World Series Champs, Basic regular season stats --



WITH WSChamps_RegSeason AS (
SELECT yearID, franchID, G, 
	ROUND(CAST(W as float)/CAST(G as float), 3)	as win_perc, 
			W, L, R, RA, R - RA as run_diff FROM Lahman.dbo.Teams WHERE WSWin = 'Y' AND yearID > 1902
)

SELECT COUNT(W) as Count, W
FROM WSChamps_RegSeason
GROUP BY W
ORDER BY Count desc


-- Teams with best Regular Seasons to NOT win the World Series --

WITH ShatteredHopes AS (
SELECT yearID, franchID, G, 
	ROUND(CAST(W as float)/CAST(G as float), 3)	as win_perc, 
			W, L, R, RA, R - RA as run_diff FROM Lahman.dbo.Teams WHERE WSWin = 'N' AND yearID > 1902
)

SELECT * FROM ShatteredHopes ORDER BY run_diff desc;






-------


