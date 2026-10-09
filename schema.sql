-- Bank Management System
-- MySQL 8.x

CREATE DATABASE IF NOT EXISTS bank_management;
USE bank_management;

DROP PROCEDURE IF EXISTS deposit_funds;
DROP PROCEDURE IF EXISTS withdraw_funds;

DROP TABLE IF EXISTS transactions;
DROP TABLE IF EXISTS accounts;
DROP TABLE IF EXISTS customers;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL UNIQUE,
    email VARCHAR(100) UNIQUE,
    address VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE accounts (
    account_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    account_number VARCHAR(20) NOT NULL UNIQUE,
    account_type ENUM('Savings', 'Current') NOT NULL,
    balance DECIMAL(12,2) NOT NULL DEFAULT 0.00,
    CONSTRAINT chk_nonnegative_balance CHECK (balance >= 0),
    opened_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
);

CREATE TABLE transactions (
    transaction_id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    transaction_type ENUM('Deposit', 'Withdrawal') NOT NULL,
    amount DECIMAL(12,2) NOT NULL,
    transaction_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    description VARCHAR(255),
    FOREIGN KEY (account_id) REFERENCES accounts(account_id)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CHECK (amount > 0)
);

CREATE INDEX idx_accounts_customer ON accounts(customer_id);
CREATE INDEX idx_transactions_account ON transactions(account_id);

-- Safe account operations. These procedures keep balances and transaction
-- history consistent, even when an operation fails.
DELIMITER $$

CREATE PROCEDURE deposit_funds(
    IN p_account_id INT,
    IN p_amount DECIMAL(12,2)
)
BEGIN
    DECLARE v_rows INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_amount IS NULL OR p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Deposit amount must be positive';
    END IF;

    START TRANSACTION;
    UPDATE accounts
    SET balance = balance + p_amount
    WHERE account_id = p_account_id;
    SET v_rows = ROW_COUNT();

    IF v_rows <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account not found or balance overflow';
    END IF;

    INSERT INTO transactions (account_id, transaction_type, amount, description)
    VALUES (p_account_id, 'Deposit', p_amount, 'Cash deposit');
    COMMIT;
END$$

CREATE PROCEDURE withdraw_funds(
    IN p_account_id INT,
    IN p_amount DECIMAL(12,2)
)
BEGIN
    DECLARE v_rows INT DEFAULT 0;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;

    IF p_amount IS NULL OR p_amount <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Withdrawal amount must be positive';
    END IF;

    START TRANSACTION;
    UPDATE accounts
    SET balance = balance - p_amount
    WHERE account_id = p_account_id AND balance >= p_amount;
    SET v_rows = ROW_COUNT();

    IF v_rows <> 1 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Account not found or insufficient funds';
    END IF;

    INSERT INTO transactions (account_id, transaction_type, amount, description)
    VALUES (p_account_id, 'Withdrawal', p_amount, 'Cash withdrawal');
    COMMIT;
END$$

DELIMITER ;

-- Sample customers
INSERT INTO customers (full_name, phone, email, address) VALUES
('Ali Raza', '03001234567', 'ali@example.com', 'Lahore'),
('Sara Khan', '03111234567', 'sara@example.com', 'Islamabad');

-- Sample accounts
INSERT INTO accounts (customer_id, account_number, account_type, balance) VALUES
(1, 'PK00100001', 'Savings', 50000.00),
(2, 'PK00100002', 'Current', 25000.00);
