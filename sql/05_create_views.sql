CREATE VIEW account_summary_view AS
SELECT
    a.account_number,
    c.first_name || ' ' || c.last_name AS customer_name,
    a.account_type,
    a.balance,
    a.status
FROM accounts a
JOIN customers c ON c.customer_id = a.customer_id;


