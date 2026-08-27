-- =====================================================================
-- Bank Management System
-- File: 04_transactions.sql
-- Purpose: Demonstrates PostgreSQL database transactions and how they
--          relate to the ACID properties (Atomicity, Consistency,
--          Isolation, Durability).
-- =====================================================================
-- IMPORTANT: Some examples below CHANGE DATA (balances). Read the
-- comment above each example before running it. The pgAdmin guide in
-- the README explains which ones are safe to re-run.
-- =====================================================================


-- =====================================================================
-- EXAMPLE 1 — Successful transfer (CHANGES DATA)
-- Transfers $200 from account_id 1 (Alex Carter - Savings) to
-- account_id 3 (Emma Wilson - Checking).
-- Both balance updates and both transaction log entries either all
-- happen together, or none of them do.
-- =====================================================================
BEGIN;

UPDATE accounts
SET balance = balance - 200.00
WHERE account_id = 1;

UPDATE accounts
SET balance = balance + 200.00
WHERE account_id = 3;

INSERT INTO transactions (account_id, related_account_id, transaction_type, amount, transaction_status, description)
VALUES (1, 3, 'Transfer', 200.00, 'Completed', 'Transfer out to Emma Wilson');

INSERT INTO transactions (account_id, related_account_id, transaction_type, amount, transaction_status, description)
VALUES (3, 1, 'Transfer', 200.00, 'Completed', 'Transfer in from Alex Carter');

COMMIT;

-- What happened: both UPDATE statements and both INSERT statements were
-- grouped into a single transaction. Because we ended with COMMIT,
-- PostgreSQL guarantees all four statements were saved together.


-- =====================================================================
-- EXAMPLE 2 — ROLLBACK (SAFE to run repeatedly — no permanent change)
-- Shows that changes inside an open transaction can be undone
-- completely with ROLLBACK, restoring the original balance.
-- =====================================================================

-- Check the balance before:
SELECT account_id, balance FROM accounts WHERE account_id = 1;

BEGIN;

UPDATE accounts
SET balance = balance - 1000.00
WHERE account_id = 1;

-- Check the balance INSIDE the open transaction (it looks changed here):
SELECT account_id, balance FROM accounts WHERE account_id = 1;

ROLLBACK;

-- Check the balance after ROLLBACK — it is restored to the original value:
SELECT account_id, balance FROM accounts WHERE account_id = 1;

-- What happened: the UPDATE was never committed, so ROLLBACK discarded
-- it entirely. The balance is exactly what it was before BEGIN.


-- =====================================================================
-- EXAMPLE 3 — Transaction failure due to a constraint (SAFE to run)
-- Attempts to withdraw more money than an account actually holds.
-- The accounts.balance CHECK (balance >= 0) constraint blocks this,
-- PostgreSQL raises an error, and the transaction cannot be committed.
-- =====================================================================
BEGIN;

-- account_id 13 has a modest balance (975.30). This tries to overdraw it
-- by withdrawing far more than it holds:
UPDATE accounts
SET balance = balance - 100000.00
WHERE account_id = 13;
-- ^ This statement will FAIL with:
--   ERROR: new row for relation "accounts" violates check constraint "accounts_balance_check"

-- Because the statement above failed, PostgreSQL has already put this
-- transaction into an error state. Run ROLLBACK to close it cleanly:
ROLLBACK;

-- Check the balance — unchanged, because the failed statement was
-- never applied:
SELECT account_id, balance FROM accounts WHERE account_id = 13;


-- =====================================================================
-- EXAMPLE 4 — Atomic transfer with application-style safety checks
-- (CHANGES DATA if it succeeds)
-- Demonstrates a transfer treated as ONE atomic unit: debit account A,
-- credit account B, log both transaction rows, and only COMMIT if
-- every step succeeds. If any step fails, the whole block is rolled
-- back and the database is left exactly as it was.
-- =====================================================================
BEGIN;

-- Step 1: Debit account 7 (James Anderson) by $150
UPDATE accounts
SET balance = balance - 150.00
WHERE account_id = 7 AND balance >= 150.00;  -- guard: only debit if funds are sufficient

-- Step 2: Confirm the debit actually happened (defensive check).
-- In an application, this row count would be checked in code; here we
-- simply trust the WHERE guard above and the balance CHECK constraint
-- as the database-level safety net.

-- Step 3: Credit account 9 (Ethan Collins) by $150
UPDATE accounts
SET balance = balance + 150.00
WHERE account_id = 9;

-- Step 4: Log both sides of the transfer
INSERT INTO transactions (account_id, related_account_id, transaction_type, amount, transaction_status, description)
VALUES (7, 9, 'Transfer', 150.00, 'Completed', 'Transfer out to Ethan Collins');

INSERT INTO transactions (account_id, related_account_id, transaction_type, amount, transaction_status, description)
VALUES (9, 7, 'Transfer', 150.00, 'Completed', 'Transfer in from James Anderson');

-- Only reached if every statement above succeeded without error:
COMMIT;

-- If any step had failed (e.g. a CHECK constraint violation), none of
-- the changes would be visible — you would run ROLLBACK instead of
-- COMMIT, and the accounts/transactions tables would remain untouched.


-- =====================================================================
-- HOW THESE EXAMPLES RELATE TO ACID
-- =====================================================================
-- Atomicity:
--   Examples 1 and 4 group multiple UPDATE/INSERT statements into one
--   transaction. PostgreSQL applies ALL of them or NONE of them.
--
-- Consistency:
--   The accounts.balance CHECK (balance >= 0) constraint (Example 3)
--   stops the database from ever reaching an invalid state, such as a
--   negative balance, even mid-transaction.
--
-- Isolation:
--   While a transaction is open (between BEGIN and COMMIT/ROLLBACK),
--   other sessions do not see its uncommitted changes. PostgreSQL's
--   default "Read Committed" isolation level enforces this.
--
-- Durability:
--   Once COMMIT succeeds (Examples 1 and 4), PostgreSQL has written
--   the change to disk (via its write-ahead log), so the update
--   survives even if the server restarts immediately afterward.
--
-- NOTE: Simply wrapping statements in BEGIN/COMMIT does not, by
-- itself, guarantee every ACID property in every scenario — it relies
-- on PostgreSQL's underlying transaction engine, correctly designed
-- constraints, and appropriate isolation levels working together, as
-- shown in the examples above.
-- =====================================================================
