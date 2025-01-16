# US HOUSEHOLD INCOME DATA CLEANING

#We want to make sure we got all the data imported
SELECT COUNT(id)
FROM US_Project.USHouseholdIncome;

SELECT COUNT(id)
FROM US_Project.ushouseholdincome_Statistics;

SELECT *
FROM US_Project.USHouseholdIncome;

SELECT *
FROM US_Project.ushouseholdincome_Statistics;

#We want to see if we have any duplicates 
SELECT id, COUNT(id)
FROM US_Project.USHouseholdIncome
GROUP BY id 
HAVING COUNT(id) > 1
;

#We want to locate the row id's to remove the duplicates 
SELECT *
	FROM (
		SELECT row_id,
				id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM US_Project.USHouseholdIncome
		) duplicates
WHERE row_num > 1
;

DELETE FROM US_Project.USHouseholdIncome
WHERE row_id IN (
	SELECT row_id
	FROM (
		SELECT row_id,
				id,
		ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
		FROM US_Project.USHouseholdIncome
		) duplicates
WHERE row_num > 1)
;

#WE HAVE SUCCESSFULLY REMOVED THE DUPLICATES

SELECT id, COUNT(id)
FROM US_Project.USHouseholdIncome
GROUP BY id 
HAVING COUNT(id) > 1
;

SELECT id, COUNT(id)
FROM US_Project.ushouseholdincome_Statistics
GROUP BY id 
HAVING COUNT(id) > 1
;

SELECT State_Name, COUNT(State_Name)
FROM US_Project.USHouseholdIncome
GROUP BY State_Name
;

SELECT DISTINCT State_Name
FROM US_Project.USHouseholdIncome
ORDER BY 1
;

#We're going to fix the typos 
UPDATE US_Project.USHouseholdIncome
SET State_Name = 'Georgia' 
WHERE State_Name = 'georia'
;

UPDATE US_Project.USHouseholdIncome
SET State_Name = 'Alabama' 
WHERE State_Name = 'alabama'
;

#We're double checking everything looked good 
SELECT *
FROM US_Project.USHouseholdIncome;


SELECT DISTINCT State_Name
FROM US_Project.USHouseholdIncome
ORDER BY 1
;

#We're just checking everything making sure everything looks ok 
SELECT State_ab
FROM US_Project.USHouseholdIncome
ORDER BY 1
;


SELECT *
FROM US_Project.USHouseholdIncome;


#We saw earlier there was an empty space so we want to check how many there are
SELECT *
FROM US_Project.USHouseholdIncome
WHERE Place is NULL
ORDER BY 1
;

#We want to look if Autauga county is equal to place. There was one tiny error but we're going to populate it correctly.
SELECT *
FROM US_Project.USHouseholdIncome
WHERE County = 'Autauga County' 
ORDER BY 1
;

#We want to populate it with the correct county 
UPDATE US_Project.USHouseholdIncome
SET Place = 'Autuagaville'
WHERE County = 'Autauga County' 
AND City = 'Vinemont'
;

#We want to look at the types column to get familiarized wtih it 
SELECT Type, COUNT(Type)
FROM US_Project.USHouseholdIncome
GROUP BY Type 
;

#We saw a tpyo and fixed it 
UPDATE US_Project.USHouseholdIncome
SET Type = 'Boroughs'
WHERE Type = 'Borough'
;

#We want to see if there is any other cleaning done 
SELECT *
FROM US_Project.USHouseholdIncome;

#We saw some 0's so we want to make sure there weren't any blanks 
SELECT ALand, AWater
FROM US_Project.USHouseholdIncome
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL 
;

#We wanted to see if they were all 0's meaning there is no blank or null data 
SELECT DISTINCT(AWater)
FROM US_Project.USHouseholdIncome
WHERE AWater = 0 OR AWater = '' OR AWater IS NULL 
;

#Both land & water looked so we didn't need to do anymore cleaning 
SELECT ALand, AWater
FROM US_Project.USHouseholdIncome
WHERE (ALand = 0 OR ALand = '' OR ALand IS NULL)
;

