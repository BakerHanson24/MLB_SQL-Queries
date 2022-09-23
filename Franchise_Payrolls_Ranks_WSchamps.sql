-- Want to discover the mean and median RANK in the yearly Payroll that a World Series winning team falls --


-- Exploring the Teams and Salaries tables in the Lahman database before joining them
SELECT * FROM Teams
SELECT * FROM Salaries



-- First: I'll use a series of CTE's to create a View called FranchisePayrolls_Ranked.
	-- The created View will tell us total Payroll information from each Franchise from
	-- 1985 to 2016, how their Payroll RANKs (1 means highest payroll), and lastly, whether
	-- or not that Franchise won the World Series that year.
GO
CREATE OR ALTER VIEW dbo.FranchisePayrolls_Ranked AS
WITH Step1 AS (
SELECT S.*,T.franchID,T.WSWin,T.name
FROM Salaries as S
LEFT JOIN Teams as T
ON S.yearID = T.yearID and S.lgID = T.lgID and S.teamID = T.teamID
)
,
-- in Step2 we'll aggregate the salary data to get the total Payroll for each Franchise:
Step2 AS (
SELECT yearID,lgID,franchID, SUM(salary) as Payroll, WSWin, name
FROM Step1
GROUP BY yearID,lgID,franchID, WSWin, name
)
-- note in the final step we need to use a window function in order to create the Pay_Rank column:
SELECT yearID, franchID, name, WSWin, Payroll,
		RANK() over (PARTITION BY yearID ORDER BY Payroll desc) as Pay_Rank
FROM Step2
GO



-- Let's start our new batch by Querying the new VIEW! --

SELECT *
FROM FranchisePayrolls_Ranked


-- Now that the View is created, we can have all sorts of fun.
-- For now, I want to discover the mean() Pay_Rank for World Series Champs from 1985 to 2016:


-- First, let's create a #temptable called #WSchamps_Payrolls so we can Query off of just World Series winners:

SELECT *
INTO #WSchamps_Payrolls
FROM FranchisePayrolls_Ranked
WHERE WSWin = 1


-- Double check the #temptable was created properly:

SELECT *
FROM #WSchamps_Payrolls


-- Yep, okay. Now let's find the mean() Pay_Rank!

SELECT AVG(Pay_Rank) as PayForGold
FROM #WSchamps_Payrolls


-- Hmm, the result is exactly `8` (eight).  But, I don't want an integer, I want a decimal value.
-- So, let's try this again but make sure the Pay_Rank column is the datatype we want:

SELECT AVG(convert(decimal(4,2),Pay_Rank)) as PayForGold
FROM #WSchamps_Payrolls


-- Alright!  The result is 8.225806 (yes, I could ROUND but maybe some other time)
-- But here's something to think about if you're familiar with Baseball:  Is the data skewed a bit? If so, why??
-- The New York Yankees, that's why!  
-- The Yankees have the most World Championships than any other franchise, AND they are consistently near the top
-- in total Payroll.

-- I'll prove it with some Queries! :

SELECT Pay_Rank, count(*) as times
FROM FranchisePayrolls_Ranked
WHERE name like 'New York Yankees'
GROUP BY Pay_Rank
ORDER BY Pay_Rank


-- From the Query results, we see that in a 32 season span (1985 to 2016), the Yankees had the #1 Payroll a whopping 20 times!
-- During that timespan, they also NEVER dropped below #7 on the Pay_Rank in a given year.


-- So, how bout trying to find the MEDIAN Pay_Rank of World Series Champs?
		-- (remember to use the convert function to get a decimal result)
		-- I'm aware that I could use the PERCENTILE_CONT(0.5) to get median, but the result gives me 31 rows of the same result.  I'm sure there must be a way
		-- to just get one SINGLE result, but I'm still wrapping my head around that one...


WITH minimum AS (
SELECT min(Pay_Rank) as Pay_Rank
FROM #WSchamps_Payrolls
)
,
maximum AS (
SELECT max(Pay_Rank) as Pay_Rank
FROM #WSchamps_Payrolls
)
,
high_and_low AS (
SELECT Pay_Rank
FROM minimum
UNION
SELECT Pay_Rank
FROM maximum
)

SELECT AVG(convert(decimal(4,2),Pay_Rank)) as Median
FROM high_and_low

-- The result is that the MEDIAN Payroll Rank for World Series champions between 1985 and 2016 is:  `12.5`