-- ----------------------- SESSION - 1-----------------------------
-- =============================================================
-- 1. DATABASE
-- A database is an organized collection of structured data stored electronically.
-- It helps store and manage large amounts of information efficiently.
-- Example: A company database storing employees, departments, salaries.

-- Command to create a database:
CREATE DATABASE IF NOT EXISTS company_db;

-- Select the database to use:
USE company_db;

-- =============================================================
-- 2. DBMS (Database Management System)
-- DBMS is software that manages databases.
-- It allows you to Create, Read, Update, Delete (CRUD) data.
-- Examples: MySQL, PostgreSQL, Oracle, SQL Server.

-- =============================================================
-- 3. SQL (Structured Query Language)
-- SQL is used to interact with relational databases.
-- SQL lets you perform:
-- DDL - Define data structure
-- DML - Manipulate data
-- DQL - Query data
-- DCL - Manage permissions
-- TCL - Handle transactions

-- =============================================================
-- 4. SCHEMA
-- A schema defines the structure of a database.
-- It includes: tables, columns, data types, constraints, keys, relationships.

-- =============================================================
-- SQL COMMAND TYPES
-- -------------------------------------------------------------
-- 1. DDL (Data Definition Language)
-- Used to create and modify structure of tables and databases.
-- Examples:
-- CREATE - Create database/table
-- ALTER - Modify table
-- DROP - Delete table
-- TRUNCATE - Remove all rows

-- 2. DML (Data Manipulation Language)
-- Used to modify data.
-- INSERT, UPDATE, DELETE

-- 3. DQL (Data Query Language)
-- SELECT - Used to read data

-- 4. DCL (Data Control Language)
-- GRANT, REVOKE (permissions)

-- 5. TCL (Transaction Control Language)
-- COMMIT - Save changes
-- ROLLBACK - Undo changes
-- SAVEPOINT - Create checkpoints

-- =============================================================
-- 5. CREATE TABLE
CREATE TABLE IF NOT EXISTS test_table (
    id INT,
    name VARCHAR(100)
);
-- EXAMPLE 
CREATE TABLE COMPANY_DB.employees_ts (
     ID INT,
     NAME VARCHAR(100)
);
-- =============================================================
-- 6. INSERT DATA
INSERT INTO test_table (id, name) VALUES
(1, 'Alice'),
(2, 'Bob'),
(3, 'Charlie');

-- EXAMPLE 
INSERT INTO EMPLOYEES_TS ( ID , NAME) VALUES 
(101100 , 'CHARLIE'),
(101101, 'TOM'),
(101102, 'TIM');


-- =============================================================
-- 7. SELECT DATA
SELECT * FROM test_table;

-- SELECT with specific columns:
SELECT id FROM test_table;

-- =============================================================
-- 8. ALTER TABLE
-- Add new column:
ALTER TABLE test_table
ADD email_id VARCHAR(255);

-- Rename column:
ALTER TABLE test_table
RENAME COLUMN email_id TO email;

-- =============================================================
-- 9. CONSTRAINTS
-- Constraints ensure correctness and validity of data.

-- Types:
-- NOT NULL - Value cannot be empty
-- UNIQUE - Prevents duplicate values
-- PRIMARY KEY - Unique + Not Null
-- FOREIGN KEY - Links two tables
-- CHECK - Validates condition
-- DEFAULT - Adds default value

DROP TABLE IF EXISTS Persons;

CREATE TABLE Persons (
    ID INT NOT NULL UNIQUE,
    LastName VARCHAR(255) NOT NULL,
    FirstName VARCHAR(255),
    Age INT
);

INSERT INTO Persons VALUES (1, 'Smith', 'John', 30);
INSERT INTO Persons VALUES (2, 'Doe', NULL, NULL);

-- PRIMARY KEY
ALTER TABLE Persons
ADD CONSTRAINT PK_Person PRIMARY KEY (ID);

-- =============================================================
-- 10. FOREIGN KEY
-- A foreign key connects a child table to a parent table.
-- It ensures referential integrity.
-- ON DELETE RESTRICT = Cannot delete parent if child exists
-- ON UPDATE CASCADE = Updating parent value updates child as well
-- https://youtu.be/xVXKBM-QHlA?si=_LqLb4-yFx9IXj2o

DROP TABLE IF EXISTS Orders;

CREATE TABLE Orders (
    OrderID INT PRIMARY KEY,
    OrderDate DATE,
    PersonID INT,
    FOREIGN KEY (PersonID) REFERENCES Persons(ID)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

INSERT INTO Orders VALUES (1001, '2024-06-10', 1);

-- =============================================================
-- 11. CHECK and DEFAULT
DROP TABLE IF EXISTS employee;

CREATE TABLE employee (
    ID INT NOT NULL,
    LastName VARCHAR(255) NOT NULL,
    FirstName VARCHAR(255),
    Age INT CHECK (Age >= 18),
    city VARCHAR(255) DEFAULT 'new york'
);

INSERT INTO employee VALUES (4, 'joey', 'tribiani', 21, 'texas');

-- =============================================================
-- 12. DELETE vs DROP vs TRUNCATE

-- DELETE:
-- Removes specific rows.
-- Table structure remains.
DELETE FROM test_table WHERE id = 2;

-- TRUNCATE:
-- Removes all rows.
-- Faster than DELETE. Auto resets identity.
TRUNCATE TABLE test_table;

-- DROP:
-- Deletes entire table structure.
DROP TABLE IF EXISTS test_table;

-- =============================================================
-- 13. DROP DATABASE (Use with caution)
-- DROP DATABASE company_db;

-- END OF SESSION
