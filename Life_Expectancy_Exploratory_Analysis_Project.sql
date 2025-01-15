# Life expectancy exploratory data analysis 

SELECT *
FROM worldlifexpectancy
;

#We want to see the min and max life expectancy in each country 
SELECT Country, MIN(Lifeexpectancy), MAX(Lifeexpectancy)
FROM worldlifexpectancy
GROUP BY Country 
ORDER BY Country DESC
;

#We want to filter out the 0's we saw (could be a potential data quality issue). We also want to look at the countries who had the biggest strides from their lowest to the highest points.
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

#We want to look at the average yeare that has done really well with the average life expectancy 
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

#We want to look at the correlation, so we'll be looking at the GDP, country, and life expectancy. 
SELECT Country, 
ROUND(AVG(GDP), 1) AS GDP,
ROUND(AVG(Lifeexpectancy), 1) AS Life_exp
FROM worldlifexpectancy
GROUP BY Country 
;

#We got bad data so we wanted to take a closer look and seems as if they didin't give data on the smaller countries which is why they put it as 0 
SELECT Country, 
ROUND(AVG(GDP), 1) AS GDP,
ROUND(AVG(Lifeexpectancy), 1) AS Life_exp
FROM worldlifexpectancy
GROUP BY Country 
ORDER BY Life_exp ASC 
;

#We wanted to look at the average life expectancy again 
SELECT Year, 
ROUND(AVG(Lifeexpectancy), 2)
FROM worldlifexpectancy
WHERE Lifeexpectancy <> 0
AND Lifeexpectancy <> 0 
GROUP BY Year
ORDER BY Year 
;

#We compared the GDP from DESC to ASC based on the country they lived in and it showed that the life expectancy is correlated to the country you live in 
SELECT Country, 
ROUND(AVG(GDP), 1) AS GDP,
ROUND(AVG(Lifeexpectancy), 1) AS Life_exp
FROM worldlifexpectancy
GROUP BY Country 
HAVING Life_exp > 0 
AND GDP > 0
ORDER BY GDP DESC
;

#We want to look at the average GDP to the life expectancy 
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

#want to look at the average life expectancy is between the 2 statuses we have 
SELECT Status, ROUND(AVG(Lifeexpectancy), 1)
FROM worldlifexpectancy
GROUP BY Status 
;

#Since there are only 2 statuses we want to see if the average wasn't skewed in favor for the developed or developing countries.
SELECT Status, COUNT(DISTINCT Country),
ROUND(AVG(Lifeexpectancy), 1)
FROM worldlifexpectancy
GROUP BY Status 
;

#We want to look at the correlation with BMI to life expectancy 
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
