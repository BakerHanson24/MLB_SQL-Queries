


SELECT S.yearID, S.teamID, COUNT(1) as Representatives, STRING_AGG(P.FullName,', ') as Players
FROM AllstarFull as S
JOIN AllPlayers as P
on S.playerID = P.playerID and S.yearID = P.yearID and S.teamID = P.teamID
WHERE S.teamID = 'SEA'
GROUP BY S.yearID, S.teamID


SELECT * FROM AllstarFull
WHERE teamID = 'SEA' and (startingPos between 1 and 9)