-- =====================================================================
-- Bank Management System
-- File: 02_insert_data.sql
-- Purpose: Inserts realistic FICTIONAL sample data for customers,
--          accounts, transactions, and loans.
-- =====================================================================
-- NOTE: All names, emails, phone numbers, account numbers, and
-- financial figures below are fictional and created for demonstration
-- purposes only. Run this AFTER 01_create_tables.sql.
-- =====================================================================

-- ---------------------------------------------------------------------
-- customers (15 rows)
-- ---------------------------------------------------------------------
INSERT INTO customers (first_name, last_name, email, phone, date_of_birth, address) VALUES
('Alex',   'Carter',   'alex.carter@example.com',    '+1-555-0101', '1988-03-14', '12 Maple Street, Springfield'),
('Emma',   'Wilson',   'emma.wilson@example.com',    '+1-555-0102', '1992-07-22', '45 Oak Avenue, Riverdale'),
('Daniel', 'Brooks',   'daniel.brooks@example.com',  '+1-555-0103', '1985-11-05', '78 Pine Road, Lakeview'),
('Sophie', 'Miller',   'sophie.miller@example.com',  '+1-555-0104', '1995-02-18', '23 Cedar Lane, Brookfield'),
('James',  'Anderson', 'james.anderson@example.com', '+1-555-0105', '1979-09-30', '9 Birch Court, Hillcrest'),
('Olivia', 'Bennett',  'olivia.bennett@example.com', '+1-555-0106', '1990-05-12', '56 Elm Street, Fairview'),
('Noah',   'Parker',   'noah.parker@example.com',    '+1-555-0107', '1998-01-27', '31 Willow Way, Greendale'),
('Grace',  'Thompson', 'grace.thompson@example.com', '+1-555-0108', '1983-08-09', '64 Aspen Drive, Sunnyvale'),
('Ethan',  'Collins',  'ethan.collins@example.com',  '+1-555-0109', '1991-12-03', '17 Chestnut Ave, Clearwater'),
('Mia',    'Davis',    'mia.davis@example.com',      '+1-555-0110', '1996-04-25', '82 Poplar Street, Westfield'),
('Lucas',  'Martin',   'lucas.martin@example.com',   '+1-555-0111', '1987-06-19', '5 Magnolia Blvd, Eastwood'),
('Chloe',  'Adams',    'chloe.adams@example.com',    '+1-555-0112', '1993-10-08', '40 Spruce Street, Northgate'),
('Ryan',   'Cooper',   'ryan.cooper@example.com',    '+1-555-0113', '1982-02-14', '27 Walnut Lane, Southport'),
('Lily',   'Morgan',   'lily.morgan@example.com',    '+1-555-0114', '1994-09-21', '61 Sycamore Rd, Millbrook'),
('Henry',  'Walker',   'henry.walker@example.com',   '+1-555-0115', '1986-07-03', '14 Redwood Ave, Oakdale');

-- ---------------------------------------------------------------------
-- accounts (18 rows) - some customers hold more than one account
-- customer_id 1  (Alex Carter)   -> 2 accounts
-- customer_id 3  (Daniel Brooks) -> 2 accounts
-- customer_id 6  (Olivia Bennett)-> 2 accounts
-- everyone else  -> 1 account
-- ---------------------------------------------------------------------
INSERT INTO accounts (customer_id, account_number, account_type, balance, status, opened_date) VALUES
(1,  'ACC100001', 'Savings',  5200.00, 'Active', '2021-01-10'),
(1,  'ACC100002', 'Checking', 1875.50, 'Active', '2022-03-05'),
(2,  'ACC100003', 'Checking', 3120.75, 'Active', '2020-11-18'),
(3,  'ACC100004', 'Savings',  8600.00, 'Active', '2019-06-22'),
(3,  'ACC100005', 'Checking',  450.25, 'Active', '2023-02-14'),
(4,  'ACC100006', 'Savings',  2200.00, 'Active', '2022-08-30'),
(5,  'ACC100007', 'Checking', 9800.40, 'Active', '2018-04-11'),
(6,  'ACC100008', 'Savings',  1500.00, 'Active', '2021-09-09'),
(6,  'ACC100009', 'Checking', 2750.60, 'Inactive', '2020-01-25'),
(7,  'ACC100010', 'Checking',  680.00, 'Active', '2023-05-19'),
(8,  'ACC100011', 'Savings',  12400.00, 'Active', '2017-12-01'),
(9,  'ACC100012', 'Checking', 3050.00, 'Active', '2022-10-07'),
(10, 'ACC100013', 'Savings',  975.30, 'Active', '2023-01-15'),
(11, 'ACC100014', 'Checking', 4300.00, 'Active', '2019-03-28'),
(12, 'ACC100015', 'Savings',  6100.00, 'Active', '2021-07-16'),
(13, 'ACC100016', 'Checking', 210.00,  'Closed', '2018-09-02'),
(14, 'ACC100017', 'Savings',  7450.90, 'Active', '2020-05-23'),
(15, 'ACC100018', 'Checking', 1980.00, 'Active', '2022-12-11');

-- ---------------------------------------------------------------------
-- transactions (36 rows) covering Deposit, Withdrawal, Transfer
-- and Completed, Pending, Failed statuses across varied dates
-- ---------------------------------------------------------------------
INSERT INTO transactions (account_id, related_account_id, transaction_type, amount, transaction_status, transaction_date, description) VALUES
(1,  NULL, 'Deposit',    1000.00, 'Completed', '2024-01-05 09:15:00', 'Salary deposit'),
(1,  NULL, 'Withdrawal',  200.00, 'Completed', '2024-01-10 14:30:00', 'ATM withdrawal'),
(2,  NULL, 'Deposit',     500.00, 'Completed', '2024-01-12 11:00:00', 'Cash deposit'),
(2,  1,    'Transfer',    150.00, 'Completed', '2024-01-15 16:45:00', 'Transfer to savings'),
(1,  2,    'Transfer',    150.00, 'Completed', '2024-01-15 16:45:00', 'Transfer from checking'),
(3,  NULL, 'Deposit',     800.00, 'Completed', '2024-01-18 10:20:00', 'Freelance payment'),
(3,  NULL, 'Withdrawal',  120.00, 'Completed', '2024-01-20 13:10:00', 'Grocery withdrawal'),
(4,  NULL, 'Deposit',    2000.00, 'Completed', '2024-01-22 08:50:00', 'Bonus deposit'),
(5,  NULL, 'Withdrawal',  300.00, 'Completed', '2024-01-25 17:05:00', 'Rent payment'),
(6,  NULL, 'Deposit',     450.00, 'Completed', '2024-02-01 09:40:00', 'Salary deposit'),
(7,  NULL, 'Withdrawal',  600.00, 'Completed', '2024-02-03 12:15:00', 'Utility bill payment'),
(8,  NULL, 'Deposit',     900.00, 'Pending',   '2024-02-05 15:00:00', 'Pending check deposit'),
(9,  NULL, 'Withdrawal',   80.00, 'Completed', '2024-02-07 10:30:00', 'ATM withdrawal'),
(10, NULL, 'Deposit',     250.00, 'Completed', '2024-02-09 11:45:00', 'Cash deposit'),
(11, NULL, 'Deposit',    3000.00, 'Completed', '2024-02-11 09:00:00', 'Investment payout'),
(11, NULL, 'Withdrawal',  500.00, 'Completed', '2024-02-14 14:20:00', 'Home repair payment'),
(12, NULL, 'Deposit',     700.00, 'Completed', '2024-02-16 13:35:00', 'Salary deposit'),
(13, NULL, 'Withdrawal',   50.00, 'Failed',    '2024-02-18 16:10:00', 'Insufficient funds'),
(14, NULL, 'Deposit',    1200.00, 'Completed', '2024-02-20 10:05:00', 'Salary deposit'),
(15, NULL, 'Withdrawal',  400.00, 'Completed', '2024-02-22 12:50:00', 'Loan repayment'),
(16, NULL, 'Deposit',      75.00, 'Completed', '2024-02-24 09:25:00', 'Refund credit'),
(17, NULL, 'Deposit',    1500.00, 'Completed', '2024-03-01 08:15:00', 'Salary deposit'),
(18, NULL, 'Withdrawal',  220.00, 'Completed', '2024-03-03 11:40:00', 'Online purchase'),
(4,  6,    'Transfer',    300.00, 'Completed', '2024-03-05 15:30:00', 'Transfer to Sophie Miller'),
(6,  4,    'Transfer',    300.00, 'Completed', '2024-03-05 15:30:00', 'Transfer from Daniel Brooks'),
(7,  NULL, 'Withdrawal', 1000.00, 'Completed', '2024-03-08 10:00:00', 'Car maintenance'),
(8,  NULL, 'Withdrawal',  150.00, 'Completed', '2024-03-10 13:20:00', 'Grocery shopping'),
(9,  NULL, 'Deposit',     600.00, 'Completed', '2024-03-12 09:55:00', 'Salary deposit'),
(10, NULL, 'Withdrawal',   90.00, 'Pending',   '2024-03-14 14:10:00', 'Subscription payment'),
(12, NULL, 'Withdrawal',  200.00, 'Completed', '2024-03-16 16:00:00', 'Restaurant payment'),
(14, NULL, 'Withdrawal',  350.00, 'Completed', '2024-03-18 12:30:00', 'Insurance payment'),
(17, NULL, 'Withdrawal',  480.00, 'Completed', '2024-03-20 11:15:00', 'Travel booking'),
(1,  NULL, 'Deposit',    2200.00, 'Completed', '2024-03-22 09:05:00', 'Salary deposit'),
(3,  NULL, 'Deposit',     650.00, 'Completed', '2024-03-24 10:45:00', 'Client payment'),
(11, NULL, 'Deposit',     420.00, 'Failed',    '2024-03-26 13:50:00', 'Bounced check deposit'),
(18, NULL, 'Deposit',     900.00, 'Completed', '2024-03-28 15:25:00', 'Salary deposit');

-- ---------------------------------------------------------------------
-- loans (10 rows) covering different types and statuses
-- ---------------------------------------------------------------------
INSERT INTO loans (customer_id, loan_type, loan_amount, interest_rate, loan_status, start_date, end_date) VALUES
(1,  'Home',      150000.00, 4.25, 'Active',    '2021-06-01', '2041-06-01'),
(2,  'Auto',       22000.00, 6.10, 'Active',    '2022-09-15', '2027-09-15'),
(3,  'Personal',    8000.00, 9.50, 'Paid Off',  '2019-02-10', '2022-02-10'),
(5,  'Business',   45000.00, 7.75, 'Active',    '2020-01-20', '2028-01-20'),
(7,  'Education',  18000.00, 5.00, 'Active',    '2023-08-01', '2030-08-01'),
(8,  'Home',      210000.00, 4.60, 'Active',    '2018-03-12', '2038-03-12'),
(9,  'Personal',    5000.00, 10.25, 'Defaulted', '2021-11-05', '2023-11-05'),
(11, 'Auto',       16500.00, 6.40, 'Paid Off',  '2017-05-22', '2022-05-22'),
(12, 'Personal',    3000.00, 8.90, 'Pending',   '2024-04-01', NULL),
(14, 'Business',   60000.00, 7.20, 'Active',    '2022-02-18', '2029-02-18');
