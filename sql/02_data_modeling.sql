-- ============================================
-- DATA MODELING
-- ============================================

-- --------------------------------------------
-- CREATE USERS TABLE
-- --------------------------------------------

CREATE TABLE users (
    user_id BIGINT PRIMARY KEY
);

-- Insert unique user IDs
INSERT INTO users (user_id)
SELECT DISTINCT Id FROM daily_activity;


-- --------------------------------------------
-- DAILY ACTIVITY TABLE
-- --------------------------------------------

-- Validate duplicates
SELECT Id, ActivityDate, COUNT(*)
FROM daily_activity
GROUP BY Id, ActivityDate
HAVING COUNT(*) > 1;

-- Add composite primary key
ALTER TABLE daily_activity
ADD PRIMARY KEY (Id, ActivityDate);

-- Add foreign key
ALTER TABLE daily_activity
FOREIGN KEY (Id) REFERENCES users(user_id);


-- --------------------------------------------
-- SLEEP DAY TABLE
-- --------------------------------------------

-- Validate duplicates
SELECT Id, SleepDay, COUNT(*)
FROM sleep_day
GROUP BY Id, SleepDay
HAVING COUNT(*) > 1;

-- Add surrogate key
ALTER TABLE sleep_day
ADD sleep_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

-- Add foreign key
ALTER TABLE sleep_day
FOREIGN KEY (Id) REFERENCES users(user_id);


-- --------------------------------------------
-- WEIGHT LOG TABLE
-- --------------------------------------------

-- Validate duplicates
SELECT Id, Date, COUNT(*)
FROM weight_log_info
GROUP BY Id, Date
HAVING COUNT(*) > 1;

-- Add surrogate key
ALTER TABLE weight_log_info
ADD weight_id INT NOT NULL AUTO_INCREMENT PRIMARY KEY;

-- Add foreign key
ALTER TABLE weight_log_info
FOREIGN KEY (Id) REFERENCES users(user_id);
