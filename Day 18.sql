-- Day 18
-- Topics: UNION, UNION ALL, combining result sets

-- 1. Combine patient names and staff names into a single list
SELECT name FROM patients
UNION
SELECT staff_name FROM staff;

-- 2. Create a union of high satisfaction patients (>90) and low satisfaction patients (<50)
SELECT patient_id, name, satisfaction, 'High Satisfaction' AS category FROM patients WHERE satisfaction > 90
UNION
SELECT patient_id, name, satisfaction, 'Low Satisfaction' AS category FROM patients WHERE satisfaction < 50;

-- 3. List all unique names from both patients and staff tables
SELECT name AS person_name FROM patients
UNION
SELECT staff_name AS person_name FROM staff;

-- ### Daily Challenge:
-- Question:Create a comprehensive personnel and patient list showing: identifier (patient_id or staff_id), full name, type ('Patient' 
-- or 'Staff'), and associated service.Include only those in 'surgery' or 'emergency' services. Order by type, then service, then name.
SELECT p.patient_id AS identifier, p.name AS full_name, 'Patient' AS type, p.service 
FROM patients p WHERE p.service IN ('surgery', 'emergency')
UNION ALL
SELECT s.staff_id AS identifier, s.staff_name AS full_name,'Staff' AS type, s.service
FROM staff s WHERE s.service IN ('surgery', 'emergency') ORDER BY type, service, full_name;