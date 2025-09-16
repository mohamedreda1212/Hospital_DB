-- إنشاء قاعدة البيانات
CREATE DATABASE Hospital_DB;
GO

-- اختيار قاعدة البيانات
USE Hospital_DB;
GO

-- جدول المرضى
CREATE TABLE patients (
    patient_id VARCHAR(50) PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male','Female')),
    address VARCHAR(255),
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE,
    emergency_contact VARCHAR(100),
    blood_type VARCHAR(5),
    allergies VARCHAR(255)
);
GO

-- جدول الأقسام
CREATE TABLE departments (
    department_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    location VARCHAR(100),
    phone VARCHAR(20)
);
GO

-- جدول الأدوية
CREATE TABLE medicines (
    medicines_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    stock_quantity INT DEFAULT 0,
    unit_price DECIMAL(10,2),
    expiry_date DATE
);
GO

-- جدول التحاليل
CREATE TABLE lab_tests (
    lab_tests_id VARCHAR(50) PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    cost DECIMAL(10,2) CHECK (cost > 50)
);
GO

-- جدول الأطباء
CREATE TABLE doctors (
    doctor_id VARCHAR(50) PRIMARY KEY,
    department_id VARCHAR(50),
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100),
    FOREIGN KEY (department_id) REFERENCES departments(department_id)
);
GO

-- جدول المواعيد
CREATE TABLE appointments (
    appointments_id VARCHAR(50) PRIMARY KEY,
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status VARCHAR(50),
    reason VARCHAR(255),
    notes TEXT,
    department_id VARCHAR(50),
    doctor_id VARCHAR(50),
    patient_id VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);
GO

-- السجلات الطبية
CREATE TABLE medical_records (
    medical_records_id VARCHAR(50) PRIMARY KEY,
    patient_id VARCHAR(50),
    appointment_id VARCHAR(50),
    diagnosis TEXT,
    treatment TEXT,
    record_date DATE,
    notes TEXT,
    doctor_id VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointments_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);
GO

-- الوصفات الطبية
CREATE TABLE prescriptions (
    prescriptions_id VARCHAR(50) PRIMARY KEY,
    patient_id VARCHAR(50),
    medical_record_id VARCHAR(50),
    prescription_date DATE,
    notes TEXT,
    doctor_id VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (medical_record_id) REFERENCES medical_records(medical_records_id),
    FOREIGN KEY (doctor_id) REFERENCES doctors(doctor_id)
);
GO

-- أدوية الوصفات الطبية
CREATE TABLE prescription_medicines (
    prescription_medicines_id VARCHAR(50) PRIMARY KEY,
    prescription_id VARCHAR(50),
    medicine_id VARCHAR(50),
    dosage VARCHAR(100),
    frequency VARCHAR(100),
    duration VARCHAR(100),
    FOREIGN KEY (prescription_id) REFERENCES prescriptions(prescriptions_id),
    FOREIGN KEY (medicine_id) REFERENCES medicines(medicines_id)
);
GO

-- نتائج التحاليل
CREATE TABLE lab_results (
    lab_results_id VARCHAR(50) PRIMARY KEY,
    patient_id VARCHAR(50),
    appointment_id VARCHAR(50),
    lab_test_id VARCHAR(50),
    result TEXT,
    result_date DATE,
    notes TEXT,
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointments_id),
    FOREIGN KEY (lab_test_id) REFERENCES lab_tests(lab_tests_id)
);
GO

-- الفواتير
CREATE TABLE bills (
    bills_id VARCHAR(50) PRIMARY KEY,
    total_amount DECIMAL(10,2) NOT NULL,
    paid_amount DECIMAL(10,2) DEFAULT 0,
    payment_status VARCHAR(50),
    billing_date DATE,
    payment_method VARCHAR(50),
    patient_id VARCHAR(50),
    appointment_id VARCHAR(50),
    FOREIGN KEY (patient_id) REFERENCES patients(patient_id),
    FOREIGN KEY (appointment_id) REFERENCES appointments(appointments_id)
);
GO
