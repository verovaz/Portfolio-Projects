#US HOUSEHOLD INCOME EXPLORATORY DATA ANALYSIS 
SELECT *
FROM US_Project.USHouseholdIncome;

#We're going to be looking at the area of land and area of water. We're curious to see whicih area has the most land and water for each state.
SELECT State_Name, County, City, ALand, AWater
FROM US_Project.USHouseholdIncome
;
 
 #We want to look at the sum of the area for each state to see who has the most and who has the least amount of land and water 
SELECT State_Name, SUM(ALand), SUM(AWater) 
FROM US_Project.USHouseholdIncome
GROUP BY State_Name
ORDER BY 3 DESC
;

#Now we're going to look at the top 10 largest states by land
SELECT State_Name, SUM(ALand), SUM(AWater) 
FROM US_Project.USHouseholdIncome
GROUP BY State_Name
ORDER BY 2 DESC
LIMIT 10
;

#We're now going to look at the largest by water
SELECT State_Name, SUM(ALand), SUM(AWater) 
FROM US_Project.USHouseholdIncome
GROUP BY State_Name
ORDER BY 3 DESC
LIMIT 10
;

#We want to look if there is any NULL records in the data that we may want to fix 
SELECT *
FROM US_Project.USHouseholdIncome u
INNER JOIN US_Project.ushouseholdincome_Statistics us
	ON u.id = us.id
WHERE Mean <> 0 
;

#Since we don't want to use the NULL data we're going to get rid of it by using an inner join. Meaning there was dirty data because they're not reporting it properly.
SELECT *
FROM US_Project.USHouseholdIncome u
INNER JOIN US_Project.ushouseholdincome_Statistics us
	ON u.id = us.id
WHERE Mean <> 0 ;

#We want to look at the avergae median and mean household income in each state 
SELECT u.State_Name, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1) 
FROM US_Project.USHouseholdIncome u
INNER JOIN US_Project.ushouseholdincome_Statistics us
	ON u.id = us.id
WHERE Mean <> 0 
GROUP BY u.State_Name
HAVING COUNT(TYPE) > 100
ORDER BY 3 DESC
LIMIT 10;

#We want to look at the type meaning what kind of area they live in and see how many there were 
SELECT Type, COUNT(Type), ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1) 
FROM US_Project.USHouseholdIncome u
INNER JOIN US_Project.ushouseholdincome_Statistics us
	ON u.id = us.id
WHERE Mean <> 0 
GROUP BY Type
ORDER BY 4 DESC
LIMIT 20;

#We want to see what states have community and turns out Puerto Rico because the average and median salaries were dramatically lower 
SELECT *
FROM US_Project.USHouseholdIncome 
WHERE Type = 'Community'
;

#We want to look at the salaries from the city level because we're curious if big cities like LA or Scilicon Valley make a lot of money  
SELECT U.State_Name, City, ROUND(AVG(Mean), 1), ROUND(AVG(Median), 1)
FROM US_Project.USHouseholdIncome u
JOIN US_Project.ushouseholdincome_Statistics us
	ON u.id = us.id
GROUP BY U.State_Name, City
ORDER BY ROUND(AVG(Mean), 1) DESC 
;