-- ============================================
-- ANALYTICAL VIEWS
-- ============================================

-- --------------------------------------------
-- BMI CLASSIFICATION
-- --------------------------------------------

CREATE VIEW bmi_classification AS
SELECT 
    Id, 
    AVG(BMI) AS avg_bmi,
    CASE 
        WHEN AVG(BMI) < 18.5 THEN 'Underweight'
        WHEN AVG(BMI) BETWEEN 18.5 AND 24.9 THEN 'Normal'
        WHEN AVG(BMI) BETWEEN 25 AND 29.9 THEN 'Overweight'
        ELSE 'Obese'
    END AS category
FROM weight_log_info
GROUP BY Id;


-- --------------------------------------------
-- WEIGHT REGISTRATION
-- --------------------------------------------

CREATE VIEW weight_registration AS
SELECT 
    u.user_id, 
    AVG(w.WeightKg) AS avg_weight
FROM users AS u
LEFT JOIN weight_log_info AS w
    ON u.user_id = w.Id
GROUP BY u.user_id;


-- --------------------------------------------
-- USER SUMMARY
-- --------------------------------------------

CREATE VIEW user_summary AS
SELECT 
    d.Id,
    AVG(d.TotalSteps) AS avg_steps,
    AVG(d.Calories) AS avg_calories,
    AVG(s.TotalMinutesAsleep) AS avg_sleep,
    AVG(w.WeightKg) AS avg_weight,
    AVG(w.BMI) AS avg_bmi
FROM daily_activity AS d
LEFT JOIN sleep_day AS s ON d.Id = s.Id
LEFT JOIN weight_log_info AS w ON d.Id = w.Id
GROUP BY d.Id;


-- --------------------------------------------
-- ACTIVITY LEVEL CLASSIFICATION
-- --------------------------------------------

CREATE VIEW activity_level AS
SELECT Id, avg_steps, CASE
        WHEN avg_steps < 5000 THEN 'Sedentary'
        WHEN avg_steps BETWEEN 5000 AND 10000 THEN 'Moderate'
        ELSE 'Active'
    END AS activity_lvl
FROM user_summary;


-- --------------------------------------------
-- FINAL ANALYSIS VIEW
-- --------------------------------------------

CREATE VIEW analysis AS
SELECT
    u.*,
    a.activity_lvl,
    b.category AS bmi_category
FROM user_summary AS u
LEFT JOIN activity_level AS a ON u.Id = a.Id
LEFT JOIN bmi_classification AS b ON u.Id = b.Id;
