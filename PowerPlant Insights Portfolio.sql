--PowerPlant Data Exploration
--skill used: Joins, CTEs, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types
--Dataset: https://www.kaggle.com/datasets/ramjasmaurya/global-powerplants
SELECT *
FROM Project1..[Global Power-Plants]
ORDER BY 1,2

SELECT country_long, [start date], [name of powerplant] AS powerplant_name, primary_fuel, [capacity in MW] AS capacity_MW, estimated_generation_gwh_2021
FROM Project1..[Global Power-Plants]
ORDER BY 1, 2 


-- Calculate the total capacity of all power plants
-- This query sums up the capacity of all power plants in the dataset

SELECT SUM([capacity in MW]) AS Total_Capacity_MW
FROM [Global Power-Plants];

-- Calculate the total capacity by fuel type for power plants
-- This query groups power plants by their primary fuel type and calculates the total capacity for each fuel type.

SELECT
    primary_fuel,                      
    SUM([capacity in MW]) AS Total_Capacity_MW  -- Calculate the sum of capacity for each fuel type
FROM
    [Global Power-Plants]            
GROUP BY
    primary_fuel                       
ORDER BY
    primary_fuel;                      


-- Calculate the average electricity generation by fuel type for power plants
-- This query groups power plants by their primary fuel type and calculates the average generation for each fuel type.

SELECT
    primary_fuel,                 
    AVG(estimated_generation_gwh_2021) AS Average_Generation_GWh  -- Calculate the average generation for each fuel type
FROM
    [Global Power-Plants]
WHERE
	estimated_generation_gwh_2021 is not null
GROUP BY
    primary_fuel                            
ORDER BY
    primary_fuel;
	
-- Calculate the annual growth rate in power plant capacity
-- This query calculates the growth rate by comparing the capacity of each year to the previous year.

-- Common Table Expression (CTE) to calculate capacity for each year
-- Common Table Expression (CTE) to calculate capacity for each year and country
WITH CapacityByYear AS (
    SELECT
        YEAR(TRY_CAST([start date] AS DATE)) AS Year,
        country_long, -- Include the country column
        SUM([capacity in MW]) AS Total_Capacity
    FROM
        [Global Power-Plants]
	WHERE
        [start date] IS NOT NULL -- Filter out rows with null [start date] values
    GROUP BY
        YEAR(TRY_CAST([start date] AS DATE)),
        country_long -- Group the data by year and country
)

-- Calculate the growth rate
SELECT
    C1.Year AS Year,
    C1.country_long AS Country, -- Show the country
    C1.Total_Capacity AS Capacity,
    (C1.Total_Capacity - COALESCE(C2.Total_Capacity, 0)) / COALESCE(C2.Total_Capacity, 1) AS Growth_Rate
FROM
    CapacityByYear C1
LEFT JOIN
    CapacityByYear C2
ON
    C1.Year = C2.Year + 1
WHERE
    C2.Year IS NOT NULL -- Filter out rows with null previous year values
ORDER BY
    C1.country_long;


-- Select the country and calculate the highest estimated generation for each country
SELECT 
    country_long, 
    MAX(estimated_generation_gwh_2021) AS highest_estimated_generation
FROM 
    Project1..[Global Power-Plants]
WHERE
	estimated_generation_gwh_2021 is not null
GROUP BY 
    country_long
ORDER BY 
    highest_estimated_generation DESC; 
	
SELECT 
    country_long, 
    [start date], 
    [name of powerplant] AS powerplant_name, 
    primary_fuel, 
    [capacity in MW] AS capacity_MW, 
    estimated_generation_gwh_2021
FROM 
    Project1..[Global Power-Plants]
WHERE 
    [start date] IS NOT NULL
    AND primary_fuel IS NOT NULL
    AND estimated_generation_gwh_2021 IS NOT NULL
ORDER BY 
    1, 2;


-- Create a view for data visualization

CREATE VIEW PowerPlantCapacityGrowth AS
WITH CapacityByYear AS (
    SELECT
        YEAR(TRY_CAST([start date] AS DATE)) AS Year,
        country_long,
        SUM([capacity in MW]) AS Total_Capacity
    FROM
        [Global Power-Plants]
    WHERE
        [start date] IS NOT NULL
    GROUP BY
        YEAR(TRY_CAST([start date] AS DATE)),
        country_long
)

SELECT
    C1.Year AS Year,
    C1.country_long AS Country,
    C1.Total_Capacity AS Capacity,
    (C1.Total_Capacity - COALESCE(C2.Total_Capacity, 0)) / COALESCE(C2.Total_Capacity, 1) AS Growth_Rate
FROM
    CapacityByYear C1
LEFT JOIN
    CapacityByYear C2
ON
    C1.Year = C2.Year + 1
WHERE
    C2.Year IS NOT NULL;


-- Create a view for the highest estimated generation by country
CREATE VIEW HighestEstimatedGenerationByCountry AS
SELECT 
    country_long, 
    MAX(estimated_generation_gwh_2021) AS highest_estimated_generation
FROM 
    Project1..[Global Power-Plants]
WHERE
    estimated_generation_gwh_2021 IS NOT NULL
GROUP BY 
    country_long

-- Create a view for annual growth rate in power plant capacity

CREATE VIEW AnnualGrowthRateByCountry AS
WITH CapacityByYear AS (
    SELECT
        YEAR(TRY_CAST([start date] AS DATE)) AS Year,
        country_long,
        SUM([capacity in MW]) AS Total_Capacity
    FROM
        Project1..[Global Power-Plants]
    WHERE
        [start date] IS NOT NULL
    GROUP BY
        YEAR(TRY_CAST([start date] AS DATE)),
        country_long
)

SELECT 
    C1.Year AS Year,
    C1.country_long AS Country,
    C1.Total_Capacity AS Capacity,
    (C1.Total_Capacity - COALESCE(C2.Total_Capacity, 0)) / COALESCE(C2.Total_Capacity, 1) AS Growth_Rate
FROM
    CapacityByYear C1
LEFT JOIN
    CapacityByYear C2
ON
    C1.Year = C2.Year + 1
WHERE
    C2.Year IS NOT NULL; -- Filter out rows with null previous year values



-- Create a view for average electricity generation by fuel type

CREATE VIEW AverageGenerationByFuelType AS
SELECT
    primary_fuel,
    AVG(estimated_generation_gwh_2021) AS Average_Generation_GWh
FROM
    Project1..[Global Power-Plants]
WHERE
    estimated_generation_gwh_2021 IS NOT NULL
GROUP BY
    primary_fuel;


-- Create a view for total capacity by fuel type

CREATE VIEW TotalCapacityByFuelType AS
SELECT
    primary_fuel,
    SUM([capacity in MW]) AS Total_Capacity_MW
FROM
    Project1..[Global Power-Plants]
GROUP BY
    primary_fuel;
