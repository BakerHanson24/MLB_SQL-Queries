USE Lahman


SELECT * FROM Salaries
SELECT * FROM People
SELECT * FROM Teams

GO
CREATE VIEW PlayerSalariesTeamsWS as
SELECT S.yearID, S.playerID, CONCAT(nameFirst,' ',nameLast) as FullName, S.teamID, S.lgID, salary, T.WSWin
FROM Salaries S
LEFT JOIN People P on S.playerID = P.playerID
LEFT JOIN Teams T on S.yearID = T.yearID and S.teamID = T.teamID and S.lgID = T.lgID
GO




SELECT playerID, FullName, SUM(salary) as PayDay,
		RANK() over (ORDER BY SUM(salary) desc) as PayRank,
		SUM(CAST(WSWin as tinyint)) as Championships
FROM PlayerSalariesTeamsWS
GROUP BY playerID, FullName 
ORDER BY Championships desc, PayRank



SELECT *
FROM PlayerSalariesTeamsWS

BEGIN TRAN
SELECT * FROM PlayerSalariesTeamsWS
UPDATE PlayerSalariesTeamsWS
SET WSWin = 1 WHERE WSWin = 'Y'
UPDATE PlayerSalariesTeamsWS
SET WSWin = 0 WHERE WSWin = 'N'
SELECT * FROM PlayerSalariesTeamsWS
COMMIT TRAN


-----------------------------------------------------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------------------------------------------------



--- Create People VIEW using UNION ALL combining Batting and Pitching tables ----


CREATE VIEW Players as
SELECT playerID, yearID, stint, teamID,lgID
FROM Batting
UNION 
SELECT playerID, yearID, stint, teamID,lgID
FROM Pitching


SELECT * FROM Players
SELECT * FROM People
SELECT * FROM Teams


GO
Create View AllPlayers as
WITH Players AS (
SELECT playerID, yearID, stint, teamID,lgID
FROM Batting
UNION
SELECT playerID, yearID, stint, teamID,lgID
FROM Pitching
)

SELECT PL.playerID, CONCAT(nameFirst,' ',nameLast) as FullName, PL.yearID, stint, PL.teamID, T.franchID, T.name, PL.lgID, T.WSWin, T.LgWin
FROM Players as PL
LEFT JOIN People as PP on PL.playerID = PP.playerID
LEFT JOIN Teams as T on PL.yearID = T.yearID and PL.teamID = T.teamID and PL.lgID = T.lgID

GO

SELECT * FROM AllPlayers

UPDATE AllPlayers
SET WSWin = 1 WHERE WSWin = 'Y'
UPDATE AllPlayers
SET LgWin = 1 WHERE LgWin = 'Y'
UPDATE AllPlayers
SET WSWin = 0 WHERE WSWin = 'N'
UPDATE AllPlayers
SET LgWin = 0 WHERE LgWin = 'N'


SELECT * FROM AllPlayers

SELECT playerID, FullName, SUM(convert(tinyint,WSWin)) as Championships
FROM AllPlayers
GROUP BY playerID, FullName, teamID, franchID
ORDER BY Championships desc

SELECT * FROM AllPlayers WHERE FullName = 'Mariano Rivera'


DROP VIEW AllPlayers