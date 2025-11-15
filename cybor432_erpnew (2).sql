-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Nov 15, 2025 at 04:07 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.0.30

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `cybor432_erpnew`
--

-- --------------------------------------------------------

--
-- Table structure for table `accountg`
--

CREATE TABLE `accountg` (
  `grcode` varchar(20) NOT NULL,
  `name` varchar(255) NOT NULL,
  `reserve` enum('Y','N') DEFAULT 'N',
  `actype1` char(1) NOT NULL DEFAULT 'A',
  `position` int(11) DEFAULT 0,
  `pos` int(11) DEFAULT 0,
  `grp` int(11) DEFAULT 0,
  `mgrp` varchar(50) DEFAULT NULL,
  `bscode` varchar(50) DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accountg`
--

INSERT INTO `accountg` (`grcode`, `name`, `reserve`, `actype1`, `position`, `pos`, `grp`, `mgrp`, `bscode`, `created_at`, `updated_at`) VALUES
('SUNCR', 'Sundry Creditors', 'N', 'L', 0, 0, 0, NULL, 'SUNCR', '2025-11-14 19:45:57', '2025-11-14 19:45:57'),
('SUNDB', 'Sundry Debtors', 'N', 'A', 0, 0, 0, NULL, 'SUNDB', '2025-11-14 19:45:57', '2025-11-14 19:45:57');

-- --------------------------------------------------------

--
-- Table structure for table `accountgbs`
--

CREATE TABLE `accountgbs` (
  `hcode` varchar(20) NOT NULL,
  `hname` varchar(255) NOT NULL,
  `actype1` char(1) NOT NULL DEFAULT 'A',
  `pos` int(11) DEFAULT 0,
  `reserve` enum('Y','N') DEFAULT 'N',
  `expand` enum('Y','N') DEFAULT 'N',
  `amount` decimal(18,2) DEFAULT 0.00,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accountgbs`
--

INSERT INTO `accountgbs` (`hcode`, `hname`, `actype1`, `pos`, `reserve`, `expand`, `amount`, `created_at`, `updated_at`) VALUES
('SUNCR', 'Sundry Creditors', 'L', 0, 'N', 'N', 0.00, '2025-11-14 19:45:57', '2025-11-14 19:45:57'),
('SUNDB', 'Sundry Debtors', 'A', 0, 'N', 'N', 0.00, '2025-11-14 19:45:57', '2025-11-14 19:45:57');

-- --------------------------------------------------------

--
-- Table structure for table `accounting_bank_reconciliations`
--

CREATE TABLE `accounting_bank_reconciliations` (
  `id` int(11) UNSIGNED NOT NULL,
  `bank_account` varchar(150) NOT NULL,
  `statement_date` date NOT NULL,
  `ledger_balance` decimal(15,2) NOT NULL DEFAULT 0.00,
  `statement_balance` decimal(15,2) NOT NULL DEFAULT 0.00,
  `unpresented_cheques` decimal(15,2) NOT NULL DEFAULT 0.00,
  `deposits_in_transit` decimal(15,2) NOT NULL DEFAULT 0.00,
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `accounting_credit_notes`
--

CREATE TABLE `accounting_credit_notes` (
  `id` int(11) UNSIGNED NOT NULL,
  `reference_type` varchar(100) NOT NULL,
  `reference_number` varchar(100) DEFAULT NULL,
  `entry_date` date NOT NULL,
  `account_code` varchar(50) NOT NULL,
  `amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `reason` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `accounting_debit_notes`
--

CREATE TABLE `accounting_debit_notes` (
  `id` int(11) UNSIGNED NOT NULL,
  `reference_type` varchar(100) NOT NULL,
  `reference_number` varchar(100) DEFAULT NULL,
  `entry_date` date NOT NULL,
  `account_code` varchar(50) NOT NULL,
  `amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `reason` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `accountm`
--

CREATE TABLE `accountm` (
  `accode` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `name` varchar(255) NOT NULL,
  `actype1` char(1) NOT NULL DEFAULT 'A',
  `actype2` char(1) DEFAULT NULL,
  `reserve` enum('Y','N') DEFAULT 'N',
  `grcode` varchar(20) DEFAULT NULL,
  `opbal` decimal(18,2) DEFAULT 0.00,
  `opbalb` decimal(18,2) DEFAULT 0.00,
  `control` tinyint(4) DEFAULT 1,
  `hlp` tinyint(4) DEFAULT 1,
  `amount` decimal(18,2) DEFAULT 0.00,
  `tplpos` int(11) DEFAULT 0,
  `bshead` varchar(20) DEFAULT NULL,
  `shepos` int(11) DEFAULT 0,
  `shedgrp` varchar(50) DEFAULT NULL,
  `sp` tinyint(4) DEFAULT 0,
  `amount2` decimal(18,2) DEFAULT 0.00,
  `removed` enum('Y','N') DEFAULT 'N',
  `blocked` enum('Y','N') DEFAULT 'N',
  `opdate` date DEFAULT NULL,
  `clbal` decimal(18,2) DEFAULT 0.00,
  `aclink` varchar(50) DEFAULT NULL,
  `acperc` decimal(10,2) DEFAULT 0.00,
  `note` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `accountm`
--

INSERT INTO `accountm` (`accode`, `name`, `actype1`, `actype2`, `reserve`, `grcode`, `opbal`, `opbalb`, `control`, `hlp`, `amount`, `tplpos`, `bshead`, `shepos`, `shedgrp`, `sp`, `amount2`, `removed`, `blocked`, `opdate`, `clbal`, `aclink`, `acperc`, `note`, `created_at`, `updated_at`) VALUES
('BANK', 'Bank Account', 'A', NULL, 'Y', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'Main bank account', '2025-11-14 16:36:35', '2025-11-14 16:36:35'),
('CAPITAL', 'Capital', 'A', NULL, 'Y', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'Owner capital', '2025-11-14 16:36:35', '2025-11-14 16:36:35'),
('CASH', 'Cash on Hand', 'A', NULL, 'Y', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'Cash available at office', '2025-11-14 16:36:35', '2025-11-14 16:36:35'),
('COMMISSION', 'Commission Expense', 'E', NULL, 'Y', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'Broker and agent commissions', '2025-11-14 16:36:35', '2025-11-14 16:36:35'),
('DISCALL', 'Discount Allowed', 'E', NULL, 'Y', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'Discounts given to customers', '2025-11-14 16:36:35', '2025-11-14 16:36:35'),
('DISCREC', 'Discount Received', 'R', NULL, 'Y', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'Discounts received from suppliers', '2025-11-14 16:36:35', '2025-11-14 16:36:35'),
('PDCPAY', 'PDC Payable', 'L', NULL, 'Y', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'Post-dated cheques issued to suppliers', '2025-11-14 16:36:35', '2025-11-14 16:36:35'),
('PDCREC', 'PDC Receivable', 'A', NULL, 'Y', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'Post-dated cheques received from customers', '2025-11-14 16:36:35', '2025-11-14 16:36:35'),
('PURCHASE', 'Purchase Cost', 'E', NULL, 'Y', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'Cost of purchases', '2025-11-14 16:36:35', '2025-11-14 16:36:35'),
('RENT', 'Rent Expense', 'E', NULL, 'N', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'Office rent', '2025-11-14 16:36:35', '2025-11-14 16:36:35'),
('SALARY', 'Salary Expense', 'E', NULL, 'N', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'Employee salaries', '2025-11-14 16:36:35', '2025-11-14 16:36:35'),
('SALES', 'Sales Revenue', 'R', NULL, 'Y', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'Revenue from sales', '2025-11-14 16:36:35', '2025-11-14 16:36:35'),
('UTILITIES', 'Utilities Expense', 'E', NULL, 'N', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'Electricity, water, internet', '2025-11-14 16:36:35', '2025-11-14 16:36:35'),
('VAT-IN', 'VAT Input', 'A', NULL, 'Y', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'VAT paid to suppliers', '2025-11-14 16:36:35', '2025-11-14 16:36:35'),
('VAT-OUT', 'VAT Output', 'L', NULL, 'Y', NULL, 0.00, 0.00, 1, 1, 0.00, 0, NULL, 0, NULL, 0, 0.00, 'N', 'N', NULL, 0.00, NULL, 0.00, 'VAT collected from customers', '2025-11-14 16:36:35', '2025-11-14 16:36:35');

-- --------------------------------------------------------

--
-- Table structure for table `agent`
--

CREATE TABLE `agent` (
  `agent_id` int(11) NOT NULL,
  `agent_code` varchar(50) DEFAULT NULL,
  `agent_name` varchar(255) NOT NULL,
  `contact_person` varchar(255) DEFAULT NULL,
  `mobile` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `commission_rate` decimal(5,2) DEFAULT 0.00,
  `status` tinyint(1) DEFAULT 1,
  `salesman_code` varchar(50) DEFAULT NULL,
  `fax` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `agent`
--

INSERT INTO `agent` (`agent_id`, `agent_code`, `agent_name`, `contact_person`, `mobile`, `email`, `address`, `commission_rate`, `status`, `salesman_code`, `fax`) VALUES
(1, 'AGT-0001', 'Ahmed Insurance Services', 'Ahmed Ali', '+971-50-5555555', 'ahmed@ahmedinsurance.ae', 'Al Nahda, Dubai', 3.00, 1, NULL, NULL),
(2, 'AGT-0002', 'Khalid Agency', 'Khalid Omar', '+971-55-6666666', 'khalid@khalidagency.ae', 'Sharjah', 3.50, 1, NULL, NULL),
(3, 'AGT-0003', 'Aisha Insurance Agency', 'Aisha Mohammed', '+971-50-7777777', 'aisha@aishaagency.ae', 'Ajman', 3.25, 1, NULL, NULL),
(4, 'AGT-0004', 'Omar Consultants', 'Omar Hassan', '+971-55-8888888', 'omar@omarconsultants.ae', 'Ras Al Khaimah', 2.75, 1, NULL, NULL),
(5, 'AGT-0005', 'Mariam Insurance Hub', 'Mariam Saeed', '+971-50-9999999', 'mariam@mariamhub.ae', 'Fujairah', 3.00, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `agent_commission`
--

CREATE TABLE `agent_commission` (
  `commission_id` int(11) NOT NULL,
  `agent_id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `commission_amount` decimal(15,2) NOT NULL,
  `commission_rate` decimal(5,2) NOT NULL,
  `paid_amount` decimal(15,2) DEFAULT 0.00,
  `payment_status` enum('unpaid','partial','paid') DEFAULT 'unpaid',
  `last_payment_date` date DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `agent_commission`
--

INSERT INTO `agent_commission` (`commission_id`, `agent_id`, `invoice_id`, `commission_amount`, `commission_rate`, `paid_amount`, `payment_status`, `last_payment_date`, `payment_method`, `payment_notes`) VALUES
(1, 1, 1, 157.50, 3.00, 157.50, 'paid', NULL, NULL, NULL),
(2, 2, 2, 441.00, 3.50, 200.00, 'partial', NULL, NULL, NULL),
(3, 3, 3, 119.44, 3.25, 0.00, 'unpaid', NULL, NULL, NULL),
(4, 1, 4, 252.00, 3.00, 252.00, 'paid', NULL, NULL, NULL),
(5, 4, 5, 72.19, 2.75, 0.00, 'unpaid', NULL, NULL, NULL),
(6, 2, 6, 551.25, 3.50, 0.00, 'unpaid', NULL, NULL, NULL),
(7, 5, 7, 47.25, 3.00, 47.25, 'paid', NULL, NULL, NULL),
(8, 3, 8, 341.25, 3.25, 150.00, 'partial', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `audit_logs`
--

CREATE TABLE `audit_logs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED DEFAULT NULL,
  `action` varchar(255) NOT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `audit_logs`
--

INSERT INTO `audit_logs` (`id`, `user_id`, `action`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 1, 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-14 11:06:51'),
(2, 1, 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-14 13:33:34'),
(3, 1, 'User logged in', '::1', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36', '2025-11-15 11:22:50');

-- --------------------------------------------------------

--
-- Table structure for table `broker`
--

CREATE TABLE `broker` (
  `broker_id` int(11) NOT NULL,
  `broker_code` varchar(50) DEFAULT NULL,
  `broker_name` varchar(255) NOT NULL,
  `contact_person` varchar(255) DEFAULT NULL,
  `mobile` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `commission_rate` decimal(5,2) DEFAULT 0.00,
  `status` tinyint(1) DEFAULT 1,
  `salesman_code` varchar(50) DEFAULT NULL,
  `fax` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `broker`
--

INSERT INTO `broker` (`broker_id`, `broker_code`, `broker_name`, `contact_person`, `mobile`, `email`, `address`, `commission_rate`, `status`, `salesman_code`, `fax`) VALUES
(1, 'BRK-0001', 'Gulf Insurance Brokers', 'Ali Hassan', '+971-50-1111111', 'ali@gulfbrokers.ae', 'Sheikh Zayed Road, Dubai', 5.00, 1, NULL, NULL),
(2, 'BRK-0002', 'Emirates Brokerage House', 'Fatima Ahmed', '+971-55-2222222', 'fatima@emiratesbroker.ae', 'DIFC, Dubai', 4.50, 1, NULL, NULL),
(3, 'BRK-0003', 'Middle East Insurance Brokers', 'Mohammed Said', '+971-50-3333333', 'mohammed@mebrokers.ae', 'Business Bay, Dubai', 5.50, 1, NULL, NULL),
(4, 'BRK-0004', 'Dubai Insurance Consultants', 'Sara Khalid', '+971-55-4444444', 'sara@dubaiinsuranceconsult.ae', 'Deira, Dubai', 4.00, 1, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `broker_commission`
--

CREATE TABLE `broker_commission` (
  `commission_id` int(11) NOT NULL,
  `broker_id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `commission_amount` decimal(15,2) NOT NULL,
  `commission_rate` decimal(5,2) NOT NULL,
  `paid_amount` decimal(15,2) DEFAULT 0.00,
  `payment_status` enum('unpaid','partial','paid') DEFAULT 'unpaid',
  `last_payment_date` date DEFAULT NULL,
  `payment_method` varchar(50) DEFAULT NULL,
  `payment_notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `broker_commission`
--

INSERT INTO `broker_commission` (`commission_id`, `broker_id`, `invoice_id`, `commission_amount`, `commission_rate`, `paid_amount`, `payment_status`, `last_payment_date`, `payment_method`, `payment_notes`) VALUES
(1, 1, 1, 262.50, 5.00, 262.50, 'paid', NULL, NULL, NULL),
(2, 2, 2, 567.00, 4.50, 300.00, 'partial', NULL, NULL, NULL),
(3, 1, 3, 201.88, 5.50, 0.00, 'unpaid', NULL, NULL, NULL),
(4, 3, 4, 462.00, 5.50, 462.00, 'paid', NULL, NULL, NULL),
(5, 2, 5, 118.13, 4.50, 0.00, 'unpaid', NULL, NULL, NULL),
(6, 4, 6, 630.00, 4.00, 0.00, 'unpaid', NULL, NULL, NULL),
(7, 1, 7, 86.63, 5.50, 86.63, 'paid', NULL, NULL, NULL),
(8, 3, 8, 577.50, 5.50, 300.00, 'partial', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `category_list`
--

CREATE TABLE `category_list` (
  `category_id` int(11) NOT NULL,
  `category_name` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  `category_code` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `category_list`
--

INSERT INTO `category_list` (`category_id`, `category_name`, `description`, `status`, `category_code`) VALUES
(1, 'Motor Insurance', 'Vehicle insurance products', 1, NULL),
(2, 'Health Insurance', 'Medical and health insurance products', 1, NULL),
(3, 'Property Insurance', 'Home and property insurance', 1, NULL),
(4, 'Life Insurance', 'Life and term insurance products', 1, NULL),
(5, 'Travel Insurance', 'Travel and trip insurance', 1, NULL),
(6, 'Business Insurance', 'Commercial and business insurance', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `clients`
--

CREATE TABLE `clients` (
  `code` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `ctype` enum('C','S','F','A') NOT NULL DEFAULT 'C',
  `grp` varchar(50) DEFAULT NULL,
  `account_group` varchar(50) DEFAULT NULL,
  `bshead` varchar(50) DEFAULT NULL,
  `addr1` varchar(255) DEFAULT NULL,
  `addr2` varchar(255) DEFAULT NULL,
  `addr3` varchar(255) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `pin` varchar(20) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `route` varchar(50) DEFAULT NULL,
  `carea` varchar(50) DEFAULT NULL,
  `distance` decimal(10,2) DEFAULT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `homemobile` varchar(50) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `tin` varchar(30) DEFAULT NULL,
  `cst` varchar(30) DEFAULT NULL,
  `panadhar` varchar(50) DEFAULT NULL,
  `religion` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `smcode` varchar(50) DEFAULT NULL,
  `cocode` varchar(50) DEFAULT NULL,
  `care_of_name` varchar(255) DEFAULT NULL,
  `care_of_party` enum('Y','N') DEFAULT 'N',
  `pcard` varchar(50) DEFAULT NULL,
  `pcardno` varchar(50) DEFAULT NULL,
  `oppcardpoints` decimal(10,2) DEFAULT NULL,
  `salary` decimal(18,2) DEFAULT NULL,
  `cutrate` decimal(10,2) DEFAULT NULL,
  `commission_pct` decimal(10,2) DEFAULT NULL,
  `colncomn` decimal(10,2) DEFAULT NULL,
  `staff_commission` decimal(10,2) DEFAULT NULL,
  `id_number` varchar(100) DEFAULT NULL,
  `pospwd` varchar(100) DEFAULT NULL,
  `approval` varchar(100) DEFAULT NULL,
  `agent` enum('Y','N') DEFAULT 'N',
  `agentcode` varchar(50) DEFAULT NULL,
  `contract_date` date DEFAULT NULL,
  `adate` date DEFAULT NULL,
  `duedate` date DEFAULT NULL,
  `opbalance` decimal(18,2) DEFAULT 0.00,
  `opbalanceb` decimal(18,2) DEFAULT 0.00,
  `balance_type` enum('dr','cr') DEFAULT 'cr',
  `secondary_balance_type` enum('dr','cr') DEFAULT 'cr',
  `control` tinyint(4) DEFAULT 1,
  `removed` enum('Y','N') DEFAULT 'N',
  `blocked` enum('Y','N') DEFAULT 'N',
  `display` enum('Y','N') DEFAULT 'Y',
  `link_phonebook` enum('Y','N') DEFAULT 'N',
  `print_card` enum('Y','N') DEFAULT 'N',
  `show_camera` enum('Y','N') DEFAULT 'N',
  `update_foreign` enum('Y','N') DEFAULT 'N',
  `agent_staff` enum('Y','N') DEFAULT 'N',
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `fax` varchar(50) DEFAULT NULL,
  `contact_person` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clientspict`
--

CREATE TABLE `clientspict` (
  `client_code` varchar(50) NOT NULL,
  `mime_type` varchar(100) DEFAULT NULL,
  `picture` longblob DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `clients_advanced`
--

CREATE TABLE `clients_advanced` (
  `client_code` varchar(50) NOT NULL,
  `payload` longtext DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `collection`
--

CREATE TABLE `collection` (
  `id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `collection_date` date NOT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `discount_amount` decimal(15,2) DEFAULT 0.00,
  `received_amount` decimal(15,2) NOT NULL,
  `payment_type` varchar(50) DEFAULT NULL,
  `details` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `contra`
--

CREATE TABLE `contra` (
  `contra_id` int(11) NOT NULL,
  `contra_date` date NOT NULL,
  `from_account` varchar(50) NOT NULL,
  `to_account` varchar(50) NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `narration` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `customer_information`
--

CREATE TABLE `customer_information` (
  `customer_id` int(11) NOT NULL,
  `customer_name` varchar(255) NOT NULL,
  `customer_mobile` varchar(20) NOT NULL,
  `customer_email` varchar(100) DEFAULT NULL,
  `customer_address_1` text DEFAULT NULL,
  `customer_address_2` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `zip` varchar(20) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `contact` varchar(100) DEFAULT NULL,
  `credit_limit` decimal(15,2) DEFAULT 0.00,
  `status` tinyint(1) DEFAULT 1,
  `customer_code` varchar(50) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `salesman_code` varchar(50) DEFAULT NULL,
  `fax` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `customer_information`
--

INSERT INTO `customer_information` (`customer_id`, `customer_name`, `customer_mobile`, `customer_email`, `customer_address_1`, `customer_address_2`, `city`, `state`, `zip`, `country`, `contact`, `credit_limit`, `status`, `customer_code`, `phone`, `email`, `salesman_code`, `fax`) VALUES
(1, 'Ahmed Mohammed Ali', '+971-50-1234567', 'ahmed.ali@email.com', 'Al Nahda Street, Building 123', NULL, 'Dubai', 'Dubai', NULL, 'UAE', NULL, 50000.00, 1, 'CUST-0001', '+971-50-1234567', 'ahmed.ali@email.com', NULL, NULL),
(2, 'Fatima Hassan', '+971-55-2345678', 'fatima.hassan@email.com', 'Deira City Center, Office 456', NULL, 'Dubai', 'Dubai', NULL, 'UAE', NULL, 30000.00, 1, 'CUST-0002', '+971-55-2345678', 'fatima.hassan@email.com', NULL, NULL),
(3, 'Mohammed Abdullah', '+971-50-3456789', 'mohammed.abdullah@email.com', 'Sheikh Zayed Road, Tower 789', NULL, 'Dubai', 'Dubai', NULL, 'UAE', NULL, 75000.00, 1, 'CUST-0003', '+971-50-3456789', 'mohammed.abdullah@email.com', NULL, NULL),
(4, 'Sara Ibrahim', '+971-55-4567890', 'sara.ibrahim@email.com', 'Jumeirah Beach Road, Villa 12', NULL, 'Dubai', 'Dubai', NULL, 'UAE', NULL, 40000.00, 1, 'CUST-0004', '+971-55-4567890', 'sara.ibrahim@email.com', NULL, NULL),
(5, 'Omar Khalid', '+971-50-5678901', 'omar.khalid@email.com', 'Business Bay, Floor 15', NULL, 'Dubai', 'Dubai', NULL, 'UAE', NULL, 60000.00, 1, 'CUST-0005', '+971-50-5678901', 'omar.khalid@email.com', NULL, NULL),
(6, 'Aisha Rashid', '+971-55-6789012', 'aisha.rashid@email.com', 'Marina Walk, Apartment 234', NULL, 'Dubai', 'Dubai', NULL, 'UAE', NULL, 35000.00, 1, 'CUST-0006', '+971-55-6789012', 'aisha.rashid@email.com', NULL, NULL),
(7, 'Khalid Salem', '+971-50-7890123', 'khalid.salem@email.com', 'Al Barsha, Street 45', NULL, 'Dubai', 'Dubai', NULL, 'UAE', NULL, 45000.00, 1, 'CUST-0007', '+971-50-7890123', 'khalid.salem@email.com', NULL, NULL),
(8, 'Mariam Youssef', '+971-55-8901234', 'mariam.youssef@email.com', 'JBR, Block A', NULL, 'Dubai', 'Dubai', NULL, 'UAE', NULL, 55000.00, 1, 'CUST-0008', '+971-55-8901234', 'mariam.youssef@email.com', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `daybook`
--

CREATE TABLE `daybook` (
  `id` int(11) NOT NULL,
  `date` date NOT NULL,
  `account_code` varchar(50) NOT NULL,
  `debit` decimal(15,2) DEFAULT 0.00,
  `credit` decimal(15,2) DEFAULT 0.00,
  `narration` text DEFAULT NULL,
  `reference_type` varchar(50) DEFAULT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `daybook`
--

INSERT INTO `daybook` (`id`, `date`, `account_code`, `debit`, `credit`, `narration`, `reference_type`, `reference_id`, `created_at`) VALUES
(1, '2024-01-15', 'CUST_1', 5250.00, 0.00, 'Sales to Ahmed Mohammed Ali', 'invoice', 1, '2025-11-14 11:06:16'),
(2, '2024-01-15', 'SALES', 0.00, 5000.00, 'Sales revenue', 'invoice', 1, '2025-11-14 11:06:16'),
(3, '2024-01-15', 'VAT-OUT', 0.00, 250.00, 'VAT on sales', 'invoice', 1, '2025-11-14 11:06:16'),
(4, '2024-01-20', 'BANK', 5250.00, 0.00, 'Receipt from Ahmed Mohammed Ali', 'receipt', 1, '2025-11-14 11:06:16'),
(5, '2024-01-20', 'CUST_1', 0.00, 5250.00, 'Payment received', 'receipt', 1, '2025-11-14 11:06:16'),
(6, '2024-01-10', 'PURCHASE', 50000.00, 0.00, 'Purchase from Dubai Insurance Company', 'purchase', 1, '2025-11-14 11:06:16'),
(7, '2024-01-10', 'VAT-IN', 2500.00, 0.00, 'VAT on purchase', 'purchase', 1, '2025-11-14 11:06:16'),
(8, '2024-01-10', 'SUPP_1', 0.00, 52500.00, 'Purchase liability', 'purchase', 1, '2025-11-14 11:06:16'),
(9, '2024-01-15', 'SUPP_1', 52500.00, 0.00, 'Payment to Dubai Insurance Company', 'payment', 1, '2025-11-14 11:06:16'),
(10, '2024-01-15', 'BANK', 0.00, 52500.00, 'Payment made', 'payment', 1, '2025-11-14 11:06:16'),
(11, '2024-01-20', 'COMMISSION', 262.50, 0.00, 'Broker commission - Gulf Insurance Brokers', 'commission', 1, '2025-11-14 11:06:16'),
(12, '2024-01-20', 'BANK', 0.00, 262.50, 'Commission paid', 'commission', 1, '2025-11-14 11:06:16');

-- --------------------------------------------------------

--
-- Table structure for table `generali`
--

CREATE TABLE `generali` (
  `code` varchar(100) NOT NULL,
  `cvalue` text DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL,
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `generali`
--

INSERT INTO `generali` (`code`, `cvalue`, `description`, `updated_at`) VALUES
('CLIENT_AUTOCODE_CUSTOMER', '{\"enabled\":true,\"prefix\":\"C\",\"next\":1,\"padding\":4}', 'Auto-code settings for customers', '2025-11-14 19:24:13'),
('CLIENT_AUTOCODE_SUPPLIER', '{\"enabled\":true,\"prefix\":\"S\",\"next\":1,\"padding\":4}', 'Auto-code settings for suppliers', '2025-11-14 19:24:13'),
('PURCHASEB', '0', 'Legacy purchase bill counter', '2025-11-15 18:41:54');

-- --------------------------------------------------------

--
-- Table structure for table `hr_attendance`
--

CREATE TABLE `hr_attendance` (
  `id` int(11) UNSIGNED NOT NULL,
  `employee_id` int(11) NOT NULL,
  `attendance_date` date NOT NULL,
  `check_in` time DEFAULT NULL,
  `check_out` time DEFAULT NULL,
  `work_location` varchar(100) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hr_employees`
--

CREATE TABLE `hr_employees` (
  `id` int(10) UNSIGNED NOT NULL,
  `employee_code` varchar(50) NOT NULL,
  `full_name` varchar(191) NOT NULL,
  `department` varchar(100) DEFAULT NULL,
  `designation` varchar(100) DEFAULT NULL,
  `joining_date` date DEFAULT NULL,
  `work_email` varchar(191) DEFAULT NULL,
  `mobile` varchar(20) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `status` varchar(50) DEFAULT 'Active',
  `notes` text DEFAULT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hr_leave_requests`
--

CREATE TABLE `hr_leave_requests` (
  `id` int(11) UNSIGNED NOT NULL,
  `employee_id` int(11) NOT NULL,
  `leave_type` varchar(100) NOT NULL,
  `from_date` date NOT NULL,
  `to_date` date NOT NULL,
  `total_days` decimal(10,2) NOT NULL DEFAULT 0.00,
  `approver` varchar(100) DEFAULT NULL,
  `reason` text DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Pending',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hr_payroll_cycles`
--

CREATE TABLE `hr_payroll_cycles` (
  `id` int(11) UNSIGNED NOT NULL,
  `payroll_month` varchar(20) NOT NULL,
  `pay_group` varchar(100) DEFAULT NULL,
  `payment_date` date DEFAULT NULL,
  `basic_salary` decimal(15,2) NOT NULL DEFAULT 0.00,
  `allowances` decimal(15,2) NOT NULL DEFAULT 0.00,
  `deductions` decimal(15,2) NOT NULL DEFAULT 0.00,
  `net_pay` decimal(15,2) NOT NULL DEFAULT 0.00,
  `remarks` text DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Draft',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hr_performance_reviews`
--

CREATE TABLE `hr_performance_reviews` (
  `id` int(11) UNSIGNED NOT NULL,
  `employee_id` int(11) NOT NULL,
  `review_period` varchar(20) NOT NULL,
  `rating` varchar(50) DEFAULT NULL,
  `kpi_score` decimal(10,2) NOT NULL DEFAULT 0.00,
  `development_plan` text DEFAULT NULL,
  `status` varchar(50) NOT NULL DEFAULT 'Draft',
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hr_salary_structures`
--

CREATE TABLE `hr_salary_structures` (
  `id` int(11) UNSIGNED NOT NULL,
  `grade` varchar(20) NOT NULL,
  `basic_pct` decimal(10,2) NOT NULL DEFAULT 0.00,
  `housing_allowance` decimal(15,2) NOT NULL DEFAULT 0.00,
  `transport_allowance` decimal(15,2) NOT NULL DEFAULT 0.00,
  `other_benefits` text DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_claims`
--

CREATE TABLE `insurance_claims` (
  `id` int(11) UNSIGNED NOT NULL,
  `claim_number` varchar(100) NOT NULL,
  `policy_id` int(11) DEFAULT NULL,
  `policy_number` varchar(100) DEFAULT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `loss_date` date DEFAULT NULL,
  `loss_type` varchar(100) DEFAULT NULL,
  `reserve_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `adjuster` varchar(100) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `narration` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_commissions`
--

CREATE TABLE `insurance_commissions` (
  `id` int(11) UNSIGNED NOT NULL,
  `partner_type` varchar(50) NOT NULL,
  `partner_id` int(11) DEFAULT NULL,
  `partner_name` varchar(191) DEFAULT NULL,
  `policy_number` varchar(100) DEFAULT NULL,
  `commission_pct` decimal(10,4) NOT NULL DEFAULT 0.0000,
  `commission_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `payable_on` date DEFAULT NULL,
  `approval_status` varchar(50) DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_endorsements`
--

CREATE TABLE `insurance_endorsements` (
  `id` int(11) UNSIGNED NOT NULL,
  `policy_number` varchar(100) NOT NULL,
  `endorsement_type` varchar(100) DEFAULT NULL,
  `effective_date` date DEFAULT NULL,
  `premium_impact` decimal(15,2) NOT NULL DEFAULT 0.00,
  `approval_route` varchar(100) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_policies`
--

CREATE TABLE `insurance_policies` (
  `id` int(11) UNSIGNED NOT NULL,
  `policy_number` varchar(100) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `product_id` int(11) DEFAULT NULL,
  `agent_id` int(11) DEFAULT NULL,
  `effective_date` date DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `premium_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `payment_mode` varchar(50) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_premium_collections`
--

CREATE TABLE `insurance_premium_collections` (
  `id` int(11) UNSIGNED NOT NULL,
  `reference_type` varchar(50) NOT NULL,
  `reference_id` varchar(100) DEFAULT NULL,
  `due_date` date DEFAULT NULL,
  `installment_no` int(11) DEFAULT NULL,
  `due_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `receipt_type` varchar(50) DEFAULT NULL,
  `collection_owner` varchar(100) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_renewals`
--

CREATE TABLE `insurance_renewals` (
  `id` int(11) UNSIGNED NOT NULL,
  `policy_number` varchar(100) NOT NULL,
  `current_expiry` date DEFAULT NULL,
  `category` varchar(100) DEFAULT NULL,
  `assigned_to` varchar(100) DEFAULT NULL,
  `proposed_premium` decimal(15,2) NOT NULL DEFAULT 0.00,
  `follow_up_date` date DEFAULT NULL,
  `feedback` text DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `insurance_underwriting_reviews`
--

CREATE TABLE `insurance_underwriting_reviews` (
  `id` int(11) UNSIGNED NOT NULL,
  `submission_ref` varchar(100) NOT NULL,
  `channel_type` varchar(50) DEFAULT NULL,
  `channel_id` int(11) DEFAULT NULL,
  `risk_category` varchar(50) DEFAULT NULL,
  `sum_assured` decimal(15,2) NOT NULL DEFAULT 0.00,
  `base_rate` decimal(10,4) NOT NULL DEFAULT 0.0000,
  `loading` decimal(10,4) NOT NULL DEFAULT 0.0000,
  `decision` varchar(50) DEFAULT NULL,
  `remarks` text DEFAULT NULL,
  `created_by` int(11) DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `invoice`
--

CREATE TABLE `invoice` (
  `invoice_id` int(11) NOT NULL,
  `invoice` varchar(100) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `total` decimal(15,2) NOT NULL,
  `vat` decimal(15,2) DEFAULT 0.00,
  `grand_total` decimal(15,2) NOT NULL,
  `total_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `paid_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `due_amount` decimal(15,2) NOT NULL DEFAULT 0.00,
  `payment_status` enum('unpaid','partial','paid') DEFAULT 'unpaid',
  `broker_id` int(11) DEFAULT NULL,
  `agent_id` int(11) DEFAULT NULL,
  `sales_by` int(11) DEFAULT NULL,
  `sales_date` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoice`
--

INSERT INTO `invoice` (`invoice_id`, `invoice`, `customer_id`, `date`, `total`, `vat`, `grand_total`, `total_amount`, `paid_amount`, `due_amount`, `payment_status`, `broker_id`, `agent_id`, `sales_by`, `sales_date`, `created_at`, `updated_at`) VALUES
(1, 'INV-2024-0001', 1, '2024-01-15', 5000.00, 250.00, 5250.00, 5250.00, 5250.00, 0.00, 'paid', 1, 1, 1, '2024-01-15 10:00:00', '2025-11-14 11:06:16', '2025-11-14 11:06:16'),
(2, 'INV-2024-0002', 2, '2024-01-18', 12000.00, 600.00, 12600.00, 12600.00, 6000.00, 6600.00, 'partial', 2, 2, 1, '2024-01-18 11:30:00', '2025-11-14 11:06:16', '2025-11-14 11:06:16'),
(3, 'INV-2024-0003', 3, '2024-01-22', 3500.00, 175.00, 3675.00, 3675.00, 0.00, 3675.00, 'unpaid', 1, 3, 1, '2024-01-22 09:15:00', '2025-11-14 11:06:16', '2025-11-14 11:06:16'),
(4, 'INV-2024-0004', 4, '2024-01-25', 8000.00, 400.00, 8400.00, 8400.00, 8400.00, 0.00, 'paid', 3, 1, 1, '2024-01-25 16:45:00', '2025-11-14 11:06:16', '2025-11-14 11:06:16'),
(5, 'INV-2024-0005', 5, '2024-02-01', 2500.00, 125.00, 2625.00, 2625.00, 1200.00, 1425.00, 'partial', 2, 4, 1, '2024-02-01 14:20:00', '2025-11-14 11:06:16', '2025-11-14 11:06:16'),
(6, 'INV-2024-0006', 6, '2024-02-05', 15000.00, 750.00, 15750.00, 15750.00, 0.00, 15750.00, 'unpaid', 4, 2, 1, '2024-02-05 10:30:00', '2025-11-14 11:06:16', '2025-11-14 11:06:16'),
(7, 'INV-2024-0007', 7, '2024-02-10', 1500.00, 75.00, 1575.00, 1575.00, 1575.00, 0.00, 'paid', 1, 5, 1, '2024-02-10 12:10:00', '2025-11-14 11:06:16', '2025-11-14 11:06:16'),
(8, 'INV-2024-0008', 8, '2024-02-15', 10000.00, 500.00, 10500.00, 10500.00, 5500.00, 5000.00, 'partial', 3, 3, 1, '2024-02-15 15:00:00', '2025-11-14 11:06:16', '2025-11-14 11:06:16');

-- --------------------------------------------------------

--
-- Table structure for table `invoice_details`
--

CREATE TABLE `invoice_details` (
  `id` int(11) NOT NULL,
  `invoice_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `rate` decimal(15,2) NOT NULL,
  `total_price` decimal(15,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `invoice_details`
--

INSERT INTO `invoice_details` (`id`, `invoice_id`, `product_id`, `quantity`, `rate`, `total_price`) VALUES
(1, 1, 3, 1.00, 5000.00, 5000.00),
(2, 2, 4, 1.00, 12000.00, 12000.00),
(3, 3, 6, 1.00, 3500.00, 3500.00),
(4, 4, 7, 1.00, 8000.00, 8000.00),
(5, 5, 1, 1.00, 2500.00, 2500.00),
(6, 6, 8, 1.00, 15000.00, 15000.00),
(7, 7, 5, 1.00, 1500.00, 1500.00),
(8, 8, 11, 1.00, 10000.00, 10000.00);

-- --------------------------------------------------------

--
-- Table structure for table `journal`
--

CREATE TABLE `journal` (
  `journal_id` int(11) NOT NULL,
  `journal_date` date NOT NULL,
  `narration` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `opening_balance`
--

CREATE TABLE `opening_balance` (
  `id` int(11) NOT NULL,
  `account_code` varchar(50) NOT NULL,
  `opening_balance` decimal(15,2) NOT NULL,
  `opening_date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `payment`
--

CREATE TABLE `payment` (
  `payment_id` int(11) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `payment_date` date NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `payment_method` enum('cash','bank','cheque','pdc') DEFAULT 'cash',
  `bank` varchar(255) DEFAULT NULL,
  `cheque_no` varchar(100) DEFAULT NULL,
  `cheque_date` date DEFAULT NULL,
  `discount` decimal(15,2) DEFAULT 0.00,
  `details` text DEFAULT NULL,
  `payment_voucher_no` varchar(100) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pdc`
--

CREATE TABLE `pdc` (
  `pdc_id` int(11) NOT NULL,
  `cheque_no` varchar(100) NOT NULL,
  `cheque_date` date NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `bank` varchar(255) DEFAULT NULL,
  `cheque_type` enum('received','issued') NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) DEFAULT NULL,
  `status` enum('pending','cleared','bounced','cancelled') DEFAULT 'pending',
  `cleared_date` date DEFAULT NULL,
  `reference_type` varchar(50) DEFAULT NULL,
  `reference_id` int(11) DEFAULT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pdc`
--

INSERT INTO `pdc` (`pdc_id`, `cheque_no`, `cheque_date`, `amount`, `bank`, `cheque_type`, `customer_id`, `supplier_id`, `status`, `cleared_date`, `reference_type`, `reference_id`, `notes`) VALUES
(1, 'CHQ-001-2024', '2024-04-15', 6600.00, 'Emirates NBD', 'received', 2, NULL, 'pending', NULL, 'invoice', 2, 'Balance payment for invoice INV-2024-0002'),
(2, 'CHQ-002-2024', '2024-04-20', 3675.00, 'ADCB', 'received', 3, NULL, 'pending', NULL, 'invoice', 3, 'Full payment PDC'),
(3, 'CHQ-003-2024', '2024-04-25', 15750.00, 'Mashreq Bank', 'received', 6, NULL, 'pending', NULL, 'invoice', 6, 'Full payment PDC'),
(4, 'CHQ-101-2024', '2024-04-10', 38750.00, 'Dubai Islamic Bank', 'issued', NULL, 2, 'pending', NULL, 'purchase', 2, 'Balance payment for purchase'),
(5, 'CHQ-102-2024', '2024-04-30', 105000.00, 'First Abu Dhabi Bank', 'issued', NULL, 3, 'pending', NULL, 'purchase', 3, 'Full payment PDC');

-- --------------------------------------------------------

--
-- Table structure for table `phonebook`
--

CREATE TABLE `phonebook` (
  `id` int(10) UNSIGNED NOT NULL,
  `client_code` varchar(50) NOT NULL,
  `name` varchar(255) NOT NULL,
  `resaddress` text DEFAULT NULL,
  `resphone` varchar(50) DEFAULT NULL,
  `offphone` varchar(50) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `email` varchar(150) DEFAULT NULL,
  `ptype` varchar(50) DEFAULT NULL,
  `grp` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_groups`
--

CREATE TABLE `product_groups` (
  `id` int(10) UNSIGNED NOT NULL,
  `group_code` varchar(50) NOT NULL,
  `group_name` varchar(255) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `product_information`
--

CREATE TABLE `product_information` (
  `product_id` int(11) NOT NULL,
  `product_name` varchar(255) NOT NULL,
  `product_model` varchar(100) DEFAULT NULL,
  `category_id` int(11) DEFAULT NULL,
  `unit_id` int(11) DEFAULT NULL,
  `price` decimal(15,2) NOT NULL,
  `quantity` decimal(10,2) DEFAULT 0.00,
  `min_stock` decimal(10,2) DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  `product_code` varchar(50) DEFAULT NULL,
  `group_id` int(10) UNSIGNED DEFAULT NULL,
  `subgroup_id` int(10) UNSIGNED DEFAULT NULL,
  `default_qty` decimal(10,2) DEFAULT 1.00,
  `supplier_price` decimal(15,2) DEFAULT 0.00,
  `tax_percent` decimal(5,2) DEFAULT 0.00,
  `taxable` tinyint(1) DEFAULT 1,
  `no_discount` tinyint(1) DEFAULT 0,
  `product_details` text DEFAULT NULL,
  `image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_information`
--

INSERT INTO `product_information` (`product_id`, `product_name`, `product_model`, `category_id`, `unit_id`, `price`, `quantity`, `min_stock`, `description`, `status`, `product_code`, `group_id`, `subgroup_id`, `default_qty`, `supplier_price`, `tax_percent`, `taxable`, `no_discount`, `product_details`, `image`) VALUES
(1, 'Comprehensive Motor Insurance', 'CMI-2024', 1, 1, 2500.00, 50.00, 10.00, 'Full coverage motor insurance policy', 1, NULL, NULL, NULL, 1.00, 0.00, 0.00, 1, 0, NULL, NULL),
(2, 'Third Party Motor Insurance', 'TPL-2024', 1, 1, 850.00, 100.00, 20.00, 'Third party liability motor insurance', 1, NULL, NULL, NULL, 1.00, 0.00, 0.00, 1, 0, NULL, NULL),
(3, 'Individual Health Insurance', 'IHI-2024', 2, 1, 5000.00, 75.00, 15.00, 'Individual health insurance coverage', 1, NULL, NULL, NULL, 1.00, 0.00, 0.00, 1, 0, NULL, NULL),
(4, 'Family Health Insurance', 'FHI-2024', 2, 1, 12000.00, 40.00, 10.00, 'Family floater health insurance', 1, NULL, NULL, NULL, 1.00, 0.00, 0.00, 1, 0, NULL, NULL),
(5, 'Home Insurance - Basic', 'HBI-2024', 3, 1, 1500.00, 60.00, 12.00, 'Basic home insurance coverage', 1, NULL, NULL, NULL, 1.00, 0.00, 0.00, 1, 0, NULL, NULL),
(6, 'Home Insurance - Comprehensive', 'HCI-2024', 3, 1, 3500.00, 35.00, 8.00, 'Comprehensive home insurance', 1, NULL, NULL, NULL, 1.00, 0.00, 0.00, 1, 0, NULL, NULL),
(7, 'Term Life Insurance', 'TLI-2024', 4, 1, 8000.00, 30.00, 5.00, 'Term life insurance policy', 1, NULL, NULL, NULL, 1.00, 0.00, 0.00, 1, 0, NULL, NULL),
(8, 'Whole Life Insurance', 'WLI-2024', 4, 1, 15000.00, 20.00, 5.00, 'Whole life insurance coverage', 1, NULL, NULL, NULL, 1.00, 0.00, 0.00, 1, 0, NULL, NULL),
(9, 'Travel Insurance - Single Trip', 'TST-2024', 5, 1, 250.00, 200.00, 50.00, 'Single trip travel insurance', 1, NULL, NULL, NULL, 1.00, 0.00, 0.00, 1, 0, NULL, NULL),
(10, 'Travel Insurance - Annual', 'TAM-2024', 5, 1, 1200.00, 80.00, 20.00, 'Annual multi-trip travel insurance', 1, NULL, NULL, NULL, 1.00, 0.00, 0.00, 1, 0, NULL, NULL),
(11, 'Business Liability Insurance', 'BLI-2024', 6, 1, 10000.00, 25.00, 5.00, 'Commercial general liability', 1, NULL, NULL, NULL, 1.00, 0.00, 0.00, 1, 0, NULL, NULL),
(12, 'Professional Indemnity', 'PIN-2024', 6, 1, 7500.00, 30.00, 5.00, 'Professional indemnity insurance', 1, NULL, NULL, NULL, 1.00, 0.00, 0.00, 1, 0, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_purchase`
--

CREATE TABLE `product_purchase` (
  `purchase_id` int(11) NOT NULL,
  `chalan_no` varchar(100) NOT NULL,
  `supplier_id` int(11) NOT NULL,
  `purchase_date` date NOT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `vat` decimal(15,2) DEFAULT 0.00,
  `grand_total_amount` decimal(15,2) NOT NULL,
  `payment_status` enum('unpaid','partial','paid') DEFAULT 'unpaid',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `line_discount_total` decimal(15,2) DEFAULT 0.00,
  `purchase_discount` decimal(15,2) DEFAULT 0.00,
  `total_discount` decimal(15,2) DEFAULT 0.00,
  `paid_amount` decimal(15,2) DEFAULT 0.00,
  `due_amount` decimal(15,2) DEFAULT 0.00,
  `payment_type` varchar(50) DEFAULT NULL,
  `payment_summary` text DEFAULT NULL,
  `details` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_purchase`
--

INSERT INTO `product_purchase` (`purchase_id`, `chalan_no`, `supplier_id`, `purchase_date`, `total_amount`, `vat`, `grand_total_amount`, `payment_status`, `created_at`, `line_discount_total`, `purchase_discount`, `total_discount`, `paid_amount`, `due_amount`, `payment_type`, `payment_summary`, `details`) VALUES
(1, 'PUR-2024-0001', 1, '2024-01-10', 50000.00, 2500.00, 52500.00, 'paid', '2025-11-14 11:06:16', 0.00, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(2, 'PUR-2024-0002', 2, '2024-01-12', 75000.00, 3750.00, 78750.00, 'partial', '2025-11-14 11:06:16', 0.00, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(3, 'PUR-2024-0003', 3, '2024-01-20', 100000.00, 5000.00, 105000.00, 'unpaid', '2025-11-14 11:06:16', 0.00, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(4, 'PUR-2024-0004', 4, '2024-02-05', 60000.00, 3000.00, 63000.00, 'paid', '2025-11-14 11:06:16', 0.00, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL),
(5, 'PUR-2024-0005', 5, '2024-02-12', 80000.00, 4000.00, 84000.00, 'partial', '2025-11-14 11:06:16', 0.00, 0.00, 0.00, 0.00, 0.00, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `product_purchase_details`
--

CREATE TABLE `product_purchase_details` (
  `id` int(11) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `product_id` int(11) NOT NULL,
  `quantity` decimal(10,2) NOT NULL,
  `rate` decimal(15,2) NOT NULL,
  `total_amount` decimal(15,2) NOT NULL,
  `discount_pct` decimal(6,3) DEFAULT 0.000,
  `discount_value` decimal(15,2) DEFAULT 0.00,
  `vat_pct` decimal(6,3) DEFAULT 0.000,
  `vat_value` decimal(15,2) DEFAULT 0.00,
  `batch_no` varchar(50) DEFAULT NULL,
  `expiry_date` date DEFAULT NULL,
  `line_total` decimal(15,2) DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_purchase_details`
--

INSERT INTO `product_purchase_details` (`id`, `purchase_id`, `product_id`, `quantity`, `rate`, `total_amount`, `discount_pct`, `discount_value`, `vat_pct`, `vat_value`, `batch_no`, `expiry_date`, `line_total`) VALUES
(1, 1, 1, 20.00, 2000.00, 40000.00, 0.000, 0.00, 0.000, 0.00, NULL, NULL, 0.00),
(2, 1, 2, 10.00, 750.00, 7500.00, 0.000, 0.00, 0.000, 0.00, NULL, NULL, 0.00),
(3, 1, 9, 10.00, 200.00, 2000.00, 0.000, 0.00, 0.000, 0.00, NULL, NULL, 0.00),
(4, 2, 3, 15.00, 4500.00, 67500.00, 0.000, 0.00, 0.000, 0.00, NULL, NULL, 0.00),
(5, 2, 5, 5.00, 1500.00, 7500.00, 0.000, 0.00, 0.000, 0.00, NULL, NULL, 0.00),
(6, 3, 4, 10.00, 11000.00, 110000.00, 0.000, 0.00, 0.000, 0.00, NULL, NULL, 0.00),
(7, 4, 6, 10.00, 3200.00, 32000.00, 0.000, 0.00, 0.000, 0.00, NULL, NULL, 0.00),
(8, 4, 7, 5.00, 7500.00, 37500.00, 0.000, 0.00, 0.000, 0.00, NULL, NULL, 0.00),
(9, 5, 11, 8.00, 9500.00, 76000.00, 0.000, 0.00, 0.000, 0.00, NULL, NULL, 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `product_subgroups`
--

CREATE TABLE `product_subgroups` (
  `id` int(10) UNSIGNED NOT NULL,
  `subgroup_code` varchar(50) NOT NULL,
  `subgroup_name` varchar(255) NOT NULL,
  `group_id` int(10) UNSIGNED DEFAULT NULL,
  `description` text DEFAULT NULL,
  `status` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchased`
--

CREATE TABLE `purchased` (
  `slno` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `qty` decimal(18,3) DEFAULT 0.000,
  `rate` decimal(15,2) DEFAULT 0.00,
  `amount` decimal(15,2) DEFAULT 0.00,
  `sno` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchasem`
--

CREATE TABLE `purchasem` (
  `slno` int(11) NOT NULL,
  `docno` varchar(20) DEFAULT NULL,
  `billno` varchar(20) DEFAULT NULL,
  `suppcode` varchar(20) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `billamt` decimal(15,2) DEFAULT 0.00,
  `pamt` decimal(15,2) DEFAULT 0.00,
  `addamt` decimal(15,2) DEFAULT 0.00,
  `taxamt` decimal(15,2) DEFAULT 0.00,
  `netamt` decimal(15,2) DEFAULT 0.00,
  `ob` decimal(15,2) DEFAULT 0.00,
  `taxperc` decimal(6,3) DEFAULT 0.000,
  `discperc` decimal(6,3) DEFAULT 0.000,
  `discount` decimal(15,2) DEFAULT 0.00,
  `addr` varchar(200) DEFAULT NULL,
  `note` varchar(200) DEFAULT NULL,
  `tdate` date DEFAULT NULL,
  `duedate` date DEFAULT NULL,
  `billtype` varchar(20) DEFAULT NULL,
  `statecode` varchar(20) DEFAULT NULL,
  `mobile` varchar(30) DEFAULT NULL,
  `pan` varchar(30) DEFAULT NULL,
  `counter` varchar(20) DEFAULT NULL,
  `tcsperc` decimal(6,3) DEFAULT 0.000,
  `tcsamt` decimal(15,2) DEFAULT 0.00,
  `pr` char(1) DEFAULT 'P',
  `control` tinyint(4) DEFAULT 1,
  `status` tinyint(4) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchaserd`
--

CREATE TABLE `purchaserd` (
  `slno` int(11) NOT NULL,
  `code` varchar(50) NOT NULL,
  `qty` decimal(18,3) DEFAULT 0.000,
  `rate` decimal(15,2) DEFAULT 0.00,
  `amount` decimal(15,2) DEFAULT 0.00,
  `sno` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `purchaserm`
--

CREATE TABLE `purchaserm` (
  `slno` int(11) NOT NULL,
  `docno` varchar(20) DEFAULT NULL,
  `billno` varchar(20) DEFAULT NULL,
  `suppcode` varchar(20) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `billamt` decimal(15,2) DEFAULT 0.00,
  `ramt` decimal(15,2) DEFAULT 0.00,
  `addamt` decimal(15,2) DEFAULT 0.00,
  `lessamt` decimal(15,2) DEFAULT 0.00,
  `status` tinyint(4) DEFAULT 1,
  `pr` char(1) DEFAULT 'E',
  `control` tinyint(4) DEFAULT 1,
  `tdate` date DEFAULT NULL,
  `ttime` time DEFAULT NULL,
  `rate` decimal(15,2) DEFAULT 0.00,
  `smcode` varchar(20) DEFAULT NULL,
  `round` decimal(15,2) DEFAULT 0.00,
  `netamt` decimal(15,2) DEFAULT 0.00,
  `ic` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `quotation`
--

CREATE TABLE `quotation` (
  `quotation_id` int(11) NOT NULL,
  `quotation_no` varchar(100) NOT NULL,
  `customer_id` int(11) NOT NULL,
  `quotation_date` date NOT NULL,
  `valid_until` date DEFAULT NULL,
  `subtotal` decimal(15,2) NOT NULL,
  `vat` decimal(15,2) DEFAULT 0.00,
  `grand_total` decimal(15,2) NOT NULL,
  `items` text DEFAULT NULL,
  `notes` text DEFAULT NULL,
  `status` enum('pending','converted','rejected') DEFAULT 'pending',
  `converted_invoice_id` int(11) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `quotation`
--

INSERT INTO `quotation` (`quotation_id`, `quotation_no`, `customer_id`, `quotation_date`, `valid_until`, `subtotal`, `vat`, `grand_total`, `items`, `notes`, `status`, `converted_invoice_id`, `created_at`) VALUES
(1, 'QT-2024-0001', 1, '2024-03-01', '2024-03-31', 5000.00, 250.00, 5250.00, '[{\"product_id\":3,\"quantity\":1,\"rate\":5000}]', 'Special offer for new customer', 'pending', NULL, '2025-11-14 11:06:16'),
(2, 'QT-2024-0002', 3, '2024-03-05', '2024-04-05', 15000.00, 750.00, 15750.00, '[{\"product_id\":8,\"quantity\":1,\"rate\":15000}]', 'Premium package quote', 'pending', NULL, '2025-11-14 11:06:16'),
(3, 'QT-2024-0003', 5, '2024-03-10', '2024-04-10', 2750.00, 137.50, 2887.50, '[{\"product_id\":1,\"quantity\":1,\"rate\":2500},{\"product_id\":9,\"quantity\":1,\"rate\":250}]', 'Motor + Travel bundle', 'pending', NULL, '2025-11-14 11:06:16');

-- --------------------------------------------------------

--
-- Table structure for table `receipt`
--

CREATE TABLE `receipt` (
  `receipt_id` int(11) NOT NULL,
  `invoice_id` int(11) DEFAULT NULL,
  `customer_id` int(11) NOT NULL,
  `receipt_date` date NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `payment_method` enum('cash','bank','cheque','pdc') DEFAULT 'cash',
  `cheque_no` varchar(100) DEFAULT NULL,
  `cheque_date` date DEFAULT NULL,
  `bank` varchar(255) DEFAULT NULL,
  `discount` decimal(15,2) DEFAULT 0.00,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `receipt`
--

INSERT INTO `receipt` (`receipt_id`, `invoice_id`, `customer_id`, `receipt_date`, `amount`, `payment_method`, `cheque_no`, `cheque_date`, `bank`, `discount`, `notes`, `created_at`) VALUES
(1, 1, 1, '2024-01-20', 5250.00, 'bank', NULL, NULL, NULL, 0.00, 'Full payment received', '2025-11-14 11:06:16'),
(2, 2, 2, '2024-01-25', 6000.00, 'cash', NULL, NULL, NULL, 100.00, 'Partial payment with discount', '2025-11-14 11:06:16'),
(3, 4, 4, '2024-02-01', 8400.00, 'cheque', NULL, NULL, NULL, 0.00, 'Payment by cheque', '2025-11-14 11:06:16'),
(4, 5, 5, '2024-02-08', 1500.00, 'bank', NULL, NULL, NULL, 50.00, 'Advance payment', '2025-11-14 11:06:16'),
(5, 7, 7, '2024-02-15', 1575.00, 'cash', NULL, NULL, NULL, 0.00, 'Cash payment', '2025-11-14 11:06:16'),
(6, 8, 8, '2024-02-20', 5000.00, 'bank', NULL, NULL, NULL, 0.00, 'First installment', '2025-11-14 11:06:16');

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(191) NOT NULL,
  `description` text DEFAULT NULL,
  `permissions` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `permissions`, `created_at`, `updated_at`) VALUES
(1, 'Admin', 'System Administrator', '{\"all\": true}', '2025-11-14 11:06:16', '2025-11-14 11:06:16'),
(2, 'Manager', 'Branch Manager', '{\"manage_users\": true, \"view_reports\": true}', '2025-11-14 11:06:16', '2025-11-14 11:06:16'),
(3, 'Accountant', 'Accountant', '{\"manage_accounts\": true, \"view_reports\": true}', '2025-11-14 11:06:16', '2025-11-14 11:06:16'),
(4, 'User', 'Regular User', '{\"view_own_data\": true}', '2025-11-14 11:06:16', '2025-11-14 11:06:16');

-- --------------------------------------------------------

--
-- Table structure for table `supplier_information`
--

CREATE TABLE `supplier_information` (
  `supplier_id` int(11) NOT NULL,
  `supplier_name` varchar(255) NOT NULL,
  `supplier_mobile` varchar(20) NOT NULL,
  `supplier_email` varchar(100) DEFAULT NULL,
  `supplier_address_1` text DEFAULT NULL,
  `supplier_address_2` text DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `zip` varchar(20) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  `contact` varchar(100) DEFAULT NULL,
  `credit_limit` decimal(15,2) DEFAULT 0.00,
  `status` tinyint(1) DEFAULT 1,
  `supplier_code` varchar(50) DEFAULT NULL,
  `salesman_code` varchar(50) DEFAULT NULL,
  `fax` varchar(50) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `supplier_information`
--

INSERT INTO `supplier_information` (`supplier_id`, `supplier_name`, `supplier_mobile`, `supplier_email`, `supplier_address_1`, `supplier_address_2`, `city`, `state`, `zip`, `country`, `contact`, `credit_limit`, `status`, `supplier_code`, `salesman_code`, `fax`) VALUES
(1, 'Dubai Insurance Company LLC', '+971-4-1234567', 'info@dubaiinsurance.ae', 'Dubai World Trade Center', NULL, 'Dubai', 'Dubai', NULL, 'UAE', NULL, 500000.00, 1, 'SUP-0001', NULL, NULL),
(2, 'Emirates Insurance Group', '+971-4-2345678', 'sales@emiratesinsurance.ae', 'DIFC Gate Avenue', NULL, 'Dubai', 'Dubai', NULL, 'UAE', NULL, 750000.00, 1, 'SUP-0002', NULL, NULL),
(3, 'Abu Dhabi National Insurance', '+971-2-3456789', 'contact@adnic.ae', 'Al Khaleej Al Arabi Street', NULL, 'Abu Dhabi', 'Abu Dhabi', NULL, 'UAE', NULL, 1000000.00, 1, 'SUP-0003', NULL, NULL),
(4, 'Orient Insurance PJSC', '+971-4-4567890', 'info@orientinsurance.ae', 'Trade Center Road', NULL, 'Dubai', 'Dubai', NULL, 'UAE', NULL, 600000.00, 1, 'SUP-0004', NULL, NULL),
(5, 'Oman Insurance Company', '+971-4-5678901', 'sales@oman-insurance.ae', 'Bur Dubai', NULL, 'Dubai', 'Dubai', NULL, 'UAE', NULL, 800000.00, 1, 'SUP-0005', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `supplier_payment`
--

CREATE TABLE `supplier_payment` (
  `payment_id` int(11) NOT NULL,
  `purchase_id` int(11) DEFAULT NULL,
  `supplier_id` int(11) NOT NULL,
  `payment_date` date NOT NULL,
  `amount` decimal(15,2) NOT NULL,
  `payment_method` enum('cash','bank','cheque','pdc') DEFAULT 'cash',
  `cheque_no` varchar(100) DEFAULT NULL,
  `cheque_date` date DEFAULT NULL,
  `bank` varchar(255) DEFAULT NULL,
  `discount` decimal(15,2) DEFAULT 0.00,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `supplier_payment`
--

INSERT INTO `supplier_payment` (`payment_id`, `purchase_id`, `supplier_id`, `payment_date`, `amount`, `payment_method`, `cheque_no`, `cheque_date`, `bank`, `discount`, `notes`, `created_at`) VALUES
(1, 1, 1, '2024-01-15', 52500.00, 'bank', NULL, NULL, NULL, 0.00, 'Full payment', '2025-11-14 11:06:16'),
(2, 2, 2, '2024-01-20', 40000.00, 'bank', NULL, NULL, NULL, 500.00, 'Partial payment with discount', '2025-11-14 11:06:16'),
(3, 4, 4, '2024-02-10', 63000.00, 'cheque', NULL, NULL, NULL, 0.00, 'Payment by cheque', '2025-11-14 11:06:16'),
(4, 5, 5, '2024-02-18', 50000.00, 'bank', NULL, NULL, NULL, 1000.00, 'First installment', '2025-11-14 11:06:16');

-- --------------------------------------------------------

--
-- Table structure for table `unit`
--

CREATE TABLE `unit` (
  `unit_id` int(11) NOT NULL,
  `unit_name` varchar(100) NOT NULL,
  `unit_short_name` varchar(20) NOT NULL,
  `status` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `unit`
--

INSERT INTO `unit` (`unit_id`, `unit_name`, `unit_short_name`, `status`) VALUES
(1, 'Policy', 'pol', 1),
(2, 'Unit', 'unit', 1),
(3, 'Piece', 'pc', 1),
(4, 'Set', 'set', 1),
(5, 'Package', 'pkg', 1);

-- --------------------------------------------------------

--
-- Table structure for table `userd`
--

CREATE TABLE `userd` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_code` varchar(100) NOT NULL,
  `menu_item` varchar(150) NOT NULL,
  `can_edit` tinyint(1) DEFAULT 1,
  `can_delete` tinyint(1) DEFAULT 1,
  `created_at` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `code` varchar(191) NOT NULL,
  `username` varchar(191) NOT NULL,
  `email` varchar(191) DEFAULT NULL,
  `password` varchar(191) NOT NULL,
  `first_name` varchar(191) DEFAULT NULL,
  `last_name` varchar(191) DEFAULT NULL,
  `role_id` int(10) UNSIGNED DEFAULT NULL,
  `branch_id` int(10) UNSIGNED DEFAULT NULL,
  `usertype` varchar(191) DEFAULT 'USER',
  `phone` varchar(191) DEFAULT NULL,
  `avatar_url` text DEFAULT NULL,
  `status` varchar(191) DEFAULT 'active',
  `last_login` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `code`, `username`, `email`, `password`, `first_name`, `last_name`, `role_id`, `branch_id`, `usertype`, `phone`, `avatar_url`, `status`, `last_login`, `created_at`, `updated_at`) VALUES
(1, 'USR-2025-0001', 'admin', 'admin@example.com', '$2y$10$hIB4Etgi98K5TemqY5i/AuQ2QruojMpbqMyPsUDr9ePs0Fu9Dzq7K', 'Admin', 'User', 1, NULL, 'ADMIN', NULL, NULL, 'active', '2025-11-15 06:52:50', '2025-11-14 11:06:16', '2025-11-15 11:22:50');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accountg`
--
ALTER TABLE `accountg`
  ADD PRIMARY KEY (`grcode`);

--
-- Indexes for table `accountgbs`
--
ALTER TABLE `accountgbs`
  ADD PRIMARY KEY (`hcode`);

--
-- Indexes for table `accounting_bank_reconciliations`
--
ALTER TABLE `accounting_bank_reconciliations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `accounting_credit_notes`
--
ALTER TABLE `accounting_credit_notes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `accounting_debit_notes`
--
ALTER TABLE `accounting_debit_notes`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `accountm`
--
ALTER TABLE `accountm`
  ADD PRIMARY KEY (`accode`),
  ADD KEY `idx_accountm_grcode` (`grcode`),
  ADD KEY `idx_accountm_bshead` (`bshead`);

--
-- Indexes for table `agent`
--
ALTER TABLE `agent`
  ADD PRIMARY KEY (`agent_id`),
  ADD UNIQUE KEY `agent_code` (`agent_code`);

--
-- Indexes for table `agent_commission`
--
ALTER TABLE `agent_commission`
  ADD PRIMARY KEY (`commission_id`),
  ADD KEY `agent_id` (`agent_id`),
  ADD KEY `invoice_id` (`invoice_id`);

--
-- Indexes for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `audit_logs_user_id_foreign` (`user_id`);

--
-- Indexes for table `broker`
--
ALTER TABLE `broker`
  ADD PRIMARY KEY (`broker_id`),
  ADD UNIQUE KEY `broker_code` (`broker_code`);

--
-- Indexes for table `broker_commission`
--
ALTER TABLE `broker_commission`
  ADD PRIMARY KEY (`commission_id`),
  ADD KEY `broker_id` (`broker_id`),
  ADD KEY `invoice_id` (`invoice_id`);

--
-- Indexes for table `category_list`
--
ALTER TABLE `category_list`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `uniq_category_code` (`category_code`);

--
-- Indexes for table `clients`
--
ALTER TABLE `clients`
  ADD PRIMARY KEY (`code`),
  ADD UNIQUE KEY `uniq_clients_agentcode` (`agentcode`),
  ADD KEY `idx_clients_mobile` (`mobile`),
  ADD KEY `idx_clients_id_number` (`id_number`);

--
-- Indexes for table `clientspict`
--
ALTER TABLE `clientspict`
  ADD PRIMARY KEY (`client_code`);

--
-- Indexes for table `clients_advanced`
--
ALTER TABLE `clients_advanced`
  ADD PRIMARY KEY (`client_code`);

--
-- Indexes for table `collection`
--
ALTER TABLE `collection`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_id` (`invoice_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `contra`
--
ALTER TABLE `contra`
  ADD PRIMARY KEY (`contra_id`);

--
-- Indexes for table `customer_information`
--
ALTER TABLE `customer_information`
  ADD PRIMARY KEY (`customer_id`),
  ADD KEY `customer_mobile` (`customer_mobile`);

--
-- Indexes for table `daybook`
--
ALTER TABLE `daybook`
  ADD PRIMARY KEY (`id`),
  ADD KEY `date` (`date`),
  ADD KEY `account_code` (`account_code`),
  ADD KEY `reference` (`reference_type`,`reference_id`);

--
-- Indexes for table `generali`
--
ALTER TABLE `generali`
  ADD PRIMARY KEY (`code`);

--
-- Indexes for table `hr_attendance`
--
ALTER TABLE `hr_attendance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `attendance_date` (`attendance_date`);

--
-- Indexes for table `hr_employees`
--
ALTER TABLE `hr_employees`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_hr_employee_code` (`employee_code`);

--
-- Indexes for table `hr_leave_requests`
--
ALTER TABLE `hr_leave_requests`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hr_payroll_cycles`
--
ALTER TABLE `hr_payroll_cycles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `hr_performance_reviews`
--
ALTER TABLE `hr_performance_reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `employee_id` (`employee_id`),
  ADD KEY `review_period` (`review_period`);

--
-- Indexes for table `hr_salary_structures`
--
ALTER TABLE `hr_salary_structures`
  ADD PRIMARY KEY (`id`),
  ADD KEY `grade` (`grade`);

--
-- Indexes for table `insurance_claims`
--
ALTER TABLE `insurance_claims`
  ADD PRIMARY KEY (`id`),
  ADD KEY `claim_number` (`claim_number`);

--
-- Indexes for table `insurance_commissions`
--
ALTER TABLE `insurance_commissions`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `insurance_endorsements`
--
ALTER TABLE `insurance_endorsements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `policy_number` (`policy_number`);

--
-- Indexes for table `insurance_policies`
--
ALTER TABLE `insurance_policies`
  ADD PRIMARY KEY (`id`),
  ADD KEY `policy_number` (`policy_number`);

--
-- Indexes for table `insurance_premium_collections`
--
ALTER TABLE `insurance_premium_collections`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `insurance_renewals`
--
ALTER TABLE `insurance_renewals`
  ADD PRIMARY KEY (`id`),
  ADD KEY `policy_number` (`policy_number`);

--
-- Indexes for table `insurance_underwriting_reviews`
--
ALTER TABLE `insurance_underwriting_reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `submission_ref` (`submission_ref`);

--
-- Indexes for table `invoice`
--
ALTER TABLE `invoice`
  ADD PRIMARY KEY (`invoice_id`),
  ADD UNIQUE KEY `invoice` (`invoice`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `date` (`date`);

--
-- Indexes for table `invoice_details`
--
ALTER TABLE `invoice_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `invoice_id` (`invoice_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `journal`
--
ALTER TABLE `journal`
  ADD PRIMARY KEY (`journal_id`);

--
-- Indexes for table `opening_balance`
--
ALTER TABLE `opening_balance`
  ADD PRIMARY KEY (`id`),
  ADD KEY `account_code` (`account_code`);

--
-- Indexes for table `payment`
--
ALTER TABLE `payment`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `idx_payment_purchase` (`purchase_id`);

--
-- Indexes for table `pdc`
--
ALTER TABLE `pdc`
  ADD PRIMARY KEY (`pdc_id`),
  ADD KEY `cheque_date` (`cheque_date`),
  ADD KEY `status` (`status`);

--
-- Indexes for table `phonebook`
--
ALTER TABLE `phonebook`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_phonebook_client` (`client_code`);

--
-- Indexes for table `product_groups`
--
ALTER TABLE `product_groups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_group_code` (`group_code`);

--
-- Indexes for table `product_information`
--
ALTER TABLE `product_information`
  ADD PRIMARY KEY (`product_id`),
  ADD UNIQUE KEY `uniq_product_code` (`product_code`),
  ADD KEY `category_id` (`category_id`),
  ADD KEY `unit_id` (`unit_id`);

--
-- Indexes for table `product_purchase`
--
ALTER TABLE `product_purchase`
  ADD PRIMARY KEY (`purchase_id`),
  ADD KEY `supplier_id` (`supplier_id`),
  ADD KEY `purchase_date` (`purchase_date`);

--
-- Indexes for table `product_purchase_details`
--
ALTER TABLE `product_purchase_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `purchase_id` (`purchase_id`),
  ADD KEY `product_id` (`product_id`);

--
-- Indexes for table `product_subgroups`
--
ALTER TABLE `product_subgroups`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_subgroup_code` (`subgroup_code`);

--
-- Indexes for table `purchased`
--
ALTER TABLE `purchased`
  ADD PRIMARY KEY (`slno`,`sno`),
  ADD KEY `idx_purchased_code` (`code`);

--
-- Indexes for table `purchasem`
--
ALTER TABLE `purchasem`
  ADD PRIMARY KEY (`slno`);

--
-- Indexes for table `purchaserd`
--
ALTER TABLE `purchaserd`
  ADD PRIMARY KEY (`slno`,`sno`);

--
-- Indexes for table `purchaserm`
--
ALTER TABLE `purchaserm`
  ADD PRIMARY KEY (`slno`);

--
-- Indexes for table `quotation`
--
ALTER TABLE `quotation`
  ADD PRIMARY KEY (`quotation_id`),
  ADD UNIQUE KEY `quotation_no` (`quotation_no`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `receipt`
--
ALTER TABLE `receipt`
  ADD PRIMARY KEY (`receipt_id`),
  ADD KEY `invoice_id` (`invoice_id`),
  ADD KEY `customer_id` (`customer_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `name` (`name`);

--
-- Indexes for table `supplier_information`
--
ALTER TABLE `supplier_information`
  ADD PRIMARY KEY (`supplier_id`);

--
-- Indexes for table `supplier_payment`
--
ALTER TABLE `supplier_payment`
  ADD PRIMARY KEY (`payment_id`),
  ADD KEY `purchase_id` (`purchase_id`),
  ADD KEY `supplier_id` (`supplier_id`);

--
-- Indexes for table `unit`
--
ALTER TABLE `unit`
  ADD PRIMARY KEY (`unit_id`);

--
-- Indexes for table `userd`
--
ALTER TABLE `userd`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `uniq_user_menu` (`user_code`,`menu_item`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD UNIQUE KEY `username` (`username`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `users_role_id_foreign` (`role_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounting_bank_reconciliations`
--
ALTER TABLE `accounting_bank_reconciliations`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `accounting_credit_notes`
--
ALTER TABLE `accounting_credit_notes`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `accounting_debit_notes`
--
ALTER TABLE `accounting_debit_notes`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `agent`
--
ALTER TABLE `agent`
  MODIFY `agent_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `agent_commission`
--
ALTER TABLE `agent_commission`
  MODIFY `commission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `audit_logs`
--
ALTER TABLE `audit_logs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `broker`
--
ALTER TABLE `broker`
  MODIFY `broker_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `broker_commission`
--
ALTER TABLE `broker_commission`
  MODIFY `commission_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `category_list`
--
ALTER TABLE `category_list`
  MODIFY `category_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `collection`
--
ALTER TABLE `collection`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `contra`
--
ALTER TABLE `contra`
  MODIFY `contra_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customer_information`
--
ALTER TABLE `customer_information`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `daybook`
--
ALTER TABLE `daybook`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `hr_attendance`
--
ALTER TABLE `hr_attendance`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hr_employees`
--
ALTER TABLE `hr_employees`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hr_leave_requests`
--
ALTER TABLE `hr_leave_requests`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hr_payroll_cycles`
--
ALTER TABLE `hr_payroll_cycles`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hr_performance_reviews`
--
ALTER TABLE `hr_performance_reviews`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hr_salary_structures`
--
ALTER TABLE `hr_salary_structures`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_claims`
--
ALTER TABLE `insurance_claims`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_commissions`
--
ALTER TABLE `insurance_commissions`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_endorsements`
--
ALTER TABLE `insurance_endorsements`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_policies`
--
ALTER TABLE `insurance_policies`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_premium_collections`
--
ALTER TABLE `insurance_premium_collections`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_renewals`
--
ALTER TABLE `insurance_renewals`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `insurance_underwriting_reviews`
--
ALTER TABLE `insurance_underwriting_reviews`
  MODIFY `id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `invoice`
--
ALTER TABLE `invoice`
  MODIFY `invoice_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `invoice_details`
--
ALTER TABLE `invoice_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `journal`
--
ALTER TABLE `journal`
  MODIFY `journal_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `opening_balance`
--
ALTER TABLE `opening_balance`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payment`
--
ALTER TABLE `payment`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pdc`
--
ALTER TABLE `pdc`
  MODIFY `pdc_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `phonebook`
--
ALTER TABLE `phonebook`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_groups`
--
ALTER TABLE `product_groups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `product_information`
--
ALTER TABLE `product_information`
  MODIFY `product_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `product_purchase`
--
ALTER TABLE `product_purchase`
  MODIFY `purchase_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `product_purchase_details`
--
ALTER TABLE `product_purchase_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT for table `product_subgroups`
--
ALTER TABLE `product_subgroups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `quotation`
--
ALTER TABLE `quotation`
  MODIFY `quotation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `receipt`
--
ALTER TABLE `receipt`
  MODIFY `receipt_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `supplier_information`
--
ALTER TABLE `supplier_information`
  MODIFY `supplier_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `supplier_payment`
--
ALTER TABLE `supplier_payment`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `unit`
--
ALTER TABLE `unit`
  MODIFY `unit_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `userd`
--
ALTER TABLE `userd`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accountm`
--
ALTER TABLE `accountm`
  ADD CONSTRAINT `fk_accountm_group` FOREIGN KEY (`grcode`) REFERENCES `accountg` (`grcode`) ON DELETE SET NULL,
  ADD CONSTRAINT `fk_accountm_head` FOREIGN KEY (`bshead`) REFERENCES `accountgbs` (`hcode`) ON DELETE SET NULL;

--
-- Constraints for table `audit_logs`
--
ALTER TABLE `audit_logs`
  ADD CONSTRAINT `audit_logs_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
