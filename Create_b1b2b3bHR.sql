GO
CREATE VIEW b1b2b3bHR AS
WITH TeamsEdits AS (
SELECT yearID, lgID, franchID, W, L, name, convert(smallint, HR) as HR, CONVERT(tinyint, _3B) as _3B, CONVERT(smallint, _2B) as _2B, CONVERT(smallint, H) as H
FROM Teams
)
,
Singles AS (
SELECT *, (H-HR-_3B-_2B) as _1B
FROM TeamsEdits
)

SELECT lgID, franchID, W, L,CONCAT(yearID,' ', name) as Team,  _1B, _2B, _3B, HR
FROM Singles
GO

SELECT * FROM b1b2b3bHR order by _1B desc