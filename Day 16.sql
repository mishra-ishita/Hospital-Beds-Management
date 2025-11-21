-- Day 16
-- Topics: Subqueries in WHERE, nested queries, filtering with subqueries

-- 1. Find patients who are in services with above-average staff count.
SELECT p.patient_id, p.name, p.service FROM patients p
JOIN (
    SELECT service, COUNT(staff_id) AS staff_count FROM staff GROUP BY service
    HAVING COUNT(staff_id) > ( SELECT AVG(service_staff_count)
        FROM (
            SELECT COUNT(staff_id) AS service_staff_count FROM staff
            GROUP BY service)x)) s ON p.service = s.service;

-- 2. List staff who work in services that had any week with patient satisfaction below 70.
SELECT DISTINCT st.staff_id, st.staff_name, st.role, st.service
FROM staff st WHERE st.service IN (
    SELECT service FROM services_weekly WHERE patient_satisfaction < 70 );

-- 3. Show patients from services where total admitted patients exceed 1000.
SELECT p.patient_id, p.name, p.service
FROM patients p
JOIN (
    SELECT service, SUM(patients_admitted) AS total_admitted FROM services_weekly
    GROUP BY service HAVING SUM(patients_admitted) > 1000
) sw ON p.service = sw.service;

-- Question: Find all patients who were admitted to services that had at least one week where patients were refused AND the average 
-- patient satisfaction for that service was below the overall hospital average satisfaction. 
-- Show patient_id, name, service, and their personal satisfaction score.
SELECT p.patient_id, p.name, p.service, p.satisfaction AS personal_satisfaction
FROM patients p
JOIN (
    SELECT sw.service FROM services_weekly sw GROUP BY sw.service
    HAVING SUM(CASE WHEN sw.patients_refused > 0 THEN 1 END) > 0 
    AND AVG(sw.patient_satisfaction) < (
            SELECT AVG(patient_satisfaction) FROM services_weekly
        )) svc ON p.service = svc.service;
