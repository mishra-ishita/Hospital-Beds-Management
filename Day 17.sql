-- Day 17
-- Topics: Subqueries in SELECT, derived tables, inline views

-- 1.Show each patient with their service's average satisfaction as an additional column.
SELECT p.patient_id, p.name, p.service, p.satisfaction AS personal_satisfaction,
    (SELECT AVG(satisfaction) FROM patients p2 WHERE p2.service = p.service
    ) AS avg_service_satisfaction FROM patients p;
    
-- 2. Create a derived table of service statistics and query from it.
SELECT svc.service, svc.total_patients, svc.avg_satisfaction
FROM (SELECT service, COUNT(*) AS total_patients, AVG(satisfaction) AS avg_satisfaction
    FROM patients GROUP BY service) AS svc ORDER BY total_patients DESC; 
    
-- 3. Display staff with their service's total patient count as a calculated field.
SELECT s.staff_id, s.staff_name, s.role, s.service,
    (SELECT COUNT(*) FROM patients p WHERE p.service = s.service) AS total_patients_in_service FROM staff s;
    
### Daily Challenge:
-- Question: Create a report showing each service with: service name, total patients admitted, the difference between their total admissions
 -- and the average admissions across all services, and a rank indicator ('Above Average', 'Average', 'Below Average'). Order by total 
 -- patients admitted descending.
 SELECT sw.service, SUM(sw.patients_admitted) AS total_admissions, SUM(sw.patients_admitted) -
(SELECT AVG(total_adm) FROM (SELECT SUM(patients_admitted) AS total_adm FROM services_weekly
                GROUP BY service) AS avg_table) AS difference_from_avg,
    CASE 
        WHEN SUM(sw.patients_admitted) >
             (SELECT AVG(total_adm) FROM (SELECT SUM(patients_admitted) AS total_adm FROM services_weekly GROUP BY service
                ) AS avg_table) THEN 'Above Average'
        WHEN SUM(sw.patients_admitted) =
             (SELECT AVG(total_adm) FROM (SELECT SUM(patients_admitted) AS total_adm FROM services_weekly
                    GROUP BY service) AS avg_table) THEN 'Average' ELSE 'Below Average'
    END AS rank_indicator
FROM services_weekly sw GROUP BY sw.service ORDER BY total_admissions DESC;
