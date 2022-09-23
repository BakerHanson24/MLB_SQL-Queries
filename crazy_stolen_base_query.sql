SELECT *
FROM Lahman.dbo.Batting


SELECT yearID,
       SUM(CAST(SB as int)) as SB,
	   SUM(CAST(CS as int)) as CS,
	   (SUM(CAST(SB as int)) + SUM(CAST(CS as int))) as attempts,
	   ROUND(100 * ((SUM(CAST(SB as float)) / (SUM(CAST(SB as float)) + SUM(CAST(CS as float))))),2) as SB_percent
FROM Lahman.dbo.Batting
WHERE CS IS NOT NULL AND CS <> 0
GROUP BY yearID
ORDER BY SB_percent desc,
         yearID