--Ken Griffey Jr HR by year --

WITH GriffeyJr AS (
SELECT * FROM Lahman.dbo.Batting WHERE playerID = 'griffke02'
)

SELECT playerID, 
       yearID,
	   LAG(HR,1) OVER(ORDER BY playerID) AS prev_HR,
	   HR,
	   LEAD(HR,1) OVER(ORDER BY playerID) AS next_HR
FROM GriffeyJr
ORDER BY yearID;


--Ken Griffey Sr HR by year--

WITH GriffeySr AS (
SELECT * FROM Lahman.dbo.Batting WHERE playerID = 'griffke01'
)


SELECT playerID, 
       yearID,
	   LAG(HR,1) OVER(ORDER BY playerID) AS prev_HR,
	   HR,
	   LEAD(HR,1) OVER(ORDER BY playerID) AS next_HR
FROM GriffeySr
ORDER BY yearID;


-- Randy Johnson K's by year --
SELECT playerID, yearID,
       LAG(SUM(SO),1) OVER(ORDER BY yearID) as last_K,
       SUM(SO) as K,
	   LEAD(SUM(SO),1) OVER(ORDER BY yearID) as next_K
FROM Lahman.dbo.Pitching
WHERE playerID = 'johnsra05'
GROUP BY playerID, yearID
ORDER BY playerID, yearID



--Randy Johnson K's by Team--
SELECT playerID, teamID,
       LAG(SUM(SO),1) OVER(ORDER BY playerID) as last_K,
       SUM(SO) as K,
	   LEAD(SUM(SO),1) OVER(ORDER BY playerID) as next_K
FROM Lahman.dbo.Pitching
WHERE playerID = 'johnsra05'
GROUP BY playerID, teamID
ORDER BY playerID, last_K