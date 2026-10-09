# Bank Management System

A relational database project for managing customers, bank accounts, and basic account transactions using MySQL.

## Features
- Customer management
- Savings and current accounts
- Relational customer/account design
- Atomic deposits and withdrawals with rollback on failure
- Positive transaction amounts and nonnegative account balances
- Transaction history
- Primary and foreign keys
- Constraints and indexes
- SQL JOIN, UPDATE, INSERT and transaction examples

## Database Design

### customers
Stores customer information.

### accounts
Stores account information and links each account to a customer.

### transactions
Stores deposits and withdrawals linked to an account.

Relationship:

`customers 1 ---- many accounts 1 ---- many transactions`

## Requirements
- MySQL 8.x
- MySQL Workbench is recommended for beginners

## Setup

1. Open MySQL Workbench.
2. Open `schema.sql`.
3. Execute the complete script.
4. Open `queries.sql`.
5. Execute individual queries to test the system. The deposit and withdrawal
   examples call stored procedures defined in `schema.sql`.
6. Verify balances and transaction history with the SELECT queries.

**Warning:** `schema.sql` drops and recreates the project tables and procedures.
Running it again will delete existing project data. Use a fresh test database
and back up any data you want to keep.

## Transaction safety

- `deposit_funds(account_id, amount)` validates a positive amount, updates the
  account balance, and records a deposit in a single transaction.
- `withdraw_funds(account_id, amount)` validates a positive amount and updates
  the balance only when sufficient funds exist. It records a withdrawal only
  after the update succeeds.
- Both procedures roll back on SQL errors, including a missing account.
- `accounts.balance` has a nonnegative CHECK constraint.
- `queries.sql` includes an optional commented-out insufficient-funds test.

The procedures are demonstration code, not a complete banking security system.
There is no login, user authorization, or production-grade audit system.

## Important
This repository is a database/SQL project. It does not contain a banking web application or real financial processing system.
