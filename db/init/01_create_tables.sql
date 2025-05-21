-- Address Table
CREATE TABLE address (
    address_id SERIAL PRIMARY KEY,
    street TEXT,
    sub_district TEXT,
    postal_code VARCHAR(10),
    district TEXT
);

-- Medical Center Table
CREATE TABLE medical_center (
    medical_center_id SERIAL PRIMARY KEY,
    name TEXT NOT NULL,
    email TEXT,
    contact_number VARCHAR(20),
    address_id INT REFERENCES address(address_id)
);

-- Doctor Table
CREATE TABLE doctor (
    doctor_id SERIAL PRIMARY KEY,
    first_name TEXT,
    last_name TEXT,
    password_hash TEXT NOT NULL,
    email TEXT UNIQUE,
    specialization TEXT,
    designation TEXT,
    academic_institution TEXT,
    contact_number VARCHAR(20),
    image_url TEXT,
    bio TEXT
);

-- Doctor Degree Table
CREATE TABLE doctor_degree (
    doctor_id INT REFERENCES doctor(doctor_id),
    degree_name TEXT,
    institution TEXT,
    passing_year INT,
    PRIMARY KEY (doctor_id, degree_name)
);

-- Doctor Availability Table
CREATE TABLE doctor_availability (
    slot_id SERIAL PRIMARY KEY,
    doctor_id INT REFERENCES doctor(doctor_id),
    medical_center_id INT REFERENCES medical_center(medical_center_id),
    start_time TIME,
    end_time TIME,
    week_day VARCHAR(10),
    duration INT,
    fee NUMERIC,
    visit_capacity INT,
    chembar TEXT
);

-- Patient Table
CREATE TABLE patient (
    patient_id SERIAL PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL,
    gender VARCHAR(10),
    date_of_birth DATE,
    blood_group VARCHAR(5),
    email TEXT UNIQUE,
    phone_number VARCHAR(20),
    password_hash TEXT NOT NULL,
    address_id INT REFERENCES address(address_id),
    profile_photo_url TEXT
);

-- Chronic Condition Table
CREATE TABLE chronic_condition (
    patient_id INT REFERENCES patient(patient_id),
    condition TEXT,
    PRIMARY KEY (patient_id, condition)
);

-- Allergies Table
CREATE TABLE allergies (
    patient_id INT REFERENCES patient(patient_id),
    allergies TEXT,
    PRIMARY KEY (patient_id, allergies)
);

-- Symptom Table
CREATE TABLE symptom (
    patient_id INT REFERENCES patient(patient_id),
    description TEXT,
    date DATE,
    time TIME,
    PRIMARY KEY (patient_id, date, time)
);

-- Prescription Table
CREATE TABLE prescription (
    prescription_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patient(patient_id),
    doctor_id INT REFERENCES doctor(doctor_id),
    medical_center_id INT REFERENCES medical_center(medical_center_id),
    summary TEXT,
    prescribed_date DATE,
    symptoms TEXT,
    weight NUMERIC,
    blood_pressure VARCHAR(20),
    heart_rate INT,
    notes TEXT,
    next_appointment_date DATE
);

-- Diseases Table
CREATE TABLE diseases (
    disease_id SERIAL PRIMARY KEY,
    disease_name TEXT,
    description TEXT
);

-- Diagnosed Diseases Table
CREATE TABLE diagnosed_diseases (
    prescription_id INT REFERENCES prescription(prescription_id),
    disease_id INT REFERENCES diseases(disease_id),
    PRIMARY KEY (prescription_id, disease_id)
);

-- Medicines Table
CREATE TABLE medicines (
    medicine_id SERIAL PRIMARY KEY,
    medicine_name TEXT,
    description TEXT
);

-- Prescribed Medicine Table
CREATE TABLE prescribed_medicine (
    prescription_id INT REFERENCES prescription(prescription_id),
    medicine_id INT REFERENCES medicines(medicine_id),
    dosage TEXT,
    frequency TEXT,
    duration TEXT,
    instruction TEXT,
    PRIMARY KEY (prescription_id, medicine_id)
);

-- Tests Table
CREATE TABLE tests (
    test_id SERIAL PRIMARY KEY,
    test_name TEXT,
    description TEXT,
    type TEXT
);

-- Test Params Table
CREATE TABLE test_params (
    test_id INT REFERENCES tests(test_id),
    parameter_name TEXT,
    unit TEXT,
    ideal_male_range TEXT,
    ideal_female_range TEXT,
    ideal_children_range TEXT,
    PRIMARY KEY (test_id, parameter_name)
);

-- Prescribed Tests Table
CREATE TABLE prescribed_tests (
    prescription_id INT REFERENCES prescription(prescription_id),
    test_id INT REFERENCES tests(test_id),
    PRIMARY KEY (prescription_id, test_id)
);

-- Performed Tests Table
CREATE TABLE performed_tests (
    performed_test_id SERIAL PRIMARY KEY,
    test_id INT REFERENCES tests(test_id),
    test_date DATE,
    note TEXT,
    suggested_by_doctor_id INT REFERENCES doctor(doctor_id),
    performed_by_doctor_id INT REFERENCES doctor(doctor_id),
    reviewed_by_doctor_id INT REFERENCES doctor(doctor_id),
    medical_center_id INT REFERENCES medical_center(medical_center_id),
    pdf_url TEXT
);

-- Test Result Value Table
CREATE TABLE test_result_value (
    performed_test_id INT REFERENCES performed_tests(performed_test_id),
    parameter_name TEXT,
    result_value TEXT,
    PRIMARY KEY (performed_test_id, parameter_name)
);



-- Appointment Table
CREATE TABLE appointment (
    appointment_id SERIAL PRIMARY KEY,
    doctor_id INT REFERENCES doctor(doctor_id),
    patient_id INT REFERENCES patient(patient_id),
    date DATE,
    time TIME,
    slot_id INT REFERENCES doctor_availability(slot_id),
    serial_number INT
);

-- Doctor Review Table
CREATE TABLE doctor_review (
    review_id SERIAL PRIMARY KEY,
    doctor_id INT REFERENCES doctor(doctor_id),
    patient_id INT REFERENCES patient(patient_id),
    rating INT,
    description TEXT,
    date DATE
);
