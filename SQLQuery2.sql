-- 1. Create a new database named "Hospital Backup DB" (if not exists)
IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Hospital Backup DB')
BEGIN
    CREATE DATABASE [Hospital Backup DB];
    PRINT 'Database "Hospital Backup DB" created successfully.';
END
ELSE
BEGIN
    PRINT 'Database "Hospital Backup DB" already exists.';
END
GO

-- 2. Drop the database named "Hospital Backup DB" if it exists
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Hospital Backup DB')
BEGIN
    DROP DATABASE [Hospital Backup DB];
    PRINT 'Database "Hospital Backup DB" dropped successfully.';
END
ELSE
BEGIN
    PRINT 'Database "Hospital Backup DB" does not exist.';
END
GO

-- 3. Rename the current database from "Hospital DB" to "Medical Center DB"
IF EXISTS (SELECT name FROM sys.databases WHERE name = 'Hospital DB')
    AND NOT EXISTS (SELECT name FROM sys.databases WHERE name = 'Medical Center DB')
BEGIN
    ALTER DATABASE [Hospital DB] MODIFY NAME = [Medical Center DB];
    PRINT 'Database renamed from "Hospital DB" to "Medical Center DB".';
END
ELSE
BEGIN
    PRINT 'Rename skipped (either "Hospital DB" does not exist or "Medical Center DB" already exists).';
END
GO

-- 4. Display the name of the currently selected database
PRINT 'Current Database: ' + DB_NAME();
GO

-- 5. Create a temporary table #temp_patient_vitals
IF OBJECT_ID('tempdb..#temp_patient_vitals') IS NULL
BEGIN
    CREATE TABLE #temp_patient_vitals (
        temp_id INT,
        patient_id VARCHAR(50),
        blood_pressure VARCHAR(10),
        temperature DECIMAL(4,2),
        heart_rate INT
    );
    PRINT 'Temporary table "#temp_patient_vitals" created successfully.';
END
ELSE
BEGIN
    PRINT 'Temporary table "#temp_patient_vitals" already exists.';
END
GO


--------------------------------------------------------------------------------------------------------------------------

-- 6. Create a permanent table named "staff"
IF OBJECT_ID('dbo.staff', 'U') IS NULL
BEGIN
    CREATE TABLE staff (
        staff_id VARCHAR(50) PRIMARY KEY,
        first_name VARCHAR(100) NOT NULL,
        last_name VARCHAR(100) NOT NULL,
        position VARCHAR(100),
        department_id VARCHAR(50),
        hire_date DATE,
        salary DECIMAL(10,2)
    );
    PRINT 'Table "staff" created successfully.';
END
ELSE
BEGIN
    PRINT 'Table "staff" already exists.';
END
GO

-- 7. Drop the table named "staff"
IF OBJECT_ID('dbo.staff', 'U') IS NOT NULL
BEGIN
    DROP TABLE staff;
    PRINT 'Table "staff" dropped successfully.';
END
ELSE
BEGIN
    PRINT 'Table "staff" does not exist.';
END
GO

-- 8. Rename the table "patients" to "clients"
IF OBJECT_ID('dbo.patients', 'U') IS NOT NULL
    AND OBJECT_ID('dbo.clients', 'U') IS NULL
BEGIN
    EXEC sp_rename 'dbo.patients', 'clients';
    PRINT 'Table "patients" renamed to "clients".';
END
ELSE
BEGIN
    PRINT 'Rename skipped (either "patients" does not exist or "clients" already exists).';
END
GO

-- 9. Truncate all records from the "lab_results" table but keep the table structure
IF OBJECT_ID('dbo.lab_results', 'U') IS NOT NULL
BEGIN
    TRUNCATE TABLE lab_results;
    PRINT 'Table "lab_results" truncated successfully.';
END
ELSE
BEGIN
    PRINT 'Table "lab_results" does not exist.';
END
GO

-- 10. Create a copy of the "doctors" table named "doctors_backup" with all its data
IF OBJECT_ID('dbo.doctors', 'U') IS NOT NULL
    AND OBJECT_ID('dbo.doctors_backup', 'U') IS NULL
BEGIN
    SELECT * INTO doctors_backup FROM doctors;
    PRINT 'Table "doctors_backup" created successfully with data copied.';
END
ELSE
BEGIN
    PRINT 'Copy skipped (either "doctors" does not exist or "doctors_backup" already exists).';
END
GO

--------------------------------------------------------------------------------------------------------------------------------------

USE [Hospital_DB];
GO

-- 11. Select all columns for patient with patient id ’PAT015’
SELECT * 
FROM clients
WHERE patient_id = 'PAT015';
GO

-- 12. Select first name, last name, and phone number for patient with last name ’Al-Fayed’
SELECT first_name, last_name, phone
FROM clients
WHERE last_name = 'Al-Fayed';
GO

-- 13. Select all doctors who work in the Cardiology department (department id ’DEPT001’)
SELECT * 
FROM doctors
WHERE department_id = 'DEPT001';
GO

-- 14. Select all appointments scheduled for February 15, 2024
SELECT *
FROM appointments
WHERE appointment_date = '2024-02-15';
GO

-- 15. Select all patients born between January 1, 1990 and December 31, 1995
SELECT *
FROM clients
WHERE date_of_birth BETWEEN '1990-01-01' AND '1995-12-31';
GO

-------------------------------------------------------------------------------------
USE [Hospital_DB];
GO

INSERT INTO clients (
    patient_id,
    first_name,
    last_name,
    date_of_birth,
    gender,
    address,
    phone,
    email,
    emergency_contact,
    blood_type,
    allergies
)
VALUES (
    'PAT051',
    'Ali',
    'Hassan',
    '1988-11-03',
    'Male',
    '123 Palm Street, Dubai',
    '971-555-0123',
    'ali.hassan@email.com',
    'Fatima Hassan-971-555-0124',
    'B+',
    'None'
);
GO
----------------------------------------------------------------------------------------
USE [Hospital_DB];
GO

INSERT INTO medicines (
    medicines_id,
    name,
    description,
    stock_quantity,
    unit_price,
    expiry_date
)
VALUES
    ('MED016', 'Paracetamol', 'Pain reliever', 1500, 7.50, '2026-05-31'),
    ('MED017', 'Amoxicillin-Clavulanate', 'Antibiotic', 800, 22.75, '2025-10-15'),
    ('MED018', 'Metoprolol Succinate', 'Beta blocker', 600, 18.25, '2025-11-30');
GO
SELECT * FROM medicines WHERE medicines_id IN ('MED016','MED017','MED018');
------------------------------------------------------------------------------------------

USE [Hospital_DB];
GO

INSERT INTO clients (
    patient_id,
    first_name,
    last_name,
    date_of_birth,
    gender,
    address,
    phone,
    email,
    emergency_contact,
    blood_type,
    allergies
)
VALUES (
    'PAT025',
    'Omar',
    'Youssef',
    '1995-04-18',
    'Male',
    '456 Nile Street, Cairo',
    '201-555-7890',
    'omar.youssef@email.com',
    'Ahmed Youssef - 201-555-7891',
    'A+',
    'None'
);
GO

INSERT INTO appointments (
    appointments_id,
    appointment_date,
    appointment_time,
    status,
    reason,
    notes,
    department_id,
    doctor_id,
    patient_id
)
VALUES (
    'APP020',
    '2024-03-10',
    '10:30:00',
    'Scheduled',
    'Routine checkup',
    'First appointment for patient PAT025',
    NULL,
    'DOC003',
    'PAT025'
);
GO

SELECT * 
FROM appointments 
WHERE appointments_id = 'APP020';


----------------------------------------------------------------------------------------

USE [Hospital_DB];
GO

-- امسح القسم القديم
DELETE FROM departments
WHERE department_id = 'DEPT011';
GO

-- اعمل إدخال جديد
INSERT INTO departments (department_id, name, location, phone)
VALUES ('DEPT011', 'Physical Therapy', 'Floor 5, Wing A', '555-1011');
GO

-- عرض للتأكد
SELECT * FROM departments;
GO


-----------------------------------------------------------------------------------------------------------
USE [Hospital_DB];
GO

INSERT INTO lab_tests (lab_tests_id, name, description, cost)
VALUES 
('LAB011', 'HIV Test', 'Test for HIV antibodies', 150.00),
('LAB012', 'Hepatitis Panel', 'Test for Hepatitis A, B, and C', 225.00);
GO

-- للتأكد
SELECT * FROM lab_tests;
GO
-------------------------------------------------------------------------------------
USE [Hospital_DB];
GO

-- 21. تحديث رقم هاتف مريض
UPDATE clients
SET phone = '966-500-2007'
WHERE patient_id = 'PAT007';
GO

-- 22. تحديث حالة ميعاد
UPDATE appointments
SET status = 'Completed'
WHERE appointments_id = 'APT012';
GO

-- 23. تحديث كمية المخزون لدواء
UPDATE medicines
SET stock_quantity = 2500
WHERE medicines_id = 'MED005';
GO

-- 24. تحديث إيميل دكتور
UPDATE doctors
SET email = 'lisa.thomas@medicalcenter.com'
WHERE doctor_id = 'DOC008';
GO

-- 25. تحديث حالة الدفع لفاتورة
UPDATE bills
SET payment_status = 'Paid',
    paid_amount = 350.00
WHERE bills_id = 'BILL004';
GO
-----------------------------------------------------------
USE [Hospital_DB];
GO

-- 26. حذف سجل المريض PAT042
DELETE FROM clients
WHERE patient_id = 'PAT042';
PRINT 'Deleted patient PAT042';

-- 27. حذف جميع المواعيد قبل 1 يناير 2020
DELETE FROM appointments
WHERE appointment_date < '2020-01-01';
PRINT 'Deleted appointments before 2020-01-01';

-- 28. حذف سجلات المرضى المكررة مع الاحتفاظ بأقدم سجل
WITH PatientCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY first_name, last_name, date_of_birth
               ORDER BY patient_id ASC
           ) AS rn
    FROM clients
)
DELETE FROM PatientCTE
WHERE rn > 1;
PRINT 'Deleted duplicate patient records, keeping earliest';

-- 29. حذف جميع الأدوية المنتهية قبل اليوم
DELETE FROM prescription_medicines
WHERE medicine_id IN (SELECT medicine_id FROM medicines WHERE expiry_date < CAST(GETDATE() AS DATE));

DELETE FROM medicines
WHERE expiry_date < CAST(GETDATE() AS DATE);


-- 30. حذف جميع نتائج المختبر للمريض PAT018
DELETE FROM lab_results
WHERE patient_id = 'PAT018';
PRINT 'Deleted lab results for patient PAT018';
GO

-- عرض النتائج للتأكد
PRINT 'Remaining patients:';
SELECT * FROM clients;

PRINT 'Remaining appointments:';
SELECT * FROM appointments;

PRINT 'Remaining medicines:';
SELECT * FROM medicines;

PRINT 'Remaining lab results:';
SELECT * FROM lab_results;
GO


--------------------------------------------------------------------------------------
-- 31. Find all female patients born before 1985
SELECT *
FROM clients
WHERE gender = 'Female'
  AND date_of_birth < '1985-01-01';

-- 32. Find patients with blood type 'O+' who have no allergies
SELECT *
FROM clients
WHERE blood_type = 'O+'
  AND allergies = 'None';

-- 33. Find all appointments for doctor with doctor id 'DOC005' that are marked as 'Completed'
SELECT *
FROM appointments
WHERE doctor_id = 'DOC005'
  AND status = 'Completed';

-- 34. Find all bills with total amount greater than $300 and payment status 'Pending'
SELECT *
FROM bills
WHERE total_amount > 300
  AND payment_status = 'Pending';

-- 35. Find medicines with stock quantity less than 100 and unit price greater than $15
SELECT *
FROM medicines
WHERE stock_quantity < 100
  AND unit_price > 15;

  -----------------------------------------------------------------
 -- 36. Find departments that have more than 3 doctors assigned to them
SELECT department_id, COUNT(*) AS doctor_count
FROM doctors
GROUP BY department_id
HAVING COUNT(*) > 3;
GO

-- 37. Find doctors who have conducted more than 5 appointments
SELECT doctor_id, COUNT(*) AS appointment_count
FROM appointments
GROUP BY doctor_id
HAVING COUNT(*) > 5;
GO

-- 38. Find patients who have had more than 2 appointments
SELECT patient_id, COUNT(*) AS appointment_count
FROM appointments
GROUP BY patient_id
HAVING COUNT(*) > 2;
GO

-- 39. Find medicine names that have an average price greater than $20
SELECT name, AVG(unit_price) AS avg_price
FROM medicines
GROUP BY name
HAVING AVG(unit_price) > 20;
GO

-- 40. Find departments that have an average appointment duration longer than 30 minutes
-- نفترض إنك عندك عمود start_time و end_time في appointments أو تحسب بالوقت الافتراضي
-- هنا مثال لو عندك appointment_time + مدة ثابتة 30 دقيقة لكل موعد:
SELECT department_id, AVG(30) AS avg_duration -- 30 دقيقة كمثال لكل موعد
FROM appointments
GROUP BY department_id
HAVING AVG(30) > 30; -- يبقى تختار القيمة المناسبة حسب بياناتك
GO
-----------------------------------------------------

--------------------------------------------------
--------------------------------------------------------------------------

-- 51. Select the first 5 patients ordered by date of birth ascending
SELECT TOP 5 *
FROM clients
ORDER BY date_of_birth ASC;
GO

-- 52. Select the 10 most expensive medicines by unit price
SELECT TOP 10 *
FROM medicines
ORDER BY unit_price DESC;
GO

-- 53. Select the 5 most recent appointments
SELECT TOP 5 *
FROM appointments
ORDER BY appointment_date DESC, appointment_time DESC;
GO

-- 54. Select the 3 doctors with the most appointments
SELECT TOP 3 doctor_id, COUNT(*) AS appointment_count
FROM appointments
GROUP BY doctor_id
ORDER BY COUNT(*) DESC;
GO

-- 55. Select the 5 highest bill amounts
SELECT TOP 5 *
FROM bills
ORDER BY total_amount DESC;
GO
---------------------------------------------------------------------------------------

-- 56. Find all distinct specializations from the doctors table
SELECT DISTINCT specialization
FROM doctors;
GO

-- 57. Find all distinct blood types from the clients table
SELECT DISTINCT blood_type
FROM clients;
GO

-- 58. Find all distinct appointment statuses from the appointments table
SELECT DISTINCT status
FROM appointments;
GO

-- 59. Find all distinct payment methods from the bills table
SELECT DISTINCT payment_method
FROM bills;
GO

-- 60. Find all distinct allergy values from the clients table
SELECT DISTINCT allergies
FROM clients;
GO

-------------------------------------------------------------------------------

-- 61. Fetch the first 10 patients ordered by date of birth descending
SELECT *
FROM clients
ORDER BY date_of_birth DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;
GO

-- 62. Fetch the next 5 appointments after skipping the first 10, ordered by appointment date
SELECT *
FROM appointments
ORDER BY appointment_date ASC
OFFSET 10 ROWS FETCH NEXT 5 ROWS ONLY;
GO

-- 63. Fetch the top 3 most expensive medicines by unit price
SELECT TOP 3 *
FROM medicines
ORDER BY unit_price DESC;
GO

-- 64. Fetch the first 5 bills with the highest amounts
SELECT TOP 5 *
FROM bills
ORDER BY total_amount DESC;
GO

-- 65. Fetch the first 10 doctors ordered by last name ascending
SELECT TOP 10 *
FROM doctors
ORDER BY last_name ASC;
GO
-------------------------------------------------------------------------------------------

-- 66. Display patient first name and last name as "Full Name"
SELECT first_name + ' ' + last_name AS [Full Name]
FROM clients;
GO

-- 67. Display appointment date as "Visit Date" and appointment time as "Visit Time"
SELECT appointment_date AS [Visit Date], appointment_time AS [Visit Time]
FROM appointments;
GO

-- 68. Display doctor first name and last name as "Physician Name" and specialization as "Specialty"
SELECT first_name + ' ' + last_name AS [Physician Name], specialization AS [Specialty]
FROM doctors;
GO

-- 69. Display bill total amount as "Total Charge" and paid amount as "Amount Paid"
SELECT total_amount AS [Total Charge], paid_amount AS [Amount Paid]
FROM bills;
GO

-- 70. Display medicine name as "Drug Name" and unit price as "Price per Unit"
SELECT name AS [Drug Name], unit_price AS [Price per Unit]
FROM medicines;
GO
------------------------------------------------------------------------------------------
-- 71. Find female patients with blood type 'A+' who have no allergies
SELECT *
FROM clients
WHERE gender = 'Female'
  AND blood_type = 'A+'
  AND allergies IS NULL;
GO

-- 72. Find appointments for Cardiology department (DEPT001) with status 'Completed' in January 2024
SELECT *
FROM appointments
WHERE department_id = 'DEPT001'
  AND status = 'Completed'
  AND appointment_date >= '2024-01-01'
  AND appointment_date <= '2024-01-31';
GO

-- 73. Find bills with total amount > $500, payment status 'Pending', billed in last 30 days
SELECT *
FROM bills
WHERE total_amount > 500
  AND payment_status = 'Pending'
  AND billing_date >= DATEADD(DAY, -30, GETDATE());
GO

-- 74. Find doctors in Surgery department (DEPT007), last name starts with 'S', specialization contains 'Surgeon'
SELECT *
FROM doctors
WHERE department_id = 'DEPT007'
  AND last_name LIKE 'S%'
  AND specialization LIKE '%Surgeon%';
GO

-- 75. Find patients born between 1980-1990, no allergies, blood type contains 'O'
SELECT *
FROM clients
WHERE date_of_birth BETWEEN '1980-01-01' AND '1990-12-31'
  AND allergies IS NULL
  AND blood_type LIKE 'O%';
GO

-------------------------------------------------------------------------------------------------------
USE Hospital_DB;
GO

-- 76. Find patients with blood type ’O+’ or ’O-’
SELECT *
FROM clients
WHERE blood_type IN ('O+', 'O-');
GO

-- 77. Find appointments for Cardiology (DEPT001) or Neurology (DEPT002)
SELECT *
FROM appointments
WHERE department_id IN ('DEPT001', 'DEPT002');
GO

-- 78. Find bills with payment status ’Paid’ or ’Partial’
SELECT *
FROM bills
WHERE payment_status IN ('Paid', 'Partial');
GO

-- 79. Find doctors with specialization ’Cardiologist’ or ’Neurologist’
SELECT *
FROM doctors
WHERE specialization IN ('Cardiologist', 'Neurologist');
GO

-- 80. Find patients with allergies to ’Penicillin’ or ’Aspirin’
SELECT *
FROM clients
WHERE allergies IN ('Penicillin', 'Aspirin');
GO
---------------------------------------------------------------------------------------------
USE Hospital_DB;
GO

-- 81. Find patients who are not male
SELECT *
FROM clients
WHERE gender <> 'Male';
GO

-- 82. Find appointments that are not in 'Completed' status
SELECT *
FROM appointments
WHERE status <> 'Completed';
GO

-- 83. Find bills that are not fully paid (paid amount < total amount)
SELECT *
FROM bills
WHERE paid_amount < total_amount;
GO

-- 84. Find medicines that are not expired (expiry_date > current date)
SELECT *
FROM medicines
WHERE expiry_date > CAST(GETDATE() AS DATE);
GO

-- 85. Find doctors who are not in the Surgery department (DEPT007)
SELECT *
FROM doctors
WHERE department_id <> 'DEPT007';
GO
--------------------------------------------------------------------------
USE Hospital_DB;
GO

-- 86. Find patients with last name starting with 'Al-'
SELECT *
FROM clients
WHERE last_name LIKE 'Al-%';
GO

-- 87. Find doctors with first name ending with 'a'
SELECT *
FROM doctors
WHERE first_name LIKE '%a';
GO

-- 88. Find medicines with name containing 'cin'
SELECT *
FROM medicines
WHERE name LIKE '%cin%';
GO

-- 89. Find departments with location containing 'Floor 1'
SELECT *
FROM departments
WHERE location LIKE '%Floor 1%';
GO

-- 90. Find patients with email from 'gmail.com' domain
SELECT *
FROM clients
WHERE email LIKE '%@gmail.com';
GO
-------------------------------------------------------------------------------
USE Hospital_DB;
GO

-- 91. Find patients from cities 'Riyadh', 'Dubai', or 'Doha' (based on address field)
SELECT *
FROM clients
WHERE address LIKE '%Riyadh%' 
   OR address LIKE '%Dubai%' 
   OR address LIKE '%Doha%';
GO

-- 92. Find doctors with specialization in 'Cardiologist', 'Neurologist', or 'Pediatrician'
SELECT *
FROM doctors
WHERE specialization IN ('Cardiologist', 'Neurologist', 'Pediatrician');
GO

-- 93. Find appointments with status 'Scheduled', 'Completed', or 'Cancelled'
SELECT *
FROM appointments
WHERE status IN ('Scheduled', 'Completed', 'Cancelled');
GO

-- 94. Find medicines with unit price between $10 and $50
SELECT *
FROM medicines
WHERE unit_price BETWEEN 10 AND 50;
GO

-- 95. Find bills with payment method 'Credit Card', 'Debit Card', or 'Cash'
SELECT *
FROM bills
WHERE payment_method IN ('Credit Card', 'Debit Card', 'Cash');
GO
-------------------------------------------------------------------------------------

USE Hospital_DB;
GO

-- 96. Find patients not from Riyadh (address not containing 'Riyadh')
SELECT *
FROM clients
WHERE address NOT LIKE '%Riyadh%';
GO

-- 97. Find doctors not in Cardiology department (department id != 'DEPT001')
SELECT *
FROM doctors
WHERE department_id != 'DEPT001';
GO

-- 98. Find appointments not scheduled for the current month
SELECT *
FROM appointments
WHERE MONTH(appointment_date) != MONTH(GETDATE())
   OR YEAR(appointment_date) != YEAR(GETDATE());
GO

-- 99. Find medicines not costing between $10 and $50
SELECT *
FROM medicines
WHERE unit_price NOT BETWEEN 10 AND 50;
GO

-- 100. Find bills not paid by insurance (payment method != 'Insurance')
SELECT *
FROM bills
WHERE payment_method != 'Insurance';
GO

------------------------------------------------------------------------------------

USE Hospital_DB;
GO

-- 101. Find all patients who have not provided an emergency contact
SELECT *
FROM clients
WHERE emergency_contact IS NULL;
GO

-- 102. Find all appointments where no doctor has been assigned yet
SELECT *
FROM appointments
WHERE doctor_id IS NULL;
GO

-- 103. List all bills where no payment method has been recorded
SELECT *
FROM bills
WHERE payment_method IS NULL;
GO

-- 104. Find medical records that have no diagnosis notes
SELECT *
FROM medical_records
WHERE diagnosis IS NULL;
GO

-- 105. Find patients who have no allergies listed
SELECT *
FROM clients
WHERE allergies IS NULL;
GO
----------------------------------------------------------------------------------------------

USE Hospital_DB;
GO

-- 106. Get a combined list of all first names from both the patients and doctors tables (remove duplicates)
SELECT first_name
FROM clients
UNION
SELECT first_name
FROM doctors;
GO

-- 107. Get a combined list of all last names from both the patients and doctors tables (include duplicates)
SELECT last_name
FROM clients
UNION ALL
SELECT last_name
FROM doctors;
GO

-- 108. Find all patient IDs who have never had an appointment
SELECT patient_id
FROM clients
EXCEPT
SELECT patient_id
FROM appointments;
GO

-- 109. Using UNION, create a list of all person IDs and names from both patients and doctors tables with a type column
SELECT patient_id AS person_id, first_name, last_name, 'Patient' AS type
FROM clients
UNION
SELECT doctor_id AS person_id, first_name, last_name, 'Doctor' AS type
FROM doctors;
GO

-- 110. Find all medicine IDs that are present in the medicines table but have never been prescribed
SELECT medicines_id
FROM medicines
EXCEPT
SELECT medicine_id
FROM prescription_medicines;
GO


----------------------------------------------------------------------------------
USE Hospital_DB;
GO

-- 111. Select all appointments scheduled for the first week of March 2024
SELECT *
FROM appointments
WHERE appointment_date BETWEEN '2024-03-01' AND '2024-03-07';
GO

-- 112. Find all patients born between 1980 and 1990 (inclusive)
SELECT *
FROM clients
WHERE date_of_birth BETWEEN '1980-01-01' AND '1990-12-31';
GO

-- 113. List all bills issued between February 1, 2024, and February 29, 2024, with a total amount between $200 and $500
SELECT *
FROM bills
WHERE billing_date BETWEEN '2024-02-01' AND '2024-02-29'
  AND total_amount BETWEEN 200 AND 500;
GO

-- 114. Find all medicines with a unit price between $10 and $25
SELECT *
FROM medicines
WHERE unit_price BETWEEN 10 AND 25;
GO

-- 115. Select lab tests that cost between $50 and $100
SELECT *
FROM lab_tests
WHERE cost BETWEEN 50 AND 100;
GO


-------------------------------------------------------------------------------------------------------

USE Hospital_DB;
GO

-- 116. Patients older than ALL patients from Dubai
SELECT *
FROM clients
WHERE date_of_birth < ALL (
    SELECT date_of_birth
    FROM clients
    WHERE address LIKE '%Dubai%'
);
GO

-- 117. Doctors with more appointments than ANY doctor in Neurology
SELECT a.doctor_id, COUNT(*) AS appointment_count
FROM appointments a
GROUP BY a.doctor_id
HAVING COUNT(*) > ANY (
    SELECT COUNT(*)
    FROM appointments ap
    JOIN doctors d ON ap.doctor_id = d.doctor_id
    WHERE d.department_id = 'DEPT002'  -- Neurology
    GROUP BY ap.doctor_id
);
GO

-- 118. Medicines more expensive than ALL Pain Relievers
SELECT name, unit_price
FROM medicines
WHERE unit_price > ALL (
    SELECT unit_price
    FROM medicines
    WHERE description LIKE '%Pain reliever%'
);
GO

-- 119. Bills where total amount is greater than ANY bill paid by insurance
SELECT *
FROM bills
WHERE total_amount > ANY (
    SELECT total_amount
    FROM bills
    WHERE payment_method = 'Insurance'
);
GO

-- 120. Appointments shorter than ALL appointments for patient 'PAT001'
-- يجب أن يكون لديك start_time و end_time لإجراء الحساب
SELECT *
FROM appointments
WHERE DATEDIFF(MINUTE, appointment_time, DATEADD(MINUTE, 30, appointment_time)) < ALL (
    SELECT DATEDIFF(MINUTE, appointment_time, DATEADD(MINUTE, 30, appointment_time))
    FROM appointments
    WHERE patient_id = 'PAT001'
);
GO


------------------------------------------------------------------------------------

USE Hospital_DB;
GO

-- 121. Doctors with at least one completed appointment
SELECT *
FROM doctors d
WHERE EXISTS (
    SELECT 1
    FROM appointments a
    WHERE a.doctor_id = d.doctor_id
      AND a.status = 'Completed'
);
GO

-- 122. Patients with at least one unpaid bill (صححنا client_id -> patient_id)
SELECT *
FROM clients c
WHERE EXISTS (
    SELECT 1
    FROM bills b
    WHERE b.patient_id = c.patient_id
      AND b.payment_status != 'Paid'
);
GO


-- 123. Medicines that have been prescribed at least once
SELECT *
FROM medicines m
WHERE EXISTS (
    SELECT 1
    FROM prescription_medicines pm
    WHERE pm.medicine_id = m.medicines_id
);
GO



-- Departments with no doctors assigned
SELECT *
FROM departments d
WHERE NOT EXISTS (
    SELECT 1
    FROM doctors doc
    WHERE doc.department_id = d.department_id
);
GO

-- Patients who have never had an appointment
SELECT *
FROM clients c
WHERE NOT EXISTS (
    SELECT 1
    FROM appointments a
    WHERE a.patient_id = c.patient_id
);
GO


------------------------------------------------------------------------------------------

USE Hospital_DB;
GO

-- 126. COUNT: How many male patients are in the database?
SELECT COUNT(*) AS Male_Patient_Count
FROM clients
WHERE gender = 'Male';
GO

-- 127. SUM: Total outstanding balance for all bills
SELECT SUM(total_amount - paid_amount) AS Total_Outstanding_Balance
FROM bills;
GO

-- 128. MIN: Price of the least expensive medicine
SELECT MIN(unit_price) AS Lowest_Medicine_Price
FROM medicines;
GO

-- 129. MAX: Highest bill amount ever issued
SELECT MAX(total_amount) AS Highest_Bill_Amount
FROM bills;
GO

-- 130. AVG: Average cost of a lab test
SELECT AVG(cost) AS Average_Lab_Test_Cost
FROM lab_tests;
GO


-------------------------------------------------------------------------------

USE Hospital_DB;
GO

-- 131. INNER JOIN: Appointments with patient and doctor full names
SELECT 
    a.appointments_id,
    c.first_name + ' ' + c.last_name AS Patient_FullName,
    d.first_name + ' ' + d.last_name AS Doctor_FullName,
    a.appointment_date,
    a.appointment_time,
    a.status
FROM appointments a
INNER JOIN clients c ON a.patient_id = c.patient_id
INNER JOIN doctors d ON a.doctor_id = d.doctor_id;
GO

-- 132. LEFT JOIN: All patients and their appointments (include patients with no appointments)
SELECT 
    c.first_name + ' ' + c.last_name AS Patient_FullName,
    a.appointments_id,
    a.appointment_date,
    a.status
FROM clients c
LEFT JOIN appointments a ON c.patient_id = a.patient_id;
GO

-- 133. RIGHT JOIN: All doctors and their appointments (include doctors with no appointments)
SELECT 
    d.first_name + ' ' + d.last_name AS Doctor_FullName,
    a.appointments_id,
    a.appointment_date,
    a.status
FROM appointments a
RIGHT JOIN doctors d ON a.doctor_id = d.doctor_id;
GO

-- 134. FULL JOIN: All combinations of patients and doctors, showing appointments or unconnected
SELECT 
    c.first_name + ' ' + c.last_name AS Patient_FullName,
    d.first_name + ' ' + d.last_name AS Doctor_FullName,
    a.appointments_id,
    a.appointment_date,
    a.status
FROM clients c
FULL OUTER JOIN appointments a ON c.patient_id = a.patient_id
FULL OUTER JOIN doctors d ON a.doctor_id = d.doctor_id;
GO

-- 135. Multi-table JOIN for a specific appointment (APT005)
SELECT 
    a.appointments_id,
    c.first_name + ' ' + c.last_name AS Patient_Name,
    d.first_name + ' ' + d.last_name AS Doctor_Name,
    dept.name AS Department_Name,
    a.notes AS Diagnosis_Notes,  -- استخدام العمود notes بدل diagnosis
    b.total_amount AS Bill_Amount
FROM appointments a
INNER JOIN clients c ON a.patient_id = c.patient_id
INNER JOIN doctors d ON a.doctor_id = d.doctor_id
INNER JOIN departments dept ON a.department_id = dept.department_id
LEFT JOIN bills b ON b.appointment_id = a.appointments_id  
WHERE a.appointments_id = 'APT005';
GO



-------------------------------------------------------------------------------------------

USE Hospital_DB;
GO

-- 136. Extract the year of birth for all patients
SELECT first_name, last_name, YEAR(date_of_birth) AS Year_of_Birth
FROM clients;
GO

-- 137. Calculate the age of each patient based on their date of birth
SELECT first_name, last_name, 
       DATEDIFF(YEAR, date_of_birth, GETDATE()) 
       - CASE 
           WHEN DATEADD(YEAR, DATEDIFF(YEAR, date_of_birth, GETDATE()), date_of_birth) > GETDATE() 
           THEN 1 ELSE 0 
         END AS Age
FROM clients;
GO

-- 138. Find all appointments that happened on a Monday
SELECT *
FROM appointments
WHERE DATENAME(WEEKDAY, appointment_date) = 'Monday';
GO

-- 139. Add 30 days to the billing date of each bill to calculate a due date
SELECT bills_id, billing_date, DATEADD(DAY, 30, billing_date) AS Due_Date
FROM bills;
GO

-- 140. Find the number of days between the appointment date and the current date for future appointments
SELECT appointments_id, appointment_date,
       DATEDIFF(DAY, GETDATE(), appointment_date) AS Days_Until_Appointment
FROM appointments
WHERE appointment_date > GETDATE();
GO


-----------------------------------------------------------------------------------------

USE Hospital_DB;
GO

-- 141. Display all patient last names in uppercase
SELECT UPPER(last_name) AS LastName_Upper
FROM clients;
GO

-- 142. Concatenate the first and last name of doctors into a single "Full Name" column
SELECT CONCAT(first_name, ' ', last_name) AS Full_Name
FROM doctors;
GO

-- 143. Extract the first three characters of all patient blood types
SELECT SUBSTRING(blood_type, 1, 3) AS BloodType_Short
FROM clients;
GO

-- 144. Display patient addresses after removing any leading or trailing spaces
SELECT LTRIM(RTRIM(address)) AS Clean_Address
FROM clients;
GO

-- 145. Replace the word 'None' with 'No Known Allergies' in the allergies field
SELECT REPLACE(allergies, 'None', 'No Known Allergies') AS Updated_Allergies
FROM clients;
GO


-----------------------------------------------------------------------------------

USE Hospital_DB;
GO

-- 146. CREATE VIEW: patient names, appointment dates, doctor names
CREATE VIEW vPatientAppointments AS
SELECT 
    CONCAT(c.first_name, ' ', c.last_name) AS Patient_Name,
    a.appointment_date,
    CONCAT(d.first_name, ' ', d.last_name) AS Doctor_Name
FROM appointments a
JOIN clients c ON a.patient_id = c.patient_id
JOIN doctors d ON a.doctor_id = d.doctor_id;
GO

-- 147. UPDATE VIEW: Insert a new patient and check view
INSERT INTO clients (patient_id, first_name, last_name, date_of_birth, gender, address, phone, email)
VALUES ('PAT100', 'Sara', 'Ali', '1992-06-15', 'Female', '456 Palm Street, Dubai', '971-555-0145', 'sara.ali@email.com');
GO

-- Query the view to confirm the new patient appears if they have an appointment
SELECT * FROM vPatientAppointments;
GO

-- 148. RENAME VIEW
EXEC sp_rename 'vPatientAppointments', 'vPatientVisits';
GO

-- 149. DROP VIEW
DROP VIEW vPatientVisits;
GO

-- 150. Create a view that shows total revenue collected (paid amount) per day
CREATE VIEW vDailyRevenue AS
SELECT 
    billing_date,
    SUM(paid_amount) AS Total_Revenue
FROM bills
GROUP BY billing_date;
GO

-- Query the revenue view
SELECT * FROM vDailyRevenue;
GO


---------------------------------------------------------------------------



USE Hospital_DB;
GO

-- 151. Single-Row Subquery: Doctor with highest salary
SELECT first_name, last_name
FROM doctors
WHERE salary = (SELECT MAX(salary) FROM doctors);
GO

-- 152. Multi-Row Subquery: Patients with a doctor from Cardiology (DEPT001)
SELECT first_name, last_name
FROM clients
WHERE patient_id IN (
    SELECT patient_id
    FROM appointments
    WHERE doctor_id IN (
        SELECT doctor_id
        FROM doctors
        WHERE department_id = 'DEPT001'
    )
);
GO

-- 153. Correlated Subquery: Medicines above average price in same stock quantity
SELECT name, unit_price, stock_quantity
FROM medicines m1
WHERE unit_price > (
    SELECT AVG(unit_price)
    FROM medicines m2
    WHERE m2.stock_quantity = m1.stock_quantity
);
GO

-- 154. Subquery in SELECT: Appointments with total appointments per patient
SELECT a.appointments_id, a.appointment_date,
       (SELECT COUNT(*) FROM appointments WHERE patient_id = a.patient_id) AS Total_Appointments
FROM appointments a;
GO

-- 155. Subquery with EXISTS: Departments with at least one doctor who is a surgeon
SELECT *
FROM departments d
WHERE EXISTS (
    SELECT 1
    FROM doctors doc
    WHERE doc.department_id = d.department_id
      AND doc.specialization LIKE '%Surgeon%'
);
GO

-- 156. Subquery with NOT EXISTS: Patients without any pending bill
SELECT *
FROM clients c
WHERE NOT EXISTS (
    SELECT 1
    FROM bills b
    WHERE b.patient_id = c.patient_id
      AND b.payment_status = 'Pending'
);
GO

-- 157. Subquery in HAVING: Doctors with more appointments than average
SELECT doctor_id, COUNT(*) AS appointment_count
FROM appointments
GROUP BY doctor_id
HAVING COUNT(*) > (
    SELECT AVG(appointment_count)
    FROM (
        SELECT doctor_id, COUNT(*) AS appointment_count
        FROM appointments
        GROUP BY doctor_id
    ) AS avg_table
);
GO

-- 158. Subquery with IN: Medicines prescribed to patient PAT001
SELECT name
FROM medicines
WHERE medicines_id IN (
    SELECT medicine_id
    FROM prescription_medicines pm
    JOIN prescriptions p ON pm.prescription_id = p.prescriptions_id
    WHERE p.patient_id = 'PAT001'
);
GO

-- 159. Subquery in UPDATE: Increase stock by 50 for medicines prescribed >10 times last month
UPDATE medicines
SET stock_quantity = stock_quantity + 50
WHERE medicines_id IN (
    SELECT pm.medicine_id
    FROM prescription_medicines pm
    JOIN prescriptions p ON pm.prescription_id = p.prescriptions_id
    WHERE p.prescription_date >= DATEADD(MONTH, -1, GETDATE())
    GROUP BY pm.medicine_id
    HAVING COUNT(*) > 10
);
GO

-- 160. Subquery in DELETE: Delete lab tests never performed
DELETE FROM lab_tests
WHERE lab_tests_id NOT IN (
    SELECT DISTINCT lab_test_id
    FROM lab_results
);
GO


------------------------------------------------------------------------------------------------

BACKUP DATABASE [Hospital_DB]
TO DISK = N'D:\Backups\Hospital DB Full.bak'
WITH NAME = N'Hospital DB Full Backup',
     FORMAT,
     INIT,
     STATS = 10;
GO










USE master;
GO


ALTER DATABASE Hospital_DB 
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO


RESTORE DATABASE Hospital_DB
FROM DISK = N'D:\Backups\Hospital DB Full.bak'
WITH REPLACE,
     STATS = 10;
GO


ALTER DATABASE Hospital_DB SET MULTI_USER;
GO
