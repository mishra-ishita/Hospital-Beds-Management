-- Day 20 
-- Topics: SUM() OVER, AVG() OVER, running totals, moving averages

-- 1. Calculate running total of patients admitted by week for each service.
SELECT sw.service,  sw.week,  sw.patients_admitted, SUM(sw.patients_admitted) OVER (PARTITION BY sw.service 
           ORDER BY sw.week ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_admitted FROM services_weekly sw;

-- 2. Find the moving average of patient satisfaction over 4-week periods. 
SELECT sw.service, sw.week, sw.patients_admitted, AVG(sw.patient_satisfaction) OVER (PARTITION BY sw.service
        ORDER BY sw.week ROWS BETWEEN 3 PRECEDING AND CURRENT ROW) AS moving_avg_satisfaction FROM services_weekly sw;

-- 3. Show cumulative patient refusals by week across all services.
SELECT sw.service, sw.week, sw.patients_admitted, sw.patients_admitted - (SELECT AVG(x.patients_admitted)  FROM services_weekly x 
         WHERE x.service = sw.service) AS diff_from_service_avg FROM services_weekly sw WHERE sw.week BETWEEN 10 AND 20 
         ORDER BY sw.service, sw.week;


-- Daily Challenge:
-- Question: Create a trend analysis showing for each service and week: week number, patients_admitted, running total of patients 
-- admitted (cumulative), 3-week moving average of patient satisfaction (current week and 2 prior weeks), and the difference between 
-- current week admissions and the service average. Filter for weeks 10-20 only.
SELECT service, week, patient_satisfaction, patients_admitted, rn
FROM (SELECT service, week, patient_satisfaction, patients_admitted,
        RANK() OVER (PARTITION BY service ORDER BY patient_satisfaction DESC) AS rn
    FROM services_weekly) AS ranked WHERE rn <= 3 ORDER BY service, rn, week;




   