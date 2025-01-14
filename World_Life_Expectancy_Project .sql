SELECT * 
FROM worldlifexpectancy
;

SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM worldlifexpectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1 
;

SELECT *
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num 
	FROM worldlifexpectancy
) AS Row_table 
WHERE Row_Num > 1 
;

DELETE FROM worldlifexpectancy
WHERE 
	Row_ID IN (
	SELECT Row_ID
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num 
	FROM worldlifexpectancy
) AS Row_table 
WHERE 
	Row_Num > 1 
)
;

# THIS IS WHERE YOU"VE COMPLETED THE REMOVE DUPLICATES PORTION OF THE CLEANING 

SELECT *
FROM worldlifexpectancy
WHERE Status = ''
;

SELECT DISTINCT(status)
FROM worldlifexpectancy
WHERE Status <> ''
;

SELECT DISTINCT(Country)
FROM worldlifexpectancy
WHERE Status = 'Developing'
;

UPDATE worldlifexpectancy
SET Status = 'Developing'
WHERE Country IN (SELECT DISTINCT(Country)
			FROM worldlifexpectancy
			WHERE Status = 'Developing')
;

UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2 
	ON t1.Country = t2.Country 
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;


SELECT *
FROM worldlifexpectancy
WHERE Country = 'United States of America'
;

UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2 
	ON t1.Country = t2.Country 
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

SELECT *
FROM worldlifexpectancy
WHERE Status IS NULL
;

SELECT *
FROM worldlifexpectancy
;


# NOW WE HAVE FIXED THE EMPTY COLUMNS UNDER 'STATUS'


SELECT *
FROM worldlifexpectancy
WHERE Lifeexpectancy = '' 
;

SELECT Country, Year, Lifeexpectancy
FROM worldlifexpectancy
#WHERE Lifeexpectancy = '' 
;

SELECT 
t1.Country, t1.Year, t1.Lifeexpectancy, 
t2.Country, t2.Year, t2.Lifeexpectancy,
t3.Country, t3.Year, t3.Lifeexpectancy,
ROUND(( t2.Lifeexpectancy + t3.Lifeexpectancy)/2,1)
FROM worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country = t2.Country 
    AND t1.Year = t2.Year - 1
JOIN worldlifexpectancy t3
	ON t1.Country = t3.Country 
    AND t1.Year = t3.Year + 1
WHERE t1.Lifeexpectancy = '' 
;

UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2
	ON t1.Country = t2.Country 
    AND t1.Year = t2.Year - 1
JOIN worldlifexpectancy t3
	ON t1.Country = t3.Country 
    AND t1.Year = t3.Year + 1
SET t1.Lifeexpectancy = ROUND(( t2.Lifeexpectancy + t3.Lifeexpectancy)/2,1)
WHERE t1.Lifeexpectancy = '' 
;

SELECT Country, Year, Lifeexpectancy
FROM worldlifexpectancy
WHERE Lifeexpectancy = ''
;

SELECT *
FROM worldlifexpectancy
;

# Life expectancy exploratory 


SELECT Country, MIN(Lifeexpectancy), MAX(Lifeexpectancy)
FROM worldlifexpectancy
GROUP BY Country 
ORDER BY Country DESC
;

SELECT Country, 
MIN(Lifeexpectancy), 
MAX(Lifeexpectancy),
ROUND(MAX(Lifeexpectancy) - MIN(Lifeexpectancy), 1) AS Life_increase_15_years
FROM worldlifexpectancy
GROUP BY Country 
HAVING MIN(Lifeexpectancy) <> 0
AND MAX(Lifeexpectancy) <> 0 
ORDER BY Life_increase_15_years DESC
;

SELECT Year, 
ROUND(AVG(Lifeexpectancy), 2)
FROM worldlifexpectancy
WHERE Lifeexpectancy <> 0
AND Lifeexpectancy <> 0 
GROUP BY Year
ORDER BY Year 
;

SELECT *
FROM worldlifexpectancy
;

SELECT Country, 
ROUND(AVG(GDP), 1) AS GDP,
ROUND(AVG(Lifeexpectancy), 1) AS Life_exp
FROM worldlifexpectancy
GROUP BY Country 
HAVING Life_exp > 0 
AND GDP > 0
ORDER BY GDP DESC
;

SELECT
SUM(CASE WHEN GDP >= 1500 THEN 1 ELSE 0 END) High_GDP_count,
AVG(CASE WHEN GDP >= 1500 THEN Lifeexpectancy ELSE NULL END) High_GDP_Lifeexpectancy,
SUM(CASE WHEN GDP <= 1500 THEN 1 ELSE 0 END) Low_GDP_count,
AVG(CASE WHEN GDP <= 1500 THEN Lifeexpectancy ELSE NULL END) Low_GDP_Lifeexpectancy
FROM worldlifexpectancy
;

SELECT *
FROM worldlifexpectancy
;


SELECT Status, ROUND(AVG(Lifeexpectancy), 1)
FROM worldlifexpectancy
GROUP BY Status 
;

SELECT Status, COUNT(DISTINCT Country),
ROUND(AVG(Lifeexpectancy), 1)
FROM worldlifexpectancy
GROUP BY Status 
;

SELECT Country,  
ROUND(AVG(BMI), 1) AS BMI,
ROUND(AVG(Lifeexpectancy), 1) AS Life_exp
FROM worldlifexpectancy
GROUP BY Country 
HAVING Life_exp > 0 
AND BMI > 0
ORDER BY BMI ASC
;


SELECT Country,
Year,
Lifeexpectancy,
AdultMortality,
SUM(AdultMortality) OVER(PARTITION BY Country ORDER BY Year) AS Rolling_total
FROM worldlifexpectancy
WHERE Country LIKE '%United%'
;


