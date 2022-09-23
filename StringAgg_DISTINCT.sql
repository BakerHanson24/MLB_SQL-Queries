
---- History of Teams per Franchise ----
GO
CREATE VIEW HistoryFranchises AS
WITH Step1 AS (
SELECT franchID as Franchise, name as TeamName
FROM Teams
GROUP BY franchID, name
)
SELECT COUNT(1) as NumTeams, Franchise, STRING_AGG(TeamName,', ') as TeamNames
FROM Step1
GROUP BY Franchise
GO


---------- History of Franchises per Team (the reverse order) -----------------------
GO
CREATE VIEW HistoryTeams AS
WITH Step1 AS (
SELECT Name as TeamName, franchID as Franchise
FROM Teams
GROUP BY Name, franchID
)

SELECT COUNT(1) as NumFranchises, TeamName, STRING_AGG(Franchise,', ') as Franchises
FROM Step1
GROUP BY TeamName
GO


SELECT *
FROM HistoryFranchises
SELECT *
FROM HistoryTeams


---------------------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------------------------------------------------

--- Create WhoPlayedWho VIEW ----

GO
CREATE VIEW WhoPlayedWho AS
SELECT COUNT(1) as NumTeams, playerID, FullName, STRING_AGG(Team,', ') as TeamsPlayedFor
FROM
(
	SELECT playerID, FullName, name as Team
	FROM AllPlayers
	GROUP BY playerID, FullName, name
) as Step1
WHERE playerID like 'buhneja%%'
GROUP BY playerID, FullName
GO




SELECT * FROM People

