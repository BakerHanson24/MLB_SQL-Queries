USE Lahman

SELECT DISTINCT S_1.franchID,
		PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY Rank) over (PARTITION BY franchID)
FROM SalariesByFranchise_Ranked as S_1
JOIN
(SELECT SUM(convert(bigint,Payroll)) as SumPayroll,
		SUM(convert(tinyint,WSWin)) as Championships,
		franchID
FROM SalariesByFranchise_Ranked
GROUP BY franchID) as S_2
on S_1.franchID = S_2.franchID


SELECT * FROM SalariesByFranchise_Ranked
