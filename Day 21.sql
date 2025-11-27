-- Day 21
-- Topics: WITH clause, CTEs, recursive CTEs (if applicable), query organization

-- 1. Create a CTE to calculate service statistics, then query from it.
WITH service_stats AS (
    SELECT
        service, SUM(patients_admitted) AS total_admitted, SUM(patients_refused) AS total_refused,
        AVG(patient_satisfaction) AS avg_satisfaction FROM services_weekly GROUP BY service
)
SELECT * FROM service_stats ORDER BY total_admitted DESC;

-- 2. Use multiple CTEs to break down a complex query into logical steps.
WITH weekly_patients AS (
    SELECT service, EXTRACT(WEEK FROM arrival_date) AS week, COUNT(*) AS patients_count
    FROM patients GROUP BY service, EXTRACT(WEEK FROM arrival_date)
),
weekly_staff AS (
    SELECT service, week, COUNT(*) AS staff_present FROM staff_schedule
    WHERE present = 'Yes' GROUP BY service, week
)
SELECT p.service, p.week, p.patients_count, s.staff_present,
    ROUND(CAST(p.patients_count AS FLOAT) / s.staff_present, 2) AS patient_per_staff_ratio
FROM weekly_patients p LEFT JOIN weekly_staff s ON p.service = s.service AND p.week = s.week ORDER BY p.service, p.week;

-- 3. Build a CTE for staff utilization and join it with patient data.
WITH staff_utilization AS (
    SELECT staff_id, service, COUNT(*) AS days_present,
        (COUNT(*) * 1.0 / (SELECT COUNT(*) FROM staff_schedule ss2 WHERE ss2.staff_id = staff_schedule.staff_id)) AS utilization_rate
    FROM staff_schedule WHERE present = 'Yes' GROUP BY staff_id, service
),
service_satisfaction AS (
    SELECT service, AVG(patient_satisfaction) AS avg_satisfaction
    FROM services_weekly GROUP BY service
)
SELECT su.staff_id, su.service, su.utilization_rate, ss.avg_satisfaction
FROM staff_utilization su LEFT JOIN service_satisfaction ss ON su.service = ss.service ORDER BY su.utilization_rate DESC;


### Daily Challenge:
-- Question: Create a comprehensive hospital performance dashboard using CTEs. Calculate: 1) Service-level metrics (total admissions, 
-- refusals, avg satisfaction), 2) Staff metrics per service (total staff, avg weeks present), 3) Patient demographics per service 
-- (avg age, count). Then combine all three CTEs to create a final report showing service name, all calculated metrics, and an overall 
-- performance score (weighted average of admission rate and satisfaction). Order by performance score descending.
-- Step 0: Final Dashboard Query
WITH 
service_metrics AS (
    SELECT service, SUM(patients_admitted) AS total_admissions, SUM(patients_refused) AS total_refusals,
        AVG(patient_satisfaction) AS avg_satisfaction, SUM(patients_admitted + patients_refused) AS total_requests,
        CASE WHEN SUM(patients_admitted + patients_refused) > 0
             THEN CAST(SUM(patients_admitted) AS FLOAT) / SUM(patients_admitted + patients_refused)
             ELSE 0
        END AS admission_rate FROM services_weekly GROUP BY service),
staff_metrics AS (
    SELECT service, COUNT(DISTINCT staff_id) AS total_staff, AVG(present_count) AS avg_weeks_present
    FROM (
        SELECT staff_id, service, COUNT(*) AS present_count FROM staff_schedule
        WHERE present = 'Yes' GROUP BY staff_id, service) AS staff_presence GROUP BY service),
patient_demographics AS (
    SELECT
        service, COUNT(*) AS total_patients, AVG(age) AS avg_age FROM patients GROUP BY service)
SELECT
    sm.service, sm.total_admissions, sm.total_refusals, ROUND(sm.avg_satisfaction, 2) AS avg_satisfaction,
    ROUND(sm.admission_rate, 2) AS admission_rate, COALESCE(stm.total_staff, 0) AS total_staff,
    ROUND(COALESCE(stm.avg_weeks_present, 0), 2) AS avg_weeks_present, pd.total_patients,
    ROUND(pd.avg_age, 1) AS avg_age, ROUND((0.7 * sm.admission_rate + 0.3 * sm.avg_satisfaction), 2) AS performance_score
FROM service_metrics sm LEFT JOIN staff_metrics stm ON sm.service = stm.service 
LEFT JOIN patient_demographics pd ON sm.service = pd.service ORDER BY performance_score DESC;
