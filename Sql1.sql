--Temporary table to store median values
CREATE TABLE Median_Values(
Country NVARCHAR(50),
Median FLOAT
)

INSERT INTO Median_Values(Country,Median)
SELECT DISTINCT country, PERCENTILE_CONT(0.5) WITHIN GROUP(ORDER BY daily_vaccinations)OVER(PARTITION BY country) AS Median_Country FROM country_vaccination_stats
WHERE daily_vaccinations is not null

UPDATE country_vaccination_stats
SET daily_vaccinations = median.Median
FROM country_vaccination_stats cvs
JOIN Median_Values median ON cvs.country = median.country
WHERE cvs.daily_vaccinations IS NULL

UPDATE country_vaccination_stats
SET daily_vaccinations = 0
WHERE daily_vaccinations IS NULL

--Drop temporary table
DROP TABLE Median_Values
