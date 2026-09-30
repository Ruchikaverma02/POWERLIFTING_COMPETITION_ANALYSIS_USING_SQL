-- ============================================================
-- POWERLIFTING PERFORMANCE ANALYTICS
-- MYSQL ANSWER QUERIES + INSIGHTS
-- ============================================================

-- =====================================================
-- PROJECT INFORMATION
-- =====================================================
-- Name: Ruchika 
-- Project: Powerlifting Competition & Performance Analysis  Using MySQL
-- Role: Data Analyst
-- Tool: MySQL
-- Database: Powerlifting Competition & Performance_project
-- Datasets: meets, powerlifting
-- SQL Questions: 15
-- Difficulty Levels: Basic, Intermediate, Advanced
--
-- Project Objective:
-- To analyze Powerlifting Competition & Performance data using SQL and demonstrate
-- practical skills in data querying, aggregation,
-- JOINs, CTEs, window functions, and data analysis.

-- IMPORTANT:
-- These queries use the actual cleaned-table column names:
-- BestSquatKg, BestBenchKg, BestDeadliftKg.
-- ============================================================


USE powerlifting_project;


-- ============================================================
-- Q1. TOTAL MEETS
-- ============================================================
-- How many meets are present in the meets table?

SELECT COUNT(*) AS Total_Meets
FROM meets;

-- INSIGHT:
-- The cleaned dataset contains 8,482 unique meet records.
-- MeetID is the PRIMARY KEY, so COUNT(*) correctly counts the
-- meet rows in the parent table.


-- ============================================================
-- Q2. TOTAL PERFORMANCE RECORDS
-- ============================================================
-- How many meets are present in the meets table?

SELECT COUNT(*) AS Total_Performance_Records
FROM powerlifting;

-- INSIGHT:
-- The cleaned dataset contains 385,869 performance records.
-- This is much larger than the number of meets because one meet
-- can contain many athlete performance records.


-- ============================================================
-- Q3. PERFORMANCE RECORDS BY SEX
-- ============================================================
-- How many performance records are available for each sex?

SELECT
    Sex,
    COUNT(*) AS Performance_Records
FROM powerlifting
GROUP BY Sex
ORDER BY Performance_Records DESC;

-- INSIGHT:
-- Male records: 298,622 (77.39%).
-- Female records: 87,247 (22.61%).
-- This describes the composition of this dataset only; it should
-- not be interpreted as a representation of the entire sport.


-- ============================================================
-- Q4. AVERAGE TOTAL
-- ============================================================
-- What is the average TotalKg across all performance records?

SELECT
    ROUND(AVG(TotalKg), 2) AS Average_TotalKg
FROM powerlifting
WHERE TotalKg IS NOT NULL;

-- INSIGHT:
-- The average TotalKg is approximately 398.71 kg.
-- AVG() ignores NULL values, and the explicit NULL filter makes
-- the analytical intention clear.


-- ============================================================
-- Q5. TOP 10 PERFORMANCES BY TOTAL
-- ============================================================
-- Find the 10 performance records with the highest TotalKg.
SELECT
    Name,
    Sex,
    TotalKg,
    Equipment,
    MeetID
FROM powerlifting
WHERE TotalKg IS NOT NULL
ORDER BY TotalKg DESC
LIMIT 10;

-- INSIGHT:
-- The highest recorded TotalKg is 1,365.31 kg by Dave Hoff,
-- using Multi-ply equipment, at MeetID 1412.
-- The next two highest records are 1,363.05 kg and 1,360.78 kg.
-- This query demonstrates sorting and limiting a result set to
-- identify the highest individual performance records.


-- ============================================================
-- Q6. PERFORMANCE RECORDS BY COUNTRY
-- ============================================================
-- Using the relationship between meets and powerlifting, find the number of performance records for each MeetCountry.
SELECT
    m.MeetCountry,
    COUNT(p.PerformanceID) AS Performance_Records
FROM meets AS m
INNER JOIN powerlifting AS p
    ON m.MeetID = p.MeetID
WHERE m.MeetCountry IS NOT NULL
GROUP BY m.MeetCountry
ORDER BY Performance_Records DESC;

-- INSIGHT:
-- The USA has the largest number of performance records:
-- 274,334.
-- It is followed by Canada (33,226), Norway (31,595),
-- Australia (15,157), and Russia (5,860).
-- Country is stored in meets, while performance data is stored
-- in powerlifting, so the JOIN is required.


-- ============================================================
-- Q7. AVERAGE TOTAL BY EQUIPMENT
-- ============================================================
-- Calculate the average TotalKg for each Equipment type.

SELECT
    Equipment,
    ROUND(AVG(TotalKg), 2) AS Average_TotalKg
FROM powerlifting
WHERE Equipment IS NOT NULL
  AND TotalKg IS NOT NULL
GROUP BY Equipment
ORDER BY Average_TotalKg DESC;

-- INSIGHT:
-- Average TotalKg by equipment:
-- Multi-ply: 563.73 kg
-- Wraps:     534.34 kg
-- Single-ply:428.35 kg
-- Straps:    388.21 kg
-- Raw:       387.24 kg
--
-- These are descriptive differences in this dataset.
-- They do NOT establish that equipment itself causes the
-- performance differences because the groups may differ in
-- athlete strength, bodyweight, sex, division, competition,
-- and time period.


-- ============================================================
-- Q8. TOP 10 MEETS BY PERFORMANCE RECORDS
-- ============================================================
-- Find the 10 meets containing the highest number of performance records.

SELECT
    m.MeetID,
    m.MeetName,
    m.Date,
    COUNT(p.PerformanceID) AS Performance_Records
FROM meets AS m
INNER JOIN powerlifting AS p
    ON m.MeetID = p.MeetID
GROUP BY
    m.MeetID,
    m.MeetName,
    m.Date
ORDER BY Performance_Records DESC
LIMIT 10;

-- INSIGHT:
-- The meet with the largest number of performance records is:
-- MeetID: 7021
-- Meet: Raw Nationals 2016
-- Date: 2016-10-13
-- Performance records: 1,197
-- GROUP BY MeetID is essential because many performance records
-- belong to the same meet.


-- ============================================================
-- Q9. TOP 10 FEMALE PERFORMANCE RECORDS
-- ============================================================
-- Find the 10 highest TotalKg performance records where Sex = 'F'.

SELECT
    Name,
    TotalKg,
    BodyweightKg,
    Equipment,
    MeetID
FROM powerlifting
WHERE Sex = 'F'
  AND TotalKg IS NOT NULL
ORDER BY TotalKg DESC
LIMIT 10;

-- INSIGHT:
-- The highest female performance record is:
-- Laura Phelps-Sweatt
-- TotalKg: 816.47 kg
-- BodyweightKg: 75.00 kg
-- Equipment: Multi-ply
-- MeetID: 5479
--
-- The WHERE filter is applied before ORDER BY and LIMIT, so only
-- female records are considered for the top-10 result.


-- ============================================================
-- Q10. COUNTRIES WITH STRONG AVERAGE TOTALS
-- ============================================================
-- For each country, calculate:

-- MeetCountry
-- Number of performance records
-- Average TotalKg
-- Only include countries having at least 100 performance records.
-- Sort by average TotalKg from highest to lowest.

SELECT
    m.MeetCountry,
    COUNT(p.PerformanceID) AS Performance_Records,
    ROUND(AVG(p.TotalKg), 2) AS Average_TotalKg
FROM meets AS m
INNER JOIN powerlifting AS p
    ON m.MeetID = p.MeetID
WHERE m.MeetCountry IS NOT NULL
  AND p.TotalKg IS NOT NULL
GROUP BY m.MeetCountry
HAVING COUNT(p.PerformanceID) >= 100
ORDER BY Average_TotalKg DESC;

-- INSIGHT:
-- Among countries with at least 100 performance records,
-- Luxembourg has the highest average TotalKg at approximately
-- 636.33 kg, based on 138 performance records.
-- The HAVING clause is required because the threshold is applied
-- after GROUP BY aggregation.


-- ============================================================
-- Q11. HIGHEST PERFORMANCE IN EACH COUNTRY
-- ============================================================

-- For every MeetCountry, find the performance record with the highest TotalKg.

WITH CountryMax AS (
    SELECT
        m.MeetCountry,
        MAX(p.TotalKg) AS Max_TotalKg
    FROM meets AS m
    INNER JOIN powerlifting AS p
        ON m.MeetID = p.MeetID
    WHERE m.MeetCountry IS NOT NULL
      AND p.TotalKg IS NOT NULL
    GROUP BY m.MeetCountry
)
SELECT
    m.MeetCountry,
    p.Name,
    p.TotalKg,
    m.MeetName,
    m.Date
FROM meets AS m
INNER JOIN powerlifting AS p
    ON m.MeetID = p.MeetID
INNER JOIN CountryMax AS cm
    ON m.MeetCountry = cm.MeetCountry
   AND p.TotalKg = cm.Max_TotalKg
ORDER BY
    m.MeetCountry,
    p.TotalKg DESC;

-- INSIGHT:
-- This returns the maximum TotalKg performance for every country.
-- If multiple records have exactly the same country maximum,
-- all tied records are returned.
-- The CTE calculates the country-level maximum first and the
-- second query joins that result back to the detailed records.
-- This is safer for ties than selecting only one row.


-- ============================================================
-- Q12. RANK PERFORMANCE RECORDS WITHIN EACH SEX
-- ============================================================
-- Rank performance records by TotalKg separately within each Sex.
WITH RankedPerformances AS (
    SELECT
        Name,
        Sex,
        TotalKg,
        RANK() OVER (
            PARTITION BY Sex
            ORDER BY TotalKg DESC
        ) AS Performance_Rank
    FROM powerlifting
    WHERE TotalKg IS NOT NULL
)
SELECT
    Name,
    Sex,
    TotalKg,
    Performance_Rank
FROM RankedPerformances
ORDER BY
    Sex,
    Performance_Rank,
    TotalKg DESC;

-- INSIGHT:
-- Rank 1 in the male group is Dave Hoff with 1,365.31 kg.
-- Rank 1 in the female group is Laura Phelps-Sweatt with 816.47 kg.
-- PARTITION BY creates a separate ranking for each sex.
-- RANK() gives tied values the same rank.


-- ============================================================
-- Q13. TOP 3 PERFORMANCE RECORDS WITHIN EACH EQUIPMENT TYPE
-- ============================================================
-- For every Equipment type, find the top 3 performance records based on TotalKg.
WITH RankedEquipment AS (
    SELECT
        Equipment,
        Name,
        Sex,
        TotalKg,
        RANK() OVER (
            PARTITION BY Equipment
            ORDER BY TotalKg DESC
        ) AS Performance_Rank
    FROM powerlifting
    WHERE Equipment IS NOT NULL
      AND TotalKg IS NOT NULL
)
SELECT
    Equipment,
    Name,
    Sex,
    TotalKg,
    Performance_Rank
FROM RankedEquipment
WHERE Performance_Rank <= 3
ORDER BY
    Equipment,
    Performance_Rank,
    TotalKg DESC;

-- INSIGHT:
-- Highest record in each equipment category:
-- Multi-ply:  Dave Hoff       - 1,365.31 kg
-- Raw:       Ray Williams     - 1,105.00 kg
-- Single-ply:Blaine Sumner    - 1,272.50 kg
-- Straps:    Yury Belkin      -   450.00 kg
-- Wraps:     Andrey Malanichev- 1,140.00 kg
--
-- RANK() is appropriate because tied values should share a rank.
-- If exactly three physical rows were required regardless of ties,
-- ROW_NUMBER() would be the alternative.


-- ============================================================
-- Q14. AVERAGE TOTAL BY DIVISION
-- ============================================================
-- For each Division, calculate:
-- Division
-- Number of performance records
-- Average TotalKg
-- Maximum TotalKg
-- Only include divisions having at least 50 performance records.

SELECT
    Division,
    COUNT(*) AS Performance_Records,
    ROUND(AVG(TotalKg), 2) AS Average_TotalKg,
    MAX(TotalKg) AS Maximum_TotalKg
FROM powerlifting
WHERE Division IS NOT NULL
  AND TotalKg IS NOT NULL
GROUP BY Division
HAVING COUNT(*) >= 50
ORDER BY Average_TotalKg DESC;

-- INSIGHT:
-- This analysis compares average and maximum performance across
-- competition divisions.
--
-- The HAVING clause ensures that divisions with very few records
-- do not dominate the comparison.
--
-- Average_TotalKg represents the typical total within each
-- division, while Maximum_TotalKg shows the highest recorded
-- performance in that division.
--
-- These results should be interpreted descriptively because
-- divisions can differ in sex, bodyweight class, age, equipment,
-- and competition context.


-- ============================================================
-- Q15. PERFORMANCE ABOVE COUNTRY AVERAGE
-- ============================================================
-- for each performance record, compare its TotalKg with the average TotalKg of its MeetCountry.
-- Return only records where the performance's TotalKg is greater than the average for its country.

WITH CountryAverages AS (
    SELECT
        m.MeetCountry,
        AVG(p.TotalKg) AS CountryAverageTotal
    FROM meets AS m
    INNER JOIN powerlifting AS p
        ON m.MeetID = p.MeetID
    WHERE m.MeetCountry IS NOT NULL
      AND p.TotalKg IS NOT NULL
    GROUP BY m.MeetCountry
)
SELECT
    p.Name,
    m.MeetCountry,
    p.TotalKg,
    ROUND(ca.CountryAverageTotal, 2) AS CountryAverageTotal,
    ROUND(
        p.TotalKg - ca.CountryAverageTotal,
        2
    ) AS DifferenceFromCountryAverage
FROM powerlifting AS p
INNER JOIN meets AS m
    ON p.MeetID = m.MeetID
INNER JOIN CountryAverages AS ca
    ON m.MeetCountry = ca.MeetCountry
WHERE p.TotalKg IS NOT NULL
  AND p.TotalKg > ca.CountryAverageTotal
ORDER BY DifferenceFromCountryAverage DESC;

-- INSIGHT:
-- The largest positive difference is:
-- Dave Hoff, USA
-- TotalKg: 1,365.31 kg
-- USA average: 431.02 kg
-- Difference: 934.29 kg
--
-- This query demonstrates group-level benchmarking:
-- each individual performance is compared against the average
-- of the country associated with that performance.


-- ============================================================
-- OVERALL PROJECT INSIGHT SUMMARY
-- ============================================================

-- 1. DATASET SCALE
-- The project contains 8,482 meets and 385,869 performance records.
-- This is large enough to demonstrate practical SQL analytics.

-- 2. RELATIONAL MODEL
-- meets.MeetID is the PRIMARY KEY.
-- powerlifting.MeetID is the FOREIGN KEY.
-- One meet can have many performance records.

-- 3. DATA COMPOSITION
-- Male records represent 77.39% and female records represent
-- 22.61% of performance records in this dataset.

-- 4. OVERALL PERFORMANCE
-- Average TotalKg: approximately 424.06 kg.
-- Maximum recorded TotalKg: 1,365.31 kg.

-- 5. COUNTRY DISTRIBUTION
-- The USA contains the largest number of performance records:
-- 274,334.
-- Country record volumes are therefore highly uneven.

-- 6. EQUIPMENT
-- Multi-ply has the highest average TotalKg among the equipment
-- categories in this dataset at approximately 563.73 kg.
-- These are descriptive differences, not causal conclusions.

-- 7. COUNTRY AVERAGES
-- Among countries with at least 100 performance records,
-- Japan has the highest average TotalKg at approximately 740.24 kg.
-- The minimum-record threshold reduces the influence of very small
-- country samples.

-- 8. TOP PERFORMANCE
-- The highest recorded TotalKg is 1,365.31 kg by Dave Hoff.

-- 9. WINDOW FUNCTIONS
-- RANK() allows performance records to be ranked independently
-- within each sex or equipment category while retaining the
-- individual rows.

-- 10. TIME ANALYSIS
-- The number of meets and performance records varies substantially
-- by year. For example, 2017 contains 1,640 unique meets and
-- 108,576 performance records in this dataset.

-- 11. BENCHMARK ANALYSIS
-- 179,384 records, approximately 46.49% of all performance records,
-- are above their respective country's average TotalKg.

-- ============================================================
-- INTERVIEW CONCEPTS DEMONSTRATED
-- ============================================================
-- SELECT
-- WHERE
-- COUNT()
-- COUNT(DISTINCT)
-- AVG()
-- MAX()
-- ORDER BY
-- LIMIT
-- GROUP BY
-- HAVING
-- INNER JOIN
-- CTEs
-- Window functions
-- RANK()
-- PARTITION BY
-- YEAR()
-- Calculated columns
-- One-to-many JOIN logic
-- Group-level benchmarking
-- NULL-aware aggregation
-- ============================================================
