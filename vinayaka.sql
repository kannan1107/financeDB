CREATE DATABASE IF NOT EXISTS vinayaka;
USE vinayaka;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'staff', 'user') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Customers Table 
-- (Created with final names directly to avoid multiple ALTER commands)
CREATE TABLE IF NOT EXISTS customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50) UNIQUE NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL, -- Changed from father_name based on your RENAME logic
    email VARCHAR(150) UNIQUE NOT NULL,
    gender ENUM('Male','Female','Other'),
    date_of_birth DATE,
    phone VARCHAR(15),
    address VARCHAR(255),
    photo MEDIUMBLOB,
    aadhaar LONGBLOB,
    secure_mobile VARCHAR(15),
    guarantor_name VARCHAR(100),
    guarantor_mobile VARCHAR(15),
    guarantor_address VARCHAR(255),
    guarantor_aadhaar LONGBLOB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- 4. General Loans Table
CREATE TABLE IF NOT EXISTS loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50),
    loan_purpose VARCHAR(100),
    loan_amount DECIMAL(10,2),
    down_amount DECIMAL(10,2),
    interest_rate DECIMAL(5,2),
    tenure_months INT,
    emi_amount DECIMAL(10,2),
    total_amount DECIMAL(10,2),
    repayment_frequency VARCHAR(50),
    loan_status ENUM('Active','Closed','Defaulted') DEFAULT 'Active',
    start_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS microfinance_loans (
    micro_loan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50),
    loan_purpose VARCHAR(100),
    total_amount DECIMAL(10,2),
    down_amount DECIMAL(10,2),
    loan_amount DECIMAL(10,2),
    interest_rate DECIMAL(5,2),
    tenure_months INT,
    emi_amount DECIMAL(10,2),
    repayment_frequency ENUM('Monthly') DEFAULT 'Monthly',
    loan_status ENUM('Active','Closed','Defaulted') DEFAULT 'Active',
    start_date DATE,
    due_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);


CREATE TABLE IF NOT EXISTS vehicle_details (
    vehicle_loan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50),
    vehicle_type ENUM('Two Wheeler','Three Wheeler','Commercial'),
    vehicle_model VARCHAR(100),
    vehicle_version VARCHAR(100),
    vehicle_color VARCHAR(100),
    vehicle_engine VARCHAR(100),
    vehicle_chassis VARCHAR(100),
    vehicle_dealer VARCHAR(100),
    vehicle_reg_no VARCHAR(100),
    start_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);


-- 7. EMI Payments Table
CREATE TABLE IF NOT EXISTS emi_payments (
    emi_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50),
    bill_no VARCHAR(100),
    bill_date DATE,
    due_date DATE,
    current_balance DECIMAL(10,2),
    emi_amount DECIMAL(10,2),
    previous_balance DECIMAL(10,2),
    late_fee DECIMAL(10,2),
    other_charge DECIMAL(10,2),
    payable_amount DECIMAL(10,2),
    bill_amount DECIMAL(10,2),
    start_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id) ON DELETE CASCADE
);


-- 8. Master View (Join Query)
-- This query retrieves a summary of everything related to a customer
SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    c.email,
    c.phone,

    l.loan_id,
    l.loan_amount,
    l.loan_status,

    m.micro_loan_id,
    m.loan_amount AS micro_loan_amount,
    m.loan_status AS micro_loan_status,

    v.vehicle_loan_id,
    v.vehicle_model,
    v.vehicle_type,

    e.emi_id,
    e.emi_amount,
    e.due_date

FROM customers c
LEFT JOIN loans l ON c.customer_id = l.customer_id
LEFT JOIN microfinance_loans m ON c.customer_id = m.customer_id
LEFT JOIN vehicle_details v ON c.customer_id = v.customer_id
LEFT JOIN emi_payments e ON c.customer_id = e.customer_id;


