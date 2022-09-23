



--Franchise and Team Origins--

WITH Franchise_Origins AS (

SELECT  MIN(yearID) as Founding_Year,
		MAX(yearID) - MIN(yearID) as Years_Alive,
		MAX(yearID) as Extinction_Year,
		lgID,
		franchID

FROM Lahman.dbo.Teams
WHERE lgID IN ('AL', 'NL')
GROUP BY franchID, lgID, Founding_Year, Years_Alive, Extinction_Year

),

Distinct_Franchises AS (
 
 SELECT Founding_Year,
		Years_Alive,
		Extinction_Year,
		lgID,
		franchID,
		COUNT(1) as Number_of_Teams,
		STRING_AGG(franchID, ', ') as List_of_Teams
FROM Franchise_Origins
GROUP BY lgID, franchID

)

SELECT * FROM Distinct_Franchises
ORDER BY Founding_Year

--JOIN CTE Franchise_Origins with Lahman World Series Table (COUNT World Series Championships)--