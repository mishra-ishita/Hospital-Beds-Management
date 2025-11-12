-- Day 9
-- Topics: DATE functions, date arithmetic, EXTRACT

-- 1. Extract the year from all patient arrival dates.
SELECT arrival_date, YEAR(arrival_date) AS arrival_year FROM patients;

-- 2. Calculate the length of stay for each patient (departure_date - arrival_date).
SELECT patient_id, arrival_date, departure_date, DATEDIFF(departure_date, arrival_date) AS length_of_stay FROM patients;

-- 3. Find all patients who arrived in a specific month.
SELECT patient_id, MONTH(arrival_date) AS arrival_month FROM patients;

### Daily Challenge:
-- Question: Calculate the average length of stay (in days) for each service, showing only services where the average stay 
-- is more than 7 days. Also show the count of patients and order by average stay descending.
SELECT service,AVG(DATEDIFF(departure_date, arrival_date)) AS avg_length_of_stay, COUNT(patient_id) AS total_patients FROM patients
GROUP BY service HAVING AVG(DATEDIFF(departure_date, arrival_date)) > 7 ORDER BY total_patients,avg_length_of_stay DESC;