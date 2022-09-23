---- I want to rank each FRANCHISE, based on their total payroll, by year.  I'll get to join Salaries with the Teams table ---

SELECT * FROM Teams WHERE yearID >= 1985

SELECT * FROM Salaries

--- CREATE SalariesByFranchise VIEW ---
USE Lahman

GO
CREATE VIEW SalariesByFranchise as
SELECT S.yearID, T.franchID, S.lgID, SUM(salary) as Payroll
FROM Salaries as S
LEFT JOIN Teams as T on S.yearID = T.yearID and S.teamID = T.teamID and S.lgID = T.lgID
WHERE salary is not null
GROUP BY S.yearID, S.teamID, T.franchID, S.lgID
GO



--- Query FranchiseBySalaries View ---

CREATE VIEW SalariesByFranchise_Ranked as
SELECT S.*, RANK() over (PARTITION BY S.yearID ORDER BY Payroll desc) as [Rank], T.WSWin
FROM SalariesByFranchise as S
LEFT JOIN Teams as T on S.yearID = T.yearID and S.franchID = T.franchID and S.lgID = T.lgID


SELECT * FROM SalariesByFranchise
DROP VIEW SalariesByFranchise


--- Partition By FranchiseID, Average RANK of Payroll since 1985 ---
with dude as (
SELECT yearID, franchID, AVG(Rank) over (PARTITION BY franchID) as AvgRank,  Rank as YearRank, WSWin 
FROM SalariesByFranchise_Ranked
WHERE WSWin = 'Y'
ORDER BY yearID
)
SELECT COUNT(*) as Count, AvgRank, YearRank
FROM dude
GROUP BY YearRank, AvgRank
ORDER BY Count desc

--- more CTE fun ---

with dude as (
SELECT yearID, franchID, AVG(Rank) over (PARTITION BY franchID) as AvgRank,  Rank as YearRank, WSWin 
FROM SalariesByFranchise_Ranked
WHERE WSWin = 1 and franchID != 'NYY'
)

SELECT ROUND(AVG(CAST(YearRank as numeric(4,2))),2) as PayForGold
FROM dude
     ---------------- Results of above Query:   The average Rank for Payroll for a World Series Champion is 8.23


