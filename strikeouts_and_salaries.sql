SELECT *
FROM #EMH

SELECT *
FROM Lahman.dbo.Batting as Batting
ALTER TABLE Lahman.dbo.Batting
ALTER COLUMN HR int



CREATE TABLE #historical_hr_groupings (
   num_players int,
   HR_groupings varchar(20) 
   )


INSERT INTO #historical_hr_groupings
WITH home_run_fun AS (
     SELECT playerID, yearID, SUM(HR) as HR
	 FROM Lahman.dbo.Batting
	 GROUP BY playerID, yearID
	 )
SELECT COUNT(*) as num_players, HR_groupings
FROM (
SELECT *,
       CASE WHEN HR >= 70 THEN '70+'
	        WHEN HR >= 60 THEN '60-69'
			WHEN HR >= 50 THEN '50-59'
			WHEN HR >= 40 THEN '40-49'
			WHEN HR >= 30 THEN '30-39'
			WHEN HR >= 20 THEN '20-29'
			WHEN HR >= 10 THEN '10-19'
			ELSE '0-9' END AS HR_groupings
FROM home_run_fun
 ) as count_hr_groups
 GROUP BY HR_groupings
 ORDER BY HR_groupings desc














DROP TABLE IF EXISTS #pitcher300money
CREATE TABLE #pitcher300money (
pitcher varchar(100),
yearID int,
teamID char(3),
K int,
salary int,
dollars_per_k int
)


INSERT INTO #pitcher300money
SELECT a.playerID as pitcher,
       a.yearID as yearID,
	   b.teamID as teamID,
       SUM(a.SO) as K,
	   SUM(b.salary) as salary,
	   SUM(b.salary) / SUM(a.SO) as dollars_per_k
FROM Lahman.dbo.Pitching as a
LEFT JOIN Lahman.dbo.Salaries as b 
ON a.playerID = b.playerID AND a.yearID = b.yearID
WHERE a.yearID >= 1985
GROUP BY a.playerID, a.yearID, b.teamID, salary
HAVING SUM(a.SO) >= 300
ORDER BY pitcher, yearID

SELECT *
FROM #pitcher300money


SELECT yearID, 
       lgID, 
	   AVG(salary)/1000000.0 as average_salary_in_millions,
	   SUM(salary)/1000000.0 as total_in_millions, 
	   MAX(salary)/1000000.0 as highest_paid_player_in_millions
FROM Lahman.dbo.Salaries
GROUP BY yearID, lgID
ORDER BY yearID, lgID