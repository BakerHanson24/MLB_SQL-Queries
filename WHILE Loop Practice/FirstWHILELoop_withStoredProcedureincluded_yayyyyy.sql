DROP PROC TeamMateBallers
GO
CREATE PROC TeamMateBallers(@SO int) AS
WITH DemBoyz AS
(
SELECT playerID, yearID, teamID, SO as Ks
FROM Pitching
WHERE SO >= @SO
GROUP BY playerID, yearID, teamID, SO
)
SELECT teamID, yearID, COUNT(1) as TeamMates, STRING_AGG(playerID,', ') as Homies
FROM DemBoyz
GROUP BY yearID, teamID
HAVING COUNT(playerID) > 1
ORDER BY TeamMates desc, yearID
GO


CREATE PROC TeamMateBallersmetaprocedure (@SO int) AS
SET @SO = 301
WHILE @@ROWCOUNT > 0
BEGIN
	SET @SO = @SO + 1
	EXEC TeamMateBallers @SO
	--IF @@ROWCOUNT = 0
	--BEGIN
		--BREAK
	--END
END
GO


EXEC TeamMateBallersmetaprocedure 300