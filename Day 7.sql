-- Day 7
-- Topics: HAVING clause, filtering aggregated results

-- 1. Find services that have admitted more than 500 patients in total.
SELECT service, SUM(patients_admitted) AS total_patient FROM services_weekly 
GROUP BY service HAVING SUM(patients_admitted) > 500 ORDER BY total_patient DESC;

-- 2. Show services where average patient satisfaction is below 75.
SELECT service, AVG(patient_satisfaction) AS average_patient_satisfaction FROM services_weekly 
GROUP BY service HAVING AVG(patient_satisfaction) < 75 ORDER BY average_patient_satisfaction DESC;

SELECT service, AVG(patient_satisfaction) FROM services_weekly GROUP BY service;

-- 3. List weeks where total staff presence across all services was less than 50.
SELECT service, week, SUM(present) FROM staff_schedule GROUP BY service, week HAVING SUM(present) < 50 ORDER BY week ASC;
SELECT week, SUM(present) FROM staff_schedule GROUP BY week HAVING SUM(present) < 50 ORDER BY week ASC;

-- ### Daily Challenge:
-- Question: Identify services that refused more than 100 patients in total and
-- had an average patient satisfaction below 80. Show service name, total refused, and average satisfaction.
SELECT service, SUM(patients_refused) AS total_refused, AVG(patient_satisfaction) AS average_satisfaction FROM services_weekly 
GROUP BY service HAVING SUM(patients_refused) > 100 AND AVG(patient_satisfaction) < 80 
ORDER BY total_refused DESC, average_satisfaction ASC;