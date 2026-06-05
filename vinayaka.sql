SHOW DATABASES;
USE vinayaka;

-- user create 
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

ALTER TABLE users 
ADD role ENUM('admin', 'staff', 'user') DEFAULT 'user';

DELETE FROM users 
WHERE id = 1;

select * from users;

-- CUSTOMERS TABLE
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50) UNIQUE,
    name VARCHAR(100) NOT NULL,
    father_name VARCHAR(255) NOT NULL,
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

ALTER TABLE customers 
RENAME COLUMN name TO first_name;

ALTER TABLE customers 
RENAME COLUMN father_name TO last_name;

ALTER TABLE customers 
RENAME COLUMN secure_mobile TO secureMobile;

ALTER TABLE customers 
RENAME COLUMN guarantor_name TO GuarantorName;

ALTER TABLE customers 
RENAME COLUMN guarantor_mobile TO GuarantorMobile;

ALTER TABLE customers 
RENAME COLUMN guarantor_address TO GuarantorAddress;

ALTER TABLE customers 
RENAME COLUMN guarantor_aadhaar TO GuarantorAathaar;






SELECT * FROM customers;

DROP TABLE  customers;


-- LOAN TABLE
CREATE TABLE loans (
    loan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50),
    loan_purpose VARCHAR(100),
    loan_amount DECIMAL(10,2),
    down_amount DECIMAL(10,2),
    interest_rate DECIMAL(5,2),
    tenure_months INT,
    emi_amount DECIMAL(10,2),
    loan_status ENUM('Active','Closed','Defaulted'),
    start_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

ALTER TABLE loans ADD total_amount DECIMAL(10,2);

ALTER TABLE loans ADD repayment_frequency VARCHAR(50);

ALTER TABLE loans 
add column total_amount DECIMAL(10,2) ;

ALTER TABLE loans 
add column repayment_frequency VARCHAR(50) ;

SELECT * FROM  loans;


-- MICROFINANCE LOANS
CREATE TABLE microfinance_loans (
    micro_loan_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50),
    loan_purpose VARCHAR(100),
    total_amount DECIMAL(10,2),
    down_amount DECIMAL(10,2),
    loan_amount DECIMAL(10,2),
    interest_rate DECIMAL(5,2),
    tenure_months INT,
    emi_amount DECIMAL(10,2),
    repayment_frequency ENUM('Monthly'),
    loan_status ENUM('Active','Closed','Defaulted'),
    start_date DATE,
    due_date DATE,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


-- VEHICLE LOANS
CREATE TABLE vehicle_loans (
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
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

RENAME TABLE vehicle_loan_details TO vehicle_details;

ALTER TABLE customers 
RENAME COLUMN guarantor_aadhaar TO total_amount;


-- EMI PAYMENTS
CREATE TABLE emi_payments (
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
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);


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

LEFT JOIN loans l 
    ON c.customer_id = l.customer_id

LEFT JOIN microfinance_loans m 
    ON c.customer_id = m.customer_id

LEFT JOIN vehicle_details v 
    ON c.customer_id = v.customer_id

LEFT JOIN emi_payments e 
    ON c.customer_id = e.customer_id;
