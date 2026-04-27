-- ============================================
-- DATA CLEANING & TRANSFORMATION
-- ============================================

-- --------------------------------------------
-- DAILY ACTIVITY TABLE
-- --------------------------------------------

-- Convert numeric columns from VARCHAR to DECIMAL and round values
UPDATE daily_activity
SET 
    TotalDistance = ROUND(CAST(TotalDistance AS DECIMAL(10,5)), 2),
    TrackerDistance = ROUND(CAST(TrackerDistance AS DECIMAL(10,5)), 2),
    LoggedActivitiesDistance = ROUND(CAST(LoggedActivitiesDistance AS DECIMAL(10,5)), 2),
    VeryActiveDistance = ROUND(CAST(VeryActiveDistance AS DECIMAL(10,5)), 2),
    ModeratelyActiveDistance = ROUND(CAST(ModeratelyActiveDistance AS DECIMAL(10,5)), 2),
    LightActiveDistance = ROUND(CAST(LightActiveDistance AS DECIMAL(10,5)), 2),
    SedentaryActiveDistance = ROUND(CAST(SedentaryActiveDistance AS DECIMAL(10,5)), 2);

-- Modify column data types
ALTER TABLE daily_activity
MODIFY TotalDistance DECIMAL(6,2),
MODIFY TrackerDistance DECIMAL(6,2),
MODIFY LoggedActivitiesDistance DECIMAL(6,2),
MODIFY VeryActiveDistance DECIMAL(6,2),
MODIFY ModeratelyActiveDistance DECIMAL(6,2),
MODIFY LightActiveDistance DECIMAL(6,2),
MODIFY SedentaryActiveDistance DECIMAL(6,2);

-- Fix date format
ALTER TABLE daily_activity
MODIFY ActivityDate VARCHAR(10);

UPDATE daily_activity
SET ActivityDate = STR_TO_DATE(ActivityDate, '%m/%d/%Y');

ALTER TABLE daily_activity
MODIFY ActivityDate DATE;


-- --------------------------------------------
-- SLEEP DAY TABLE
-- --------------------------------------------

-- Convert datetime format
UPDATE sleep_day
SET SleepDay = STR_TO_DATE(SleepDay, '%m/%d/%Y %r');

ALTER TABLE sleep_day
MODIFY SleepDay DATETIME;


-- --------------------------------------------
-- WEIGHT LOG TABLE
-- --------------------------------------------

-- Fix boolean values
UPDATE weight_log_info
SET IsManualReport = TRUE
WHERE IsManualReport = 'True';

UPDATE weight_log_info
SET IsManualReport = FALSE
WHERE IsManualReport = 'False';

-- Replace empty values with NULL
UPDATE weight_log_info
SET Fat = NULL
WHERE Fat = '';

-- Convert numeric columns
UPDATE weight_log_info
SET 
    WeightKg = ROUND(CAST(WeightKg AS DECIMAL(10,5)), 2),
    WeightPounds = ROUND(CAST(WeightPounds AS DECIMAL(10,5)), 2),
    BMI = ROUND(CAST(BMI AS DECIMAL(10,5)), 2);

-- Modify structure
ALTER TABLE weight_log_info
MODIFY WeightKg DECIMAL(5,2),
MODIFY WeightPounds DECIMAL(6,2),
MODIFY BMI DECIMAL(4,2),
MODIFY Fat INT,
MODIFY IsManualReport BOOLEAN;

-- Fix datetime format
UPDATE weight_log_info
SET Date = STR_TO_DATE(Date, '%m/%d/%Y %r');

ALTER TABLE weight_log_info
MODIFY Date DATETIME;
