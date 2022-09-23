-- CREATE Braves vs. Astros TEMP TABLE --


SELECT yearID, round,
		CONCAT(teamIDwinner, ' vs. ', teamIDloser) AS face_off,
		wins,
		losses,
		teamIDwinner, teamIDloser
INTO #Braves_Vs_Astros
FROM Lahman.dbo.SeriesPost
WHERE teamIDwinner IN ('ATL', 'HOU') OR teamIDloser IN ('ATL', 'HOU');


-- Query the TEMP TABLE

SELECT * FROM #Braves_Vs_Astros
WHERE face_off IN ('ATL vs. HOU', 'HOU vs. ATL')


SELECT * FROM #Braves_Vs_Astros
WHERE (teamIDwinner = 'ATL' AND teamIDloser = 'HOU') OR (teamIDwinner = 'HOU' AND teamIDloser = 'ATL');