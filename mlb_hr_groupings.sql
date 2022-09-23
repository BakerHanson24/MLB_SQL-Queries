
DROP TABLE IF EXISTS #historical_hr_groupings
CREATE TABLE #historical_hr_groupings(
num_players int,
HR_groupings varchar(50)
)
INSERT INTO #historical_hr_groupings
SELECT COUNT(*) as num_players, HR_groupings
FROM #count_hr_groupings
GROUP BY HR_groupings
ORDER BY HR_groupings desc

CREATE TABLE #count_hr_groupings(
playerID varchar(50),
yearID int,
HR int,
HR_groupings varchar(50))
INSERT INTO #count_hr_groupings
	SELECT *,
		CASE WHEN HR >= 70 THEN '70+'
			    WHEN HR >= 60 THEN '60-69'
				WHEN HR >= 50 THEN '50-59'
				WHEN HR >= 40 THEN '40-49'
				WHEN HR >= 30 THEN '30-39'
				WHEN HR >= 20 THEN '20-29'
				WHEN HR >= 10 THEN '10-19'
				ELSE '0-9' END AS HR_groupings
FROM 
    (
		SELECT playerID, yearID, SUM(HR) as HR
		FROM Lahman.dbo.Batting
		GROUP BY playerID, yearID
				) as count_hr_groupings

)



SELECT *
FROM #historical_hr_groupings
ORDER BY HR_groupings desc



SELECT yearID, HR_groupings, COUNT(*) as count
FROM #count_hr_groupings
WHERE HR_groupings IN ('40-49','50-59','60-69','70+')
GROUP BY yearID, HR_groupings
ORDER BY yearID, HR_groupings

SELECT yearID, HR_groupings, COUNT(*) as count
FROM #count_hr_groupings
WHERE HR_groupings = '40-49'
GROUP BY yearID, HR_groupings
ORDER BY yearID, HR_groupings

