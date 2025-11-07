-- Day 5 
-- Topics: COUNT, SUM, AVG, MIN, MAX functions

-- 1️. Count the total number of patients in the hospital  
SELECT COUNT(patient_id) AS total_patients FROM patients;

-- 2️. Calculate the average satisfaction score of all patients  
SELECT AVG(satisfaction) AS avg_satisfaction FROM patients;

-- 3️. Find the minimum and maximum age of patients  
SELECT MIN(age) AS minimum_age, MAX(age) AS maximum_age FROM patients;


-- ### Daily Challenge:
-- Question: Calculate the total number of patients admitted, total patients refused, and 
-- the average patient satisfaction across all services and weeks. Round the average satisfaction to 2 decimal places.
SELECT SUM(patients_admitted) AS total_patients_admitted, SUM(patients_refused) AS total_patients_refused,
ROUND(AVG(patient_satisfaction), 2) AS avg_patient_satisfaction FROM services_weekly;
