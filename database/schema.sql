CREATE DATABASE IF NOT EXISTS smart_ambulance
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE smart_ambulance;

CREATE TABLE IF NOT EXISTS ambulances (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ambulance_number VARCHAR(30) NOT NULL UNIQUE,
  driver_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20),
  vehicle_type VARCHAR(50) DEFAULT 'Basic Life Support',
  current_location VARCHAR(180) DEFAULT 'Control Centre',
  status ENUM('Available','Assigned','On Emergency','Maintenance') NOT NULL DEFAULT 'Available',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS emergency_requests (
  id INT AUTO_INCREMENT PRIMARY KEY,
  request_code VARCHAR(32) NOT NULL UNIQUE,
  patient_name VARCHAR(100) NOT NULL,
  phone VARCHAR(20) NOT NULL,
  location VARCHAR(255) NOT NULL,
  location_lat DECIMAL(10,7) NULL,
  location_lon DECIMAL(10,7) NULL,
  hospital_name VARCHAR(255) NULL,
  hospital_address VARCHAR(255) NULL,
  hospital_lat DECIMAL(10,7) NULL,
  hospital_lon DECIMAL(10,7) NULL,
  emergency_type VARCHAR(80) NOT NULL,
  details TEXT,
  priority ENUM('Low','Medium','High','Critical') DEFAULT 'High',
  status ENUM('Pending','Assigned','Accepted','En Route','Arrived','Completed','Cancelled') NOT NULL DEFAULT 'Pending',
  ambulance_id INT NULL,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  assigned_at DATETIME NULL,
  CONSTRAINT fk_request_ambulance FOREIGN KEY (ambulance_id) REFERENCES ambulances(id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS users (
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(80) NOT NULL UNIQUE,
  password_hash VARCHAR(255) NOT NULL,
  role ENUM('admin','driver') NOT NULL,
  ambulance_id INT NULL,
  is_active TINYINT(1) NOT NULL DEFAULT 1,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_user_ambulance FOREIGN KEY (ambulance_id) REFERENCES ambulances(id) ON DELETE SET NULL
);

INSERT IGNORE INTO ambulances (ambulance_number, driver_name, phone, vehicle_type, current_location, status) VALUES
('AP 16 AB 1234', 'Ravi Kumar', '9000000001', 'Advanced Life Support', 'Control Centre', 'Available'),
('AP 16 CD 5678', 'Suresh Reddy', '9000000002', 'Basic Life Support', 'North Zone', 'Available'),
('AP 16 EF 9012', 'Kiran Kumar', '9000000003', 'Advanced Life Support', 'South Zone', 'On Emergency'),
('AP 16 GH 3456', 'Arun Teja', '9000000004', 'Basic Life Support', 'East Zone', 'Available'),
('AP 16 JK 7890', 'Manoj Kumar', '9000000005', 'Basic Life Support', 'West Zone', 'Maintenance');

-- Staff account setup:
-- Create password hashes with: python create_demo_users.py
-- Then import/run that script after importing this schema.
