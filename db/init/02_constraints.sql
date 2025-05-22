-- Add DEFAULT values where appropriate
ALTER TABLE prescription
ALTER COLUMN prescribed_date SET DEFAULT CURRENT_DATE;

ALTER TABLE performed_tests
ALTER COLUMN test_date SET DEFAULT CURRENT_DATE;

ALTER TABLE doctor_review
ALTER COLUMN date SET DEFAULT CURRENT_DATE;

ALTER TABLE symptom
ALTER COLUMN date SET DEFAULT CURRENT_DATE;
ALTER COLUMN time SET DEFAULT CURRENT_TIME;



-- Add CHECK constraints for valid values
ALTER TABLE patient
ADD CONSTRAINT chk_patient_gender CHECK (gender IN ('Male', 'Female', 'Other')),
ADD CONSTRAINT chk_patient_blood_group CHECK (blood_group IN ('A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-')),
ADD CONSTRAINT chk_patient_phone_number CHECK (phone_number ~ '^[0-9]{10,15}$'),
ADD CONSTRAINT chk_patient_email CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');

ALTER TABLE doctor
ADD CONSTRAINT chk_doctor_gender CHECK (gender IN ('Male', 'Female', 'Other')),
ADD CONSTRAINT chk_doctor_phone_number CHECK (phone_number ~ '^[0-9]{10,15}$'),
ADD CONSTRAINT chk_doctor_email CHECK (email ~* '^[A-Za-z0-9._%-]+@[A-Za-z0-9.-]+[.][A-Za-z]+$');

ALTER TABLE prescription
ADD CONSTRAINT chk_prescription_weight CHECK (weight > 0),
ADD CONSTRAINT chk_prescription_heart_rate CHECK (heart_rate > 0 AND heart_rate < 250);

ALTER TABLE doctor_availability
ADD CONSTRAINT chk_availability_fee CHECK (fee >= 0),
ADD CONSTRAINT chk_availability_duration CHECK (duration > 0),
ADD CONSTRAINT chk_availability_visit_capacity CHECK (visit_capacity > 0),
ADD CONSTRAINT chk_availability_week_day CHECK (week_day IN ('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'));


ALTER TABLE tests
ADD CONSTRAINT chk_test_type CHECK (type IN ('Pathology', 'Imaging')),

ALTER TABLE doctor_review
ADD CONSTRAINT chk_review_rating CHECK (rating BETWEEN 1 AND 5);



-- Ensure dates make sense
ALTER TABLE patient
ADD CONSTRAINT chk_patient_dob CHECK (date_of_birth <= CURRENT_DATE);

ALTER TABLE prescription
ADD CONSTRAINT chk_prescription_dates CHECK (prescribed_date <= CURRENT_DATE AND 
                                           (next_appointment_date IS NULL OR next_appointment_date >= prescribed_date));

ALTER TABLE appointment
ADD CONSTRAINT chk_appointment_date CHECK (date >= CURRENT_DATE);



-- Add UNIQUE constraints where appropriate
ADD CONSTRAINT unq_medical_center_email UNIQUE (email),
ADD CONSTRAINT unq_medical_center_contact_number UNIQUE (contact_number);

ADD CONSTRAINT unq_doctor_phone_number UNIQUE (phone_number);


ADD CONSTRAINT unq_appointment_slot_serial UNIQUE (slot_id, serial_number);