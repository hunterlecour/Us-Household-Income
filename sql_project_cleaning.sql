# US Household Income Data Cleaning

SELECT * 
FROM us_project.us_household_income;

SELECT * 
FROM us_project.us_household_income_statistics;

# Renaming Column to id

ALTER TABLE us_project.us_household_income_statistics RENAME COLUMN `ï»¿id` TO `id`;

SELECT COUNT(id) 
FROM us_project.us_household_income;

SELECT COUNT(id) 
FROM us_project.us_household_income_statistics;

SELECT id, COUNT(id)
FROM us_project.us_household_income
GROUP BY id
HAVING COUNT(id) > 1;

# Finding Duplicates

SELECT *
FROM (
SELECT row_id,
id,
ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
FROM us_project.us_household_income
) duplicates
WHERE row_num > 1;

# Deleting Duplicates For Household Income

DELETE FROM us_household_income
WHERE row_id IN (
	SELECT row_id 
    FROM(
    SELECT row_id,
	id,
	ROW_NUMBER() OVER(PARTITION BY id ORDER BY id) row_num
	FROM us_project.us_household_income
	) duplicates
WHERE row_num > 1);

# Locating Flaws in the State Name

SELECT State_Name, COUNT(State_Name)
FROM us_project.us_household_income
GROUP BY State_Name
;

# Creating Adjustments to flawed State Names

UPDATE us_project.us_household_income
SET State_Name = 'Georgia'
WHERE State_Name = 'georia';

UPDATE us_project.us_household_income
SET State_Name = 'Alabama'
WHERE State_Name = 'alabama';

# Finding Null Values in Place

SELECT *
FROM us_project.us_household_income
WHERE County = 'Autauga County'
ORDER BY 1
;

UPDATE us_household_income
SET Place = 'Autaugaville'
WHERE County = 'Autauga County'
AND City = 'Vinemont';

# Fixing Type Column Typos

SELECT Type, COUNT(Type)
FROM us_project.us_household_income
GROUP BY Type;

UPDATE us_household_income
SET Type = 'Borough'
WHERE Type = 'Boroughs';

# Checking Null Values in ALand and AWater

SELECT ALand, AWater
FROM us_project.us_household_income
WHERE (AWater = 0 OR Awater = '' OR AWater IS NULL) AND (ALand = 0 OR ALand = '' OR ALand IS NULL)
;



    