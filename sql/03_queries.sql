-- =====================================================================
-- Bank Management System
-- File: 03_queries.sql
-- Purpose: Demonstrates SQL, JOINs, aggregate functions, GROUP BY,
--          HAVING, subqueries, CASE, and date/time operations.
-- All queries run against the schema + data from files 01 and 02.
-- =====================================================================

-- =====================================================================
-- SECTION A — BASIC SELECTS
-- =====================================================================

-- 1. Display all customers
SELECT * FROM customers ORDER BY customer_id;

-- 2. Display all accounts
SELECT * FROM accounts ORDER BY account_id;

-- 3. Display all loans
SELECT * FROM loans ORDER BY loan_id;

-- 4. Display transaction history (most recent first)
SELECT * FROM transactions ORDER BY transaction_date DESC;

-- =====================================================================
-- SECTION B — JOINS
-- =====================================================================

-- 5. Show customers with their accounts
SELECT c.customer_id, c.first_name, c.last_name, a.account_number, a.account_type, a.balance
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
ORDER BY c.customer_id;

-- 6. Show account details with customer names
SELECT a.account_number, a.account_type, a.balance, c.first_name || ' ' || c.last_name AS customer_name
FROM accounts a
INNER JOIN customers c ON c.customer_id = a.customer_id
ORDER BY a.account_number;

-- 7. Show transaction details with account/customer information
SELECT t.transaction_id, t.transaction_type, t.amount, t.transaction_status,
       a.account_number, c.first_name || ' ' || c.last_name AS customer_name
FROM transactions t
JOIN accounts a ON a.account_id = t.account_id
JOIN customers c ON c.customer_id = a.customer_id
ORDER BY t.transaction_date DESC;

-- 8. Find accounts by account type (example: Savings)
SELECT * FROM accounts WHERE account_type = 'Savings' ORDER BY balance DESC;

-- 9. Find customers with multiple accounts
SELECT c.customer_id, c.first_name, c.last_name, COUNT(a.account_id) AS account_count
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(a.account_id) > 1
ORDER BY account_count DESC;

-- 10. Count accounts per customer (all customers, including those with 1)
SELECT c.customer_id, c.first_name, c.last_name, COUNT(a.account_id) AS account_count
FROM customers c
LEFT JOIN accounts a ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY account_count DESC;

-- =====================================================================
-- SECTION C — AGGREGATES
-- =====================================================================

-- 11. Count customers by account type
SELECT account_type, COUNT(*) AS num_accounts
FROM accounts
GROUP BY account_type;

-- 12. Calculate total balance by account type
SELECT account_type, SUM(balance) AS total_balance
FROM accounts
GROUP BY account_type
ORDER BY total_balance DESC;

-- 13. Calculate total balance held by each customer
SELECT c.customer_id, c.first_name, c.last_name, SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_balance DESC;

-- 14. Find highest-balance accounts (top 5)
SELECT account_number, account_type, balance
FROM accounts
ORDER BY balance DESC
LIMIT 5;

-- 15. Find lowest-balance accounts (bottom 5)
SELECT account_number, account_type, balance
FROM accounts
ORDER BY balance ASC
LIMIT 5;

-- 16. Calculate total deposits (completed only)
SELECT SUM(amount) AS total_deposits
FROM transactions
WHERE transaction_type = 'Deposit' AND transaction_status = 'Completed';

-- 17. Calculate total withdrawals (completed only)
SELECT SUM(amount) AS total_withdrawals
FROM transactions
WHERE transaction_type = 'Withdrawal' AND transaction_status = 'Completed';

-- 18. Calculate transaction totals by type
SELECT transaction_type, COUNT(*) AS num_transactions, SUM(amount) AS total_amount
FROM transactions
GROUP BY transaction_type
ORDER BY total_amount DESC;

-- 19. Calculate transaction totals by account
SELECT a.account_number, COUNT(t.transaction_id) AS num_transactions, SUM(t.amount) AS total_amount
FROM accounts a
JOIN transactions t ON t.account_id = a.account_id
GROUP BY a.account_number
ORDER BY total_amount DESC;

-- 20. Find customers with the highest transaction activity (top 5 by count)
SELECT c.first_name, c.last_name, COUNT(t.transaction_id) AS num_transactions
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
JOIN transactions t ON t.account_id = a.account_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY num_transactions DESC
LIMIT 5;

-- =====================================================================
-- SECTION D — LOANS
-- =====================================================================

-- 21. Find loans by status (example: Active)
SELECT * FROM loans WHERE loan_status = 'Active' ORDER BY loan_amount DESC;

-- 22. Calculate total loan amounts
SELECT SUM(loan_amount) AS total_loans_issued FROM loans;

-- 23. Calculate average loan amount
SELECT ROUND(AVG(loan_amount), 2) AS average_loan_amount FROM loans;

-- 24. Find customers with active loans
SELECT c.first_name, c.last_name, l.loan_type, l.loan_amount, l.interest_rate
FROM customers c
JOIN loans l ON l.customer_id = c.customer_id
WHERE l.loan_status = 'Active'
ORDER BY l.loan_amount DESC;

-- 25. Calculate total loans per customer
SELECT c.customer_id, c.first_name, c.last_name, COUNT(l.loan_id) AS num_loans, SUM(l.loan_amount) AS total_loan_amount
FROM customers c
JOIN loans l ON l.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_loan_amount DESC;

-- =====================================================================
-- SECTION E — JOIN VARIATIONS
-- =====================================================================

-- 26. INNER JOIN — only customers that have at least one loan
SELECT c.first_name, c.last_name, l.loan_type, l.loan_status
FROM customers c
INNER JOIN loans l ON l.customer_id = c.customer_id
ORDER BY c.last_name;

-- 27. LEFT JOIN — all customers, with loan info if it exists (NULL if not)
SELECT c.first_name, c.last_name, l.loan_type, l.loan_status
FROM customers c
LEFT JOIN loans l ON l.customer_id = c.customer_id
ORDER BY c.last_name;

-- 28. Multiple-table JOIN — customer, account, and transaction together
SELECT c.first_name, c.last_name, a.account_number, t.transaction_type, t.amount, t.transaction_date
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
JOIN transactions t ON t.account_id = a.account_id
WHERE t.transaction_status = 'Completed'
ORDER BY t.transaction_date DESC;

-- =====================================================================
-- SECTION F — GROUP BY / HAVING / AGGREGATE FUNCTIONS
-- =====================================================================

-- 29. GROUP BY — number of transactions per status
SELECT transaction_status, COUNT(*) AS num_transactions
FROM transactions
GROUP BY transaction_status;

-- 30. HAVING — customers whose combined balance exceeds 5000
SELECT c.first_name, c.last_name, SUM(a.balance) AS total_balance
FROM customers c
JOIN accounts a ON a.customer_id = c.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING SUM(a.balance) > 5000
ORDER BY total_balance DESC;

-- 31. COUNT — total number of transactions in the system
SELECT COUNT(*) AS total_transactions FROM transactions;

-- 32. SUM — total money currently held across all accounts
SELECT SUM(balance) AS total_bank_holdings FROM accounts;

-- 33. AVG — average account balance by account type
SELECT account_type, ROUND(AVG(balance), 2) AS avg_balance
FROM accounts
GROUP BY account_type;

-- 34. MIN — smallest transaction amount recorded
SELECT MIN(amount) AS smallest_transaction FROM transactions;

-- 35. MAX — largest transaction amount recorded
SELECT MAX(amount) AS largest_transaction FROM transactions;

-- =====================================================================
-- SECTION G — CASE, SUBQUERIES, DATE/TIME
-- =====================================================================

-- 36. CASE — classify accounts by balance tier
SELECT account_number, balance,
    CASE
        WHEN balance >= 5000 THEN 'High Balance'
        WHEN balance >= 1000 THEN 'Medium Balance'
        ELSE 'Low Balance'
    END AS balance_tier
FROM accounts
ORDER BY balance DESC;

-- 37. Subquery — customers whose total balance is above the bank's average
SELECT c.first_name, c.last_name, cust_totals.total_balance
FROM customers c
JOIN (
    SELECT customer_id, SUM(balance) AS total_balance
    FROM accounts
    GROUP BY customer_id
) cust_totals ON cust_totals.customer_id = c.customer_id
WHERE cust_totals.total_balance > (
    SELECT AVG(balance) FROM accounts
)
ORDER BY cust_totals.total_balance DESC;

-- 38. Date/Time functions — monthly transaction volume in 2024
SELECT
    TO_CHAR(transaction_date, 'YYYY-MM') AS month,
    COUNT(*) AS num_transactions,
    SUM(amount) AS total_amount
FROM transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2024
GROUP BY TO_CHAR(transaction_date, 'YYYY-MM')
ORDER BY month;

-- Bonus: loans nearing their end date (within 5 years from today)
SELECT c.first_name, c.last_name, l.loan_type, l.end_date,
       AGE(l.end_date, CURRENT_DATE) AS time_remaining
FROM loans l
JOIN customers c ON c.customer_id = l.customer_id
WHERE l.loan_status = 'Active' AND l.end_date <= CURRENT_DATE + INTERVAL '5 years'
ORDER BY l.end_date;
