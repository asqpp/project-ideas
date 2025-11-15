-- ============================================================================
-- Insurance Power Buyer Software - Database Schema
-- MySQL/MariaDB Schema
-- ============================================================================

-- Set character encoding
SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

-- Create database (if not exists)
CREATE DATABASE IF NOT EXISTS insurance_power_buyer
CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE insurance_power_buyer;

-- ============================================================================
-- BRANCH & ORGANIZATION TABLES
-- ============================================================================

CREATE TABLE branches (
    id INT AUTO_INCREMENT PRIMARY KEY,
    branch_code VARCHAR(20) UNIQUE NOT NULL,
    branch_name VARCHAR(100) NOT NULL,
    address TEXT,
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    pincode VARCHAR(10),
    phone VARCHAR(15),
    email VARCHAR(100),
    manager_id INT,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_branch_code (branch_code),
    INDEX idx_branch_city (city, state)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- USER & ACCESS CONTROL TABLES
-- ============================================================================

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    phone VARCHAR(15),
    role VARCHAR(50) NOT NULL,
    department VARCHAR(50),
    is_active BOOLEAN DEFAULT TRUE,
    last_login DATETIME,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    INDEX idx_username (username),
    INDEX idx_email (email),
    INDEX idx_role (role)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- CUSTOMER/BUYER MANAGEMENT TABLES
-- ============================================================================

CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id VARCHAR(50) UNIQUE NOT NULL,

    -- Personal Information
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    date_of_birth DATE NOT NULL,
    age INT NOT NULL,
    gender ENUM('Male', 'Female', 'Other'),
    marital_status ENUM('Single', 'Married', 'Divorced', 'Widowed'),

    -- Contact Information
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    alternate_phone VARCHAR(15),

    -- Identification
    pan_number VARCHAR(20) UNIQUE,
    aadhaar_number VARCHAR(20),
    passport_number VARCHAR(20),

    -- Customer Classification
    customer_type ENUM('Individual', 'Corporate') DEFAULT 'Individual',
    status ENUM('Active', 'Inactive', 'Blocked') DEFAULT 'Active',
    kyc_status ENUM('Pending', 'Verified', 'Rejected') DEFAULT 'Pending',

    -- Business Information (for Corporate)
    company_name VARCHAR(200),
    gst_number VARCHAR(50),

    -- Financial Information
    annual_income DECIMAL(15, 2),
    occupation VARCHAR(100),

    -- Risk Profiling
    smoking_status BOOLEAN DEFAULT FALSE,
    alcohol_consumption VARCHAR(20),
    risk_category ENUM('Low', 'Medium', 'High'),

    -- Agent/Branch Assignment
    branch_id INT,
    agent_id INT,

    -- Loyalty & Statistics
    loyalty_points INT DEFAULT 0,
    customer_lifetime_value DECIMAL(15, 2) DEFAULT 0,
    active_policies_count INT DEFAULT 0,

    -- Audit Fields
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,

    INDEX idx_customer_id (customer_id),
    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_pan (pan_number),
    INDEX idx_status (status, is_active),
    INDEX idx_kyc_status (kyc_status),
    INDEX idx_customer_search (full_name, email, phone),
    INDEX idx_branch_agent (branch_id, agent_id),
    FULLTEXT idx_fulltext_name (full_name),

    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE customer_addresses (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    address_type ENUM('Residential', 'Office', 'Permanent', 'Mailing'),
    address_line1 VARCHAR(200) NOT NULL,
    address_line2 VARCHAR(200),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    country VARCHAR(100) DEFAULT 'India',
    pincode VARCHAR(10) NOT NULL,
    is_primary BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_customer (customer_id),
    INDEX idx_city_state (city, state),
    INDEX idx_pincode (pincode),

    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE customer_kyc_documents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    document_type VARCHAR(50) NOT NULL,
    document_number VARCHAR(100),
    document_path VARCHAR(500) NOT NULL,
    document_name VARCHAR(200) NOT NULL,
    verification_status ENUM('Pending', 'Verified', 'Rejected') DEFAULT 'Pending',
    verified_by INT,
    verified_at DATETIME,
    remarks TEXT,
    is_active BOOLEAN DEFAULT TRUE,
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_customer (customer_id),
    INDEX idx_verification_status (verification_status),

    FOREIGN KEY (customer_id) REFERENCES customers(id) ON DELETE CASCADE,
    FOREIGN KEY (verified_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- AGENT/BROKER MANAGEMENT TABLES
-- ============================================================================

CREATE TABLE agents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    agent_code VARCHAR(50) UNIQUE NOT NULL,

    -- Personal Information
    first_name VARCHAR(50) NOT NULL,
    middle_name VARCHAR(50),
    last_name VARCHAR(50) NOT NULL,
    full_name VARCHAR(150) NOT NULL,
    date_of_birth DATE NOT NULL,
    age INT,
    gender ENUM('Male', 'Female', 'Other'),

    -- Contact Information
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    address TEXT,
    city VARCHAR(100),
    state VARCHAR(100),
    pincode VARCHAR(10),

    -- License Information
    license_number VARCHAR(50) UNIQUE NOT NULL,
    license_type VARCHAR(50),
    license_issue_date DATE,
    license_valid_till DATE NOT NULL,

    -- Agent Classification
    agent_type VARCHAR(50) NOT NULL,
    status ENUM('Active', 'Inactive', 'Suspended', 'Terminated') DEFAULT 'Active',

    -- Assignment
    branch_id INT NOT NULL,
    reporting_manager_id INT,
    territory VARCHAR(100),

    -- Commission Structure
    commission_structure_code VARCHAR(20),
    first_year_commission_percentage DECIMAL(5, 2),
    renewal_commission_percentage DECIMAL(5, 2),

    -- Financial Information
    pan_number VARCHAR(20) UNIQUE NOT NULL,
    bank_name VARCHAR(100),
    bank_account_number VARCHAR(50),
    bank_ifsc_code VARCHAR(20),

    -- Performance Metrics
    total_policies_sold INT DEFAULT 0,
    total_premium_collected DECIMAL(15, 2) DEFAULT 0,
    total_commission_earned DECIMAL(15, 2) DEFAULT 0,
    persistency_ratio DECIMAL(5, 2) DEFAULT 0,

    -- Dates
    joining_date DATE NOT NULL,
    termination_date DATE,

    -- Flags
    is_active BOOLEAN DEFAULT TRUE,

    -- Audit Fields
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,

    INDEX idx_agent_code (agent_code),
    INDEX idx_email (email),
    INDEX idx_phone (phone),
    INDEX idx_license (license_number),
    INDEX idx_status (status, is_active),
    INDEX idx_branch (branch_id),
    INDEX idx_agent_search (full_name, email, agent_code),
    FULLTEXT idx_fulltext_name (full_name),

    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (reporting_manager_id) REFERENCES agents(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Update customers table to add foreign key for agent
ALTER TABLE customers ADD FOREIGN KEY (agent_id) REFERENCES agents(id);

CREATE TABLE agent_targets (
    id INT AUTO_INCREMENT PRIMARY KEY,
    agent_id INT NOT NULL,
    target_period VARCHAR(20),
    target_year INT NOT NULL,
    target_month INT,
    target_quarter INT,
    premium_target DECIMAL(15, 2) NOT NULL,
    policies_target INT,
    premium_achieved DECIMAL(15, 2) DEFAULT 0,
    policies_achieved INT DEFAULT 0,
    achievement_percentage DECIMAL(5, 2) DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_agent (agent_id),
    INDEX idx_period (target_year, target_month),

    FOREIGN KEY (agent_id) REFERENCES agents(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- POLICY MANAGEMENT TABLES
-- ============================================================================

CREATE TABLE policy_types (
    id INT AUTO_INCREMENT PRIMARY KEY,
    policy_type_code VARCHAR(20) UNIQUE NOT NULL,
    policy_type_name VARCHAR(100) NOT NULL,
    description TEXT,
    min_sum_assured DECIMAL(15, 2),
    max_sum_assured DECIMAL(15, 2),
    min_age INT,
    max_age INT,
    min_term INT,
    max_term INT,
    base_premium_rate DECIMAL(10, 4),
    has_surrender_value BOOLEAN DEFAULT TRUE,
    surrender_value_factor DECIMAL(5, 4),
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_policy_type_code (policy_type_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE policies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    policy_number VARCHAR(50) UNIQUE NOT NULL,

    -- Customer & Policy Type
    customer_id INT NOT NULL,
    policy_type_id INT NOT NULL,

    -- Policy Details
    sum_assured DECIMAL(15, 2) NOT NULL,
    policy_term INT NOT NULL,
    premium_payment_term INT NOT NULL,

    -- Premium Information
    annual_premium DECIMAL(12, 2) NOT NULL,
    payment_frequency ENUM('Monthly', 'Quarterly', 'Semi-Annual', 'Annual') DEFAULT 'Annual',
    installment_premium DECIMAL(12, 2) NOT NULL,

    -- Dates
    policy_start_date DATE NOT NULL,
    policy_end_date DATE NOT NULL,
    maturity_date DATE NOT NULL,
    next_premium_due_date DATE,

    -- Status
    status ENUM('Active', 'Lapsed', 'Paid-up', 'Matured', 'Surrendered') DEFAULT 'Active',
    current_policy_year INT DEFAULT 1,

    -- Values
    current_surrender_value DECIMAL(15, 2) DEFAULT 0,
    maturity_value DECIMAL(15, 2),
    bonus_accumulated DECIMAL(15, 2) DEFAULT 0,
    outstanding_loan DECIMAL(15, 2) DEFAULT 0,

    -- Assignment
    branch_id INT,
    agent_id INT,

    -- Flags
    claim_pending BOOLEAN DEFAULT FALSE,
    is_active BOOLEAN DEFAULT TRUE,

    -- Audit Fields
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,

    INDEX idx_policy_number (policy_number),
    INDEX idx_customer (customer_id),
    INDEX idx_agent (agent_id),
    INDEX idx_status (status, is_active),
    INDEX idx_due_date (next_premium_due_date, status),
    INDEX idx_policy_search (policy_number, customer_id, status),

    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (policy_type_id) REFERENCES policy_types(id),
    FOREIGN KEY (branch_id) REFERENCES branches(id),
    FOREIGN KEY (agent_id) REFERENCES agents(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE policy_nominees (
    id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    nominee_name VARCHAR(150) NOT NULL,
    relationship_with_insured VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    age INT,
    share_percentage DECIMAL(5, 2) NOT NULL,

    -- Appointee (if nominee is minor)
    appointee_name VARCHAR(150),
    appointee_relationship VARCHAR(50),

    contact_phone VARCHAR(15),
    contact_email VARCHAR(100),
    address TEXT,

    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_policy (policy_id),

    FOREIGN KEY (policy_id) REFERENCES policies(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE riders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    rider_code VARCHAR(20) UNIQUE NOT NULL,
    rider_name VARCHAR(100) NOT NULL,
    description TEXT,
    premium_rate DECIMAL(10, 4),
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_rider_code (rider_code)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE policy_riders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    rider_id INT NOT NULL,
    sum_assured DECIMAL(15, 2) NOT NULL,
    annual_premium DECIMAL(12, 2) NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_policy (policy_id),
    INDEX idx_rider (rider_id),

    FOREIGN KEY (policy_id) REFERENCES policies(id) ON DELETE CASCADE,
    FOREIGN KEY (rider_id) REFERENCES riders(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- CLAIMS MANAGEMENT TABLES
-- ============================================================================

CREATE TABLE claims (
    id INT AUTO_INCREMENT PRIMARY KEY,
    claim_number VARCHAR(50) UNIQUE NOT NULL,

    -- Policy & Customer
    policy_id INT NOT NULL,
    customer_id INT NOT NULL,

    -- Claim Details
    claim_type VARCHAR(50) NOT NULL,
    date_of_event DATE NOT NULL,
    intimation_date DATE NOT NULL,
    registration_date DATE DEFAULT (CURRENT_DATE),

    -- Claimant/Beneficiary
    claimant_name VARCHAR(150) NOT NULL,
    claimant_relationship VARCHAR(50),
    claimant_phone VARCHAR(15),
    claimant_email VARCHAR(100),

    -- Claim Amount
    claim_amount DECIMAL(15, 2) NOT NULL,
    approved_amount DECIMAL(15, 2) DEFAULT 0,
    paid_amount DECIMAL(15, 2) DEFAULT 0,

    -- Status & Priority
    status ENUM('Registered', 'Under Review', 'Investigation', 'Approved', 'Rejected', 'Paid') DEFAULT 'Registered',
    priority ENUM('Low', 'Medium', 'High') DEFAULT 'Medium',

    -- Assignment
    assigned_to INT,
    investigator_id INT,

    -- Investigation
    requires_investigation BOOLEAN DEFAULT FALSE,
    investigation_status VARCHAR(50),
    investigation_remarks TEXT,

    -- Approval
    approved_by INT,
    approved_at DATETIME,
    rejection_reason TEXT,

    -- Settlement
    settlement_date DATE,
    payment_method ENUM('Cash', 'Cheque', 'Card', 'Net Banking', 'UPI', 'Auto-Debit'),
    transaction_reference VARCHAR(100),

    -- Flags
    is_active BOOLEAN DEFAULT TRUE,

    -- Audit Fields
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,
    updated_by INT,

    INDEX idx_claim_number (claim_number),
    INDEX idx_policy (policy_id),
    INDEX idx_customer (customer_id),
    INDEX idx_status (status, is_active),
    INDEX idx_claim_type (claim_type),
    INDEX idx_dates (registration_date, status),

    FOREIGN KEY (policy_id) REFERENCES policies(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (assigned_to) REFERENCES users(id),
    FOREIGN KEY (investigator_id) REFERENCES users(id),
    FOREIGN KEY (approved_by) REFERENCES users(id),
    FOREIGN KEY (created_by) REFERENCES users(id),
    FOREIGN KEY (updated_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE claim_documents (
    id INT AUTO_INCREMENT PRIMARY KEY,
    claim_id INT NOT NULL,
    document_type VARCHAR(50) NOT NULL,
    document_name VARCHAR(200) NOT NULL,
    document_path VARCHAR(500) NOT NULL,
    verification_status ENUM('Pending', 'Verified', 'Rejected') DEFAULT 'Pending',
    verified_by INT,
    verified_at DATETIME,
    remarks TEXT,
    uploaded_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_claim (claim_id),
    INDEX idx_verification (verification_status),

    FOREIGN KEY (claim_id) REFERENCES claims(id) ON DELETE CASCADE,
    FOREIGN KEY (verified_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- PAYMENT & BILLING TABLES
-- ============================================================================

CREATE TABLE payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    payment_id VARCHAR(50) UNIQUE NOT NULL,
    transaction_id VARCHAR(100) UNIQUE,

    -- Policy & Customer
    policy_id INT NOT NULL,
    customer_id INT NOT NULL,

    -- Payment Details
    payment_type VARCHAR(50) NOT NULL,
    payment_method ENUM('Cash', 'Cheque', 'Card', 'Net Banking', 'UPI', 'Auto-Debit') NOT NULL,

    -- Amount Breakdown
    premium_amount DECIMAL(12, 2) NOT NULL,
    gst_amount DECIMAL(12, 2) DEFAULT 0,
    late_fee DECIMAL(12, 2) DEFAULT 0,
    discount_amount DECIMAL(12, 2) DEFAULT 0,
    total_amount DECIMAL(12, 2) NOT NULL,

    -- Payment Date
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    due_date DATE,

    -- Status
    status ENUM('Pending', 'Success', 'Failed', 'Refunded') DEFAULT 'Pending',

    -- Payment Method Specific Fields
    cheque_number VARCHAR(50),
    cheque_date DATE,
    bank_name VARCHAR(100),
    cheque_status VARCHAR(20),
    card_last_4_digits VARCHAR(4),
    upi_id VARCHAR(100),

    -- Gateway Details
    gateway_name VARCHAR(50),
    gateway_transaction_id VARCHAR(100),
    gateway_response TEXT,

    -- Receipt
    receipt_number VARCHAR(50) UNIQUE,
    receipt_url VARCHAR(500),

    -- Reconciliation
    is_reconciled BOOLEAN DEFAULT FALSE,
    reconciled_at DATETIME,

    -- Audit Fields
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    created_by INT,

    INDEX idx_payment_id (payment_id),
    INDEX idx_transaction_id (transaction_id),
    INDEX idx_policy (policy_id),
    INDEX idx_customer (customer_id),
    INDEX idx_receipt (receipt_number),
    INDEX idx_status (status, payment_date),
    INDEX idx_payment_search (payment_id, transaction_id, policy_id),

    FOREIGN KEY (policy_id) REFERENCES policies(id),
    FOREIGN KEY (customer_id) REFERENCES customers(id),
    FOREIGN KEY (created_by) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE payment_schedules (
    id INT AUTO_INCREMENT PRIMARY KEY,
    policy_id INT NOT NULL,
    installment_number INT NOT NULL,
    due_date DATE NOT NULL,
    amount DECIMAL(12, 2) NOT NULL,
    status ENUM('Upcoming', 'Due', 'Paid', 'Overdue') DEFAULT 'Upcoming',
    payment_id INT,
    paid_date DATE,
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_policy (policy_id),
    INDEX idx_due_date (due_date, status),
    INDEX idx_payment (payment_id),

    FOREIGN KEY (policy_id) REFERENCES policies(id) ON DELETE CASCADE,
    FOREIGN KEY (payment_id) REFERENCES payments(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- COMMISSION MANAGEMENT TABLES
-- ============================================================================

CREATE TABLE commissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    commission_id VARCHAR(50) UNIQUE NOT NULL,
    agent_id INT NOT NULL,
    policy_id INT NOT NULL,
    payment_id INT,
    commission_type ENUM('First Year', 'Renewal', 'Override') NOT NULL,
    premium_amount DECIMAL(12, 2) NOT NULL,
    commission_rate DECIMAL(5, 2) NOT NULL,
    commission_amount DECIMAL(12, 2) NOT NULL,
    tds_amount DECIMAL(12, 2) DEFAULT 0,
    net_commission DECIMAL(12, 2) NOT NULL,
    status ENUM('Pending', 'Approved', 'Paid') DEFAULT 'Pending',
    payment_date DATE,
    payment_reference VARCHAR(100),
    is_active BOOLEAN DEFAULT TRUE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_commission_id (commission_id),
    INDEX idx_agent (agent_id),
    INDEX idx_policy (policy_id),
    INDEX idx_payment (payment_id),
    INDEX idx_status (status),

    FOREIGN KEY (agent_id) REFERENCES agents(id),
    FOREIGN KEY (policy_id) REFERENCES policies(id),
    FOREIGN KEY (payment_id) REFERENCES payments(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- AUDIT TRAIL TABLE
-- ============================================================================

CREATE TABLE audit_logs (
    id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(100) NOT NULL,
    record_id INT NOT NULL,
    action ENUM('CREATE', 'UPDATE', 'DELETE', 'SOFT_DELETE') NOT NULL,
    old_values TEXT,
    new_values TEXT,
    user_id INT,
    ip_address VARCHAR(50),
    user_agent VARCHAR(200),
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,

    INDEX idx_table_record (table_name, record_id),
    INDEX idx_action (action),
    INDEX idx_created_at (created_at),
    INDEX idx_user (user_id),

    FOREIGN KEY (user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================================================
-- INSERT SAMPLE DATA
-- ============================================================================

-- Insert default branch
INSERT INTO branches (branch_code, branch_name, city, state, phone, email)
VALUES ('HQ', 'Head Office', 'Mumbai', 'Maharashtra', '022-12345678', 'ho@insurance.com');

-- Insert default admin user
INSERT INTO users (username, email, password_hash, full_name, role, is_active)
VALUES ('admin', 'admin@insurance.com', '$2b$12$LQv3c1yqBWVHxkd0LHAkCOYz6TtxMQJqhN8/LewY5Y5myZK6IgCia',
        'System Administrator', 'Admin', TRUE);

-- Insert sample policy types
INSERT INTO policy_types (policy_type_code, policy_type_name, description,
                         min_sum_assured, max_sum_assured, min_age, max_age,
                         min_term, max_term, base_premium_rate, has_surrender_value, surrender_value_factor)
VALUES
('TERM', 'Term Life Insurance', 'Pure protection plan with no maturity benefit',
 100000, 50000000, 18, 65, 5, 40, 0.0015, FALSE, 0),
('WHOLE', 'Whole Life Insurance', 'Life coverage with savings component',
 200000, 25000000, 18, 60, 10, 40, 0.0025, TRUE, 0.30),
('ENDOW', 'Endowment Plan', 'Life cover with guaranteed maturity benefit',
 100000, 10000000, 18, 55, 10, 30, 0.0035, TRUE, 0.35),
('ULIP', 'Unit Linked Insurance Plan', 'Market-linked insurance and investment',
 250000, 50000000, 18, 60, 5, 30, 0.0020, TRUE, 0.20);

-- Insert sample riders
INSERT INTO riders (rider_code, rider_name, description, premium_rate)
VALUES
('ACCDEATH', 'Accidental Death Benefit', 'Additional payout on accidental death', 0.0005),
('CRITILL', 'Critical Illness Rider', 'Lump sum on diagnosis of critical illness', 0.0010),
('DISAB', 'Disability Rider', 'Premium waiver on permanent disability', 0.0008),
('HOSPITAL', 'Hospital Cash Rider', 'Daily cash benefit during hospitalization', 0.0006);

-- ============================================================================
-- VIEWS FOR REPORTING
-- ============================================================================

-- Active Policies View
CREATE OR REPLACE VIEW vw_active_policies AS
SELECT
    p.policy_number,
    p.policy_start_date,
    p.maturity_date,
    p.sum_assured,
    p.annual_premium,
    p.status,
    c.customer_id,
    c.full_name AS customer_name,
    c.email AS customer_email,
    c.phone AS customer_phone,
    a.agent_code,
    a.full_name AS agent_name,
    pt.policy_type_name,
    b.branch_name
FROM policies p
JOIN customers c ON p.customer_id = c.id
LEFT JOIN agents a ON p.agent_id = a.id
JOIN policy_types pt ON p.policy_type_id = pt.id
LEFT JOIN branches b ON p.branch_id = b.id
WHERE p.is_active = TRUE AND p.status = 'Active';

-- Commission Summary View
CREATE OR REPLACE VIEW vw_commission_summary AS
SELECT
    a.agent_code,
    a.full_name AS agent_name,
    a.branch_id,
    b.branch_name,
    COUNT(DISTINCT c.policy_id) AS total_policies,
    SUM(CASE WHEN c.commission_type = 'First Year' THEN c.commission_amount ELSE 0 END) AS first_year_commission,
    SUM(CASE WHEN c.commission_type = 'Renewal' THEN c.commission_amount ELSE 0 END) AS renewal_commission,
    SUM(c.commission_amount) AS total_commission,
    SUM(c.tds_amount) AS total_tds,
    SUM(c.net_commission) AS net_commission,
    SUM(CASE WHEN c.status = 'Paid' THEN c.net_commission ELSE 0 END) AS paid_commission,
    SUM(CASE WHEN c.status != 'Paid' THEN c.net_commission ELSE 0 END) AS pending_commission
FROM agents a
LEFT JOIN commissions c ON a.id = c.agent_id
LEFT JOIN branches b ON a.branch_id = b.id
WHERE a.is_active = TRUE
GROUP BY a.id, a.agent_code, a.full_name, a.branch_id, b.branch_name;

-- Claims Pending View
CREATE OR REPLACE VIEW vw_pending_claims AS
SELECT
    cl.claim_number,
    cl.claim_type,
    cl.registration_date,
    cl.claim_amount,
    cl.status,
    cl.priority,
    p.policy_number,
    c.customer_id,
    c.full_name AS customer_name,
    DATEDIFF(CURRENT_DATE, cl.registration_date) AS days_pending
FROM claims cl
JOIN policies p ON cl.policy_id = p.id
JOIN customers c ON cl.customer_id = c.id
WHERE cl.status NOT IN ('Paid', 'Rejected')
  AND cl.is_active = TRUE
ORDER BY cl.priority DESC, cl.registration_date ASC;

-- ============================================================================
-- STORED PROCEDURES
-- ============================================================================

DELIMITER //

-- Procedure to calculate surrender value
CREATE PROCEDURE sp_calculate_surrender_value(IN p_policy_id INT, OUT surrender_value DECIMAL(15,2))
BEGIN
    DECLARE v_premium DECIMAL(12,2);
    DECLARE v_years INT;
    DECLARE v_factor DECIMAL(5,4);
    DECLARE v_loan DECIMAL(15,2);

    SELECT
        p.annual_premium,
        p.current_policy_year,
        pt.surrender_value_factor,
        p.outstanding_loan
    INTO v_premium, v_years, v_factor, v_loan
    FROM policies p
    JOIN policy_types pt ON p.policy_type_id = pt.id
    WHERE p.id = p_policy_id;

    SET surrender_value = (v_premium * v_years * v_factor) - v_loan;

    IF surrender_value < 0 THEN
        SET surrender_value = 0;
    END IF;
END //

-- Procedure to calculate agent commission
CREATE PROCEDURE sp_calculate_commission(
    IN p_agent_id INT,
    IN p_policy_id INT,
    IN p_payment_id INT,
    IN p_premium_amount DECIMAL(12,2),
    IN p_is_first_year BOOLEAN
)
BEGIN
    DECLARE v_commission_rate DECIMAL(5,2);
    DECLARE v_commission_amount DECIMAL(12,2);
    DECLARE v_tds_amount DECIMAL(12,2);
    DECLARE v_net_commission DECIMAL(12,2);
    DECLARE v_commission_id VARCHAR(50);
    DECLARE v_commission_type VARCHAR(20);

    -- Get commission rate
    IF p_is_first_year THEN
        SELECT first_year_commission_percentage INTO v_commission_rate
        FROM agents WHERE id = p_agent_id;
        SET v_commission_type = 'First Year';
    ELSE
        SELECT renewal_commission_percentage INTO v_commission_rate
        FROM agents WHERE id = p_agent_id;
        SET v_commission_type = 'Renewal';
    END IF;

    -- Calculate commission
    SET v_commission_amount = p_premium_amount * (v_commission_rate / 100);
    SET v_tds_amount = v_commission_amount * 0.10; -- 10% TDS
    SET v_net_commission = v_commission_amount - v_tds_amount;

    -- Generate commission ID
    SET v_commission_id = CONCAT('COM-', YEAR(CURRENT_DATE), '-', LPAD(
        (SELECT COALESCE(MAX(id), 0) + 1 FROM commissions), 8, '0'
    ));

    -- Insert commission record
    INSERT INTO commissions (
        commission_id, agent_id, policy_id, payment_id, commission_type,
        premium_amount, commission_rate, commission_amount,
        tds_amount, net_commission, status
    ) VALUES (
        v_commission_id, p_agent_id, p_policy_id, p_payment_id, v_commission_type,
        p_premium_amount, v_commission_rate, v_commission_amount,
        v_tds_amount, v_net_commission, 'Pending'
    );
END //

DELIMITER ;

-- ============================================================================
-- TRIGGERS
-- ============================================================================

DELIMITER //

-- Trigger to update customer's active policy count on policy creation
CREATE TRIGGER trg_after_policy_insert
AFTER INSERT ON policies
FOR EACH ROW
BEGIN
    IF NEW.status = 'Active' THEN
        UPDATE customers
        SET active_policies_count = active_policies_count + 1
        WHERE id = NEW.customer_id;
    END IF;
END //

-- Trigger to update customer's active policy count on policy status change
CREATE TRIGGER trg_after_policy_update
AFTER UPDATE ON policies
FOR EACH ROW
BEGIN
    IF OLD.status = 'Active' AND NEW.status != 'Active' THEN
        UPDATE customers
        SET active_policies_count = active_policies_count - 1
        WHERE id = NEW.customer_id;
    ELSEIF OLD.status != 'Active' AND NEW.status = 'Active' THEN
        UPDATE customers
        SET active_policies_count = active_policies_count + 1
        WHERE id = NEW.customer_id;
    END IF;
END //

-- Trigger to update agent statistics on commission payment
CREATE TRIGGER trg_after_commission_update
AFTER UPDATE ON commissions
FOR EACH ROW
BEGIN
    IF OLD.status != 'Paid' AND NEW.status = 'Paid' THEN
        UPDATE agents
        SET total_commission_earned = total_commission_earned + NEW.net_commission
        WHERE id = NEW.agent_id;
    END IF;
END //

DELIMITER ;

-- ============================================================================
-- GRANTS (Optional - Configure as per security requirements)
-- ============================================================================

-- Create application user
-- CREATE USER 'insurance_app'@'localhost' IDENTIFIED BY 'secure_password';
-- GRANT SELECT, INSERT, UPDATE ON insurance_power_buyer.* TO 'insurance_app'@'localhost';
-- GRANT DELETE ON insurance_power_buyer.audit_logs TO 'insurance_app'@'localhost';
-- FLUSH PRIVILEGES;

-- ============================================================================
-- END OF SCHEMA
-- ============================================================================
