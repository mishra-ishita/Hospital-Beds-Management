-- Day 2
-- Topics: WHERE clause, comparison operators, basic filtering

# 1. Find all patients who are older than 60 years.
SELECT * FROM patients where age > 60;

# 2. Retrieve all staff members who work in the 'Emergency' service.
SELECT * FROM staff where service = 'Emergency';

# 3. List all weeks where more than 100 patients requested admission in any service.
SELECT week, service, patients_request FROM services_weekly WHERE patients_request > 100;

### Daily Challenge:
-- Find all patients admitted to 'Surgery' service with a satisfaction 
-- score below 70, showing their patient_id, name, age, and satisfaction score.
SELECT patient_id, name, age, satisfaction FROM patients WHERE service = 'Surgery' AND satisfaction < 70;