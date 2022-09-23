SELECT *
FROM Lahman.dbo.Teams
WHERE yearID IN (1993,1994)


SELECT yearID, lgID, divID, name, Rank, G, W, L, HR, SOA, attendance
INTO Teams_Attendance
FROM Lahman.dbo.Teams
WHERE yearID IN (1993, 1994)

SELECT yearID, lgID, divID, name, Rank, G, W, L, HR, SOA, attendance
INTO Attendance_95
FROM Lahman.dbo.Teams
WHERE yearID = 1995

SELECT *
INTO Attendance_93
FROM Teams_Attendance
WHERE yearID = 1993;

SELECT *
INTO Attendance_94
FROM Teams_Attendance
WHERE yearID = 1994;

--Now the tables for 93 - 95 have been created :) --
SELECT * FROM Attendance_93;
SELECT * FROM Attendance_94;
SELECT * FROM Attendance_95;
-------------------------------------------


--Attendance per Win in '94 and '95 --
SELECT *,
attendance/W as attendance_perWin
FROM Attendance_94
ORDER BY attendance desc;

SELECT *,
attendance/W as attendance_perWin
FROM Attendance_95
ORDER BY attendance desc;

ALTER TABLE Attendance_95
ALTER COLUMN attendance int;
ALTER TABLE Attendance_95
ALTER COLUMN attendance_perWin int;


-- HR's per team, most to least--
SELECT TOP 100 yearID, lgID, name, divID, Rank, W, L, WCWin, DivWin, LgWin, WSWin, R, HR, park, BPF, PPF
FROM Teams
ORDER BY HR desc


SELECT yearID,
	   SUM(HR) as HR
FROM Teams
GROUP BY yearID
ORDER BY HR desc;