USE Hospital_DB;
GO

-- ======================
-- DEPARTMENTS
-- ======================
INSERT INTO departments (department_id, name, location, phone) VALUES
('DEPT001','Cardiology','Floor 1, Wing A','555-1001'),
('DEPT002','Neurology','Floor 1, Wing B','555-1002'),
('DEPT003','Pediatrics','Floor 2, Wing A','555-1003'),
('DEPT004','Orthopedics','Floor 2, Wing B','555-1004'),
('DEPT005','Oncology','Floor 3, Wing A','555-1005'),
('DEPT006','Emergency','Ground Floor','555-1006'),
('DEPT007','Surgery','Floor 3, Wing B','555-1007'),
('DEPT008','Radiology','Basement Floor','555-1008'),
('DEPT009','Psychiatry','Floor 4, Wing A','555-1009'),
('DEPT010','Dermatology','Floor 4, Wing B','555-1010');
GO

-- ======================
-- DOCTORS
-- ======================
INSERT INTO doctors (doctor_id, department_id, first_name, last_name, specialization, phone, email) VALUES
('DOC001','DEPT001','John','Smith','Cardiologist','555-2001','john.smith@hospital.com'),
('DOC002','DEPT001','Sarah','Johnson','Cardiologist','555-2002','sarah.johnson@hospital.com'),
('DOC003','DEPT002','Michael','Brown','Neurologist','555-2003','michael.brown@hospital.com'),
('DOC004','DEPT003','Emily','Davis','Pediatrician','555-2004','emily.davis@hospital.com'),
('DOC005','DEPT004','David','Wilson','Orthopedic','555-2005','david.wilson@hospital.com'),
('DOC006','DEPT005','Sophia','Martinez','Oncologist','555-2006','sophia.martinez@hospital.com'),
('DOC007','DEPT006','James','Anderson','Emergency Physician','555-2007','james.anderson@hospital.com'),
('DOC008','DEPT007','Olivia','Thomas','Surgeon','555-2008','olivia.thomas@hospital.com'),
('DOC009','DEPT008','William','Taylor','Radiologist','555-2009','william.taylor@hospital.com'),
('DOC010','DEPT009','Ava','Harris','Psychiatrist','555-2010','ava.harris@hospital.com');
GO

-- ======================
-- PATIENTS
-- ======================
INSERT INTO patients (patient_id, first_name, last_name, date_of_birth, gender, address, phone, email, emergency_contact, blood_type, allergies) VALUES
('PAT001','Alice','Johnson','1985-02-14','Female','123 Main St','555-3001','alice.johnson@email.com','Bob Johnson - 555-4001','A+','Penicillin'),
('PAT002','Robert','Smith','1990-07-23','Male','456 Oak Ave','555-3002','robert.smith@email.com','Jane Smith - 555-4002','B+','None'),
('PAT003','Maria','Garcia','1978-11-30','Female','789 Pine Rd','555-3003','maria.garcia@email.com','Luis Garcia - 555-4003','O-','Peanuts'),
('PAT004','David','Lee','2001-05-12','Male','321 Cedar Blvd','555-3004','david.lee@email.com','Anna Lee - 555-4004','AB+','Latex'),
('PAT005','Sophia','Khan','1995-09-18','Female','654 Birch Ln','555-3005','sophia.khan@email.com','Omar Khan - 555-4005','O+','Aspirin');
GO

-- ======================
-- MEDICINES
-- ======================
INSERT INTO medicines (medicines_id, name, description, stock_quantity, unit_price, expiry_date) VALUES
('MED001','Paracetamol','Pain reliever',500,2.50,'2026-12-31'),
('MED002','Ibuprofen','Anti-inflammatory',300,3.75,'2026-10-15'),
('MED003','Amoxicillin','Antibiotic',200,5.00,'2025-08-01'),
('MED004','Insulin','Diabetes treatment',150,20.00,'2026-05-30'),
('MED005','Atorvastatin','Cholesterol medication',250,15.00,'2027-01-20');
GO

-- ======================
-- LAB TESTS
-- ======================
INSERT INTO lab_tests (lab_tests_id, name, description, cost) VALUES
('LAB001','Blood Test','Complete blood count',100.00),
('LAB002','X-Ray','Chest X-Ray',150.00),
('LAB003','MRI','Brain MRI',1200.00),
('LAB004','CT Scan','Abdominal CT Scan',900.00),
('LAB005','Urine Test','Urinalysis',80.00);
GO

-- ======================
-- APPOINTMENTS
-- ======================
INSERT INTO appointments (appointments_id, appointment_date, appointment_time, status, reason, notes, department_id, doctor_id, patient_id) VALUES
('APP001','2025-09-20','10:00:00','Scheduled','Regular Checkup','N/A','DEPT001','DOC001','PAT001'),
('APP002','2025-09-21','11:30:00','Completed','Headache','Prescribed medicine','DEPT002','DOC003','PAT002'),
('APP003','2025-09-22','09:00:00','Scheduled','Pediatric visit','Child fever','DEPT003','DOC004','PAT003'),
('APP004','2025-09-23','14:00:00','Cancelled','Back Pain','Rescheduled','DEPT004','DOC005','PAT004'),
('APP005','2025-09-24','16:00:00','Scheduled','Skin rash','N/A','DEPT010','DOC010','PAT005');
GO

-- ======================
-- MEDICAL RECORDS
-- ======================
INSERT INTO medical_records (medical_records_id, patient_id, appointment_id, diagnosis, treatment, record_date, notes, doctor_id) VALUES
('MR001','PAT001','APP001','Hypertension','Lifestyle changes and meds','2025-09-20','Monitor BP regularly','DOC001'),
('MR002','PAT002','APP002','Migraine','Painkillers','2025-09-21','Avoid stress','DOC003'),
('MR003','PAT003','APP003','Flu','Rest and hydration','2025-09-22','Prescribed Tamiflu','DOC004'),
('MR004','PAT004','APP004','Back strain','Physiotherapy','2025-09-23','Patient cancelled follow-up','DOC005'),
('MR005','PAT005','APP005','Dermatitis','Topical cream','2025-09-24','Allergy suspected','DOC010');
GO

-- ======================
-- PRESCRIPTIONS
-- ======================
INSERT INTO prescriptions (prescriptions_id, patient_id, medical_record_id, prescription_date, notes, doctor_id) VALUES
('PR001','PAT001','MR001','2025-09-20','BP medication prescribed','DOC001'),
('PR002','PAT002','MR002','2025-09-21','Pain relief meds','DOC003'),
('PR003','PAT003','MR003','2025-09-22','Antiviral prescribed','DOC004'),
('PR004','PAT004','MR004','2025-09-23','Physio sessions recommended','DOC005'),
('PR005','PAT005','MR005','2025-09-24','Skin cream prescribed','DOC010');
GO

-- ======================
-- PRESCRIPTION MEDICINES
-- ======================
INSERT INTO prescription_medicines (prescription_medicines_id, prescription_id, medicine_id, dosage, frequency, duration) VALUES
('PM001','PR001','MED005','10mg','Once daily','30 days'),
('PM002','PR002','MED001','500mg','Twice daily','7 days'),
('PM003','PR003','MED003','250mg','Thrice daily','5 days'),
('PM004','PR004','MED002','200mg','Twice daily','10 days'),
('PM005','PR005','MED001','500mg','Once daily','14 days');
GO

-- ======================
-- LAB RESULTS
-- ======================
INSERT INTO lab_results (lab_results_id, patient_id, appointment_id, lab_test_id, result, result_date, notes) VALUES
('LR001','PAT001','APP001','LAB001','Normal','2025-09-20','No issues'),
('LR002','PAT002','APP002','LAB002','Minor sinus issue','2025-09-21','Needs follow-up'),
('LR003','PAT003','APP003','LAB005','Infection detected','2025-09-22','Prescribed antibiotics'),
('LR004','PAT004','APP004','LAB004','No abnormalities','2025-09-23','Routine check'),
('LR005','PAT005','APP005','LAB001','Slight anemia','2025-09-24','Iron supplements recommended');
GO

-- ======================
-- BILLS
-- ======================
INSERT INTO bills (bills_id, total_amount, paid_amount, payment_status, billing_date, payment_method, patient_id, appointment_id) VALUES
('BILL001',200.00,200.00,'Paid','2025-09-20','Credit Card','PAT001','APP001'),
('BILL002',300.00,150.00,'Partially Paid','2025-09-21','Cash','PAT002','APP002'),
('BILL003',150.00,0.00,'Unpaid','2025-09-22','Insurance','PAT003','APP003'),
('BILL004',400.00,400.00,'Paid','2025-09-23','Credit Card','PAT004','APP004'),
('BILL005',250.00,250.00,'Paid','2025-09-24','Cash','PAT005','APP005');
GO

select * from departments;