USE bank_management;

-- 1. List all customers and their accounts
SELECT
    c.customer_id,
    c.full_name,
    c.phone,
    a.account_number,
    a.account_type,
    a.balance
FROM customers c
LEFT JOIN accounts a ON c.customer_id = a.customer_id
ORDER BY c.customer_id;

-- 2. Find an account by account number
SELECT
    a.account_number,
    c.full_name,
    a.account_type,
    a.balance
FROM accounts a
JOIN customers c ON a.customer_id = c.customer_id
WHERE a.account_number = 'PK00100001';

-- 3. Add a customer
INSERT INTO customers (full_name, phone, email, address)
VALUES ('Hassan Ahmed', '03221234567', 'hassan@example.com', 'Karachi');

-- 4. Add an account for customer 3
INSERT INTO accounts (customer_id, account_number, account_type, balance)
VALUES (3, 'PK00100003', 'Savings', 10000.00);

-- 5. Deposit money and record the transaction
START TRANSACTION;

UPDATE accounts
SET balance = balance + 5000.00
WHERE account_id = 1;

INSERT INTO transactions (account_id, transaction_type, amount, description)
VALUES (1, 'Deposit', 5000.00, 'Cash deposit');

COMMIT;

-- 6. Withdraw money safely
START TRANSACTION;

UPDATE accounts
SET balance = balance - 2000.00
WHERE account_id = 1
  AND balance >= 2000.00;

-- Check affected rows before committing in a real application.
INSERT INTO transactions (account_id, transaction_type, amount, description)
VALUES (1, 'Withdrawal', 2000.00, 'Cash withdrawal');

COMMIT;

-- 7. Transaction history
SELECT
    t.transaction_id,
    a.account_number,
    t.transaction_type,
    t.amount,
    t.transaction_time,
    t.description
FROM transactions t
JOIN accounts a ON t.account_id = a.account_id
WHERE a.account_number = 'PK00100001'
ORDER BY t.transaction_time DESC;

-- 8. Update customer information
UPDATE customers
SET phone = '03009998877'
WHERE customer_id = 1;

-- 9. Update an account type
UPDATE accounts
SET account_type = 'Current'
WHERE account_id = 1;

-- 10. Delete a customer is intentionally restricted while accounts exist.
-- Delete dependent accounts/transactions only according to your institution's rules.
