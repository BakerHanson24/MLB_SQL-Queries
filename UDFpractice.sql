---------------------------------------------------
------------------ SCALAR FUNCTION ----------------
DROP FUNCTION dbo.HRperAB
GO
CREATE FUNCTION dbo.HRperAB
(
    @HR decimal,
	@AB decimal
)
RETURNS DECIMAL(4,2)
AS
BEGIN

    RETURN @HR / @AB

END


SELECT playerID, yearID, AB, HR, dbo.HRperAB(HR,AB) as HRperAB
FROM Batting
WHERE AB > 200
ORDER BY HRperAB desc

-------------------------------------------------------------------------------------------------------
---- INLINE TABLE FUNCTION ------
DROP FUNCTION dbo.FlameThrowers
GO
CREATE FUNCTION dbo.FlameThrowers
(
    @playerID varchar(10),
    @teamName varchar(30)
)
RETURNS TABLE AS RETURN
(
    SELECT *
	FROM Pitching
	WHERE @playerID = playerID and @teamName = teamID
)

GO

SELECT * 
FROM dbo.FlameThrowers('johnsra05','SEA')

---------------------------------  BELOW: Combine dbo.FlameThowers with new Scalar Function named dbo.KsPerNine ------
DROP FUNCTION dbo.KsPerNine
GO
CREATE FUNCTION dbo.KsPerNine (@K decimal, @IPouts decimal)
RETURNS decimal (4,2)
AS
BEGIN

	RETURN (@K / (@IPouts/3))*9

END
GO



SELECT *, dbo.KsPerNine(FT2.SO,FT2.IPouts) as KsPerNine
FROM dbo.FlameThrowers('verlaju01','HOU') as FT1
CROSS APPLY dbo.FlameThrowers('colege01','HOU') as FT2

----------------------------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------------------------
--- MULTI-STATEMENT TABLE UDF practice ----
GO
DROP FUNCTION dbo.DollaBills
GO
CREATE FUNCTION dbo.DollaBills
(
    @playerID varchar(10),
    @yearID smallint
)
RETURNS @Salaries TABLE 
(
	playerID varchar(10),
	salary bigint
)
AS
BEGIN
    INSERT @Salaries
    SELECT @playerID, salary
	FROM Salaries
	WHERE @playerID = playerID and @yearID = yearID
    RETURN 
END
GO

SELECT *
FROM dbo.DollaBills('griffke02',1999) as DB1
CROSS APPLY dbo.DollaBills('griffke02',2000) as DB2
CROSS APPLY dbo.DollaBills('martied01',1995) as DB3