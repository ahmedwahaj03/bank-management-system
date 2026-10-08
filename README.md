# Bank Management System

A relational database project for managing customers, bank accounts, and basic account transactions using MySQL.

## Features
- Customer management
- Savings and current accounts
- Relational customer/account design
- Deposits and withdrawals
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
5. Execute individual queries to test the system.

## Important
This repository is a database/SQL project. It does not contain a banking web application or real financial processing system.
