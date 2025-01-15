#World Life Expectancy Project (Data Cleaning)

SELECT * 
FROM worldlifexpectancy
;

 #We want to see if we have duplicates 
SELECT Country, Year, CONCAT(Country, Year)
FROM worldlifexpectancy
;
 
SELECT Country, Year, CONCAT(Country, Year), COUNT(CONCAT(Country, Year))
FROM worldlifexpectancy
GROUP BY Country, Year, CONCAT(Country, Year)
HAVING COUNT(CONCAT(Country, Year)) > 1 
;

#We want to get rid of the duplicates 
SELECT *
FROM (
	SELECT Row_ID, 
	CONCAT(Country, Year),
	ROW_NUMBER() OVER( PARTITION BY CONCAT(Country, Year) ORDER BY CONCAT(Country, Year)) AS Row_Num 
	FROM worldlifexpectancy
) AS Row_table 
WHERE Row_Num > 1 
;

#Now we want to delete these row ID's because these are the duplicates 
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

#We want to see how many blank spaces we have 
SELECT *
FROM worldlifexpectancy
WHERE Status = ''
;

#Just want to look at how many different statuses there are 
SELECT DISTINCT(status)
FROM worldlifexpectancy
WHERE Status <> ''
;

#We want to populate the status with their country 
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

#Since this didn't work we're going to have to join the table to itself so that we can update the blanks in the status clolumn 
UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2 
	ON t1.Country = t2.Country 
SET t1.Status = 'Developing'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developing'
;

#We are checking to see if we filled in all of the blank spaces 
SELECT *
FROM worldlifexpectancy
WHERE Status = ''
;

#We figured out the issue was that we only updated the Countries that are developing and not developed 
SELECT *
FROM worldlifexpectancy
WHERE Country = 'United States of America'
;

#We are doing the exact same thing just with developed
UPDATE worldlifexpectancy t1
JOIN worldlifexpectancy t2 
	ON t1.Country = t2.Country 
SET t1.Status = 'Developed'
WHERE t1.Status = ''
AND t2.Status <> ''
AND t2.Status = 'Developed'
;

#Just want to double check there are no more blanks left behind 
SELECT *
FROM worldlifexpectancy
WHERE Status = ''
;

#Just want to check if there are any NULLS
SELECT *
FROM worldlifexpectancy
WHERE Status IS NULL
;

SELECT *
FROM worldlifexpectancy
;


# NOW WE HAVE FIXED THE EMPTY COLUMNS UNDER 'STATUS'

#We saw that there are blanks under Life Expectancy so we're going to check how many blanks there are 
SELECT *
FROM worldlifexpectancy
WHERE Lifeexpectancy = '' 
;

SELECT Country, Year, Lifeexpectancy
FROM worldlifexpectancy
#WHERE Lifeexpectancy = '' 
;

#We want to populate the blank spaces with the average, so we'll be using the year before and the year after while using the correct Country 
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

#We want to check if our query worked properly
SELECT Country, Year, Lifeexpectancy
FROM worldlifexpectancy
WHERE Lifeexpectancy = ''
;

SELECT *
FROM worldlifexpectancy
;
