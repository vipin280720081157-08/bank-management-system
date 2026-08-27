-- ---------------------------------------------------------------------
-- Table: customers
-- Stores the people who hold accounts and/or loans at the bank.
-- ---------------------------------------------------------------------
CREATE TABLE customers (
    customer_id     SERIAL PRIMARY KEY,
    first_name      VARCHAR(50)  NOT NULL,
    last_name       VARCHAR(50)  NOT NULL,
    email           VARCHAR(100) NOT NULL UNIQUE,
    phone           VARCHAR(20)  NOT NULL UNIQUE,
    date_of_birth   DATE         NOT NULL,
    address         VARCHAR(200),
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT chk_customer_dob CHECK (date_of_birth <= CURRENT_DATE - INTERVAL '18 years')
);

-- ---------------------------------------------------------------------
-- Table: accounts
-- Each account belongs to exactly one customer.
-- One customer can have MULTIPLE accounts (one-to-many).
-- ---------------------------------------------------------------------
CREATE TABLE accounts (
    account_id      SERIAL PRIMARY KEY,
    customer_id     INTEGER      NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    account_number  VARCHAR(20)  NOT NULL UNIQUE,
    account_type    VARCHAR(20)  NOT NULL CHECK (account_type IN ('Savings', 'Checking')),
    balance         NUMERIC(14,2) NOT NULL DEFAULT 0.00 CHECK (balance >= 0),
    status          VARCHAR(20)  NOT NULL DEFAULT 'Active' CHECK (status IN ('Active', 'Inactive', 'Closed')),
    opened_date     DATE         NOT NULL DEFAULT CURRENT_DATE,
    created_at      TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE INDEX idx_accounts_customer_id ON accounts(customer_id);

-- ---------------------------------------------------------------------
-- Table: transactions
-- Every transaction is linked to one account (the account acted upon).
-- For transfers, related_account_id records the "other side" of the
-- transfer (the account money moved to/from), so a single account's
-- history can still be reconstructed without a separate transfer table.
-- ---------------------------------------------------------------------
CREATE TABLE transactions (
    transaction_id      SERIAL PRIMARY KEY,
    account_id          INTEGER      NOT NULL REFERENCES accounts(account_id) ON DELETE CASCADE,
    related_account_id  INTEGER      REFERENCES accounts(account_id) ON DELETE SET NULL,
    transaction_type    VARCHAR(20)  NOT NULL CHECK (transaction_type IN ('Deposit', 'Withdrawal', 'Transfer')),
    amount              NUMERIC(14,2) NOT NULL CHECK (amount > 0),
    transaction_status  VARCHAR(20)  NOT NULL DEFAULT 'Completed' CHECK (transaction_status IN ('Completed', 'Pending', 'Failed')),
    transaction_date    TIMESTAMP    NOT NULL DEFAULT CURRENT_TIMESTAMP,
    description         VARCHAR(200),

    CONSTRAINT chk_related_account_differs CHECK (
        related_account_id IS NULL OR related_account_id <> account_id
    )
);

CREATE INDEX idx_transactions_account_id ON transactions(account_id);
CREATE INDEX idx_transactions_date ON transactions(transaction_date);

-- ---------------------------------------------------------------------
-- Table: loans
-- Each loan belongs to exactly one customer.
-- One customer can have MULTIPLE loans (one-to-many).
-- ---------------------------------------------------------------------
CREATE TABLE loans (
    loan_id         SERIAL PRIMARY KEY,
    customer_id     INTEGER      NOT NULL REFERENCES customers(customer_id) ON DELETE CASCADE,
    loan_type       VARCHAR(30)  NOT NULL CHECK (loan_type IN ('Personal', 'Home', 'Auto', 'Education', 'Business')),
    loan_amount     NUMERIC(14,2) NOT NULL CHECK (loan_amount > 0),
    interest_rate   NUMERIC(5,2)  NOT NULL CHECK (interest_rate >= 0 AND interest_rate <= 100),
    loan_status     VARCHAR(20)  NOT NULL DEFAULT 'Pending' CHECK (loan_status IN ('Pending', 'Active', 'Paid Off', 'Defaulted')),
    start_date      DATE         NOT NULL,
    end_date        DATE,

    CONSTRAINT chk_loan_dates CHECK (end_date IS NULL OR end_date > start_date)
);

CREATE INDEX idx_loans_customer_id ON loans(customer_id);

-- =====================================================================
-- Relationship summary
-- =====================================================================
-- customers (1) ----< (many) accounts        via accounts.customer_id
-- accounts  (1) ----< (many) transactions     via transactions.account_id
-- accounts  (1) ----< (many) transactions     via transactions.related_account_id (transfers only, optional)
-- customers (1) ----< (many) loans            via loans.customer_id
-- =====================================================================
