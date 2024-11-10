-- Create the following tables. And Solve following queries by SQL
-- 1. Deposit (actno,cname,bname,amount,adate)
-- 2. Branch (bname,city)
-- 3. Customers (cname, city)
-- 4. Borrow(loanno,cname,bname, amount)
-- Add primary key and foreign key wherever applicable.
-- Insert data into the above created tables.
-- a. Display names of all branches located in city Bombay.
-- b. Display account no. and amount of depositors.
-- c. Update the city of customers Anil from Pune to Mumbai
-- d. Find the number of depositors in the bank
-- e. Calculate Min,Max amount of customers.
-- f. Create an index on deposit table
-- g. Create View on Borrow table.

create database DepositDB_10;
use DepositDB_10;

-- 1. Create the Branch table
CREATE TABLE Branch (
    bname VARCHAR(100) PRIMARY KEY,  -- Branch name as primary key
    city VARCHAR(100)                -- City where the branch is located
);

-- 2. Create the Customers table
CREATE TABLE Customers (
    cname VARCHAR(100) PRIMARY KEY,  -- Customer name as primary key
    city VARCHAR(100)                -- City where the customer resides
);

-- 3. Create the Deposit table
CREATE TABLE Deposit (
    actno INT PRIMARY KEY,           -- Account number as primary key
    cname VARCHAR(100),              -- Customer name (Foreign Key referencing Customers)
    bname VARCHAR(100),              -- Branch name (Foreign Key referencing Branch)
    amount DECIMAL(10, 2),           -- Amount of deposit
    adate DATE,                      -- Account date
    FOREIGN KEY (cname) REFERENCES Customers(cname),  -- Foreign Key to Customers
    FOREIGN KEY (bname) REFERENCES Branch(bname)      -- Foreign Key to Branch
);

-- 4. Create the Borrow table
CREATE TABLE Borrow (
    loanno INT PRIMARY KEY,          -- Loan number as primary key
    cname VARCHAR(100),              -- Customer name (Foreign Key referencing Customers)
    bname VARCHAR(100),              -- Branch name (Foreign Key referencing Branch)
    amount DECIMAL(10, 2),           -- Loan amount
    FOREIGN KEY (cname) REFERENCES Customers(cname),  -- Foreign Key to Customers
    FOREIGN KEY (bname) REFERENCES Branch(bname)      -- Foreign Key to Branch
);

-- Insert some sample data

-- Inserting data into Branch table
INSERT INTO Branch (bname, city) VALUES
('Perryridge', 'Pune'),
('Greenwich', 'Bombay'),
('Riverside', 'Delhi'),
('Sunshine', 'Bombay');

-- Inserting data into Customers table
INSERT INTO Customers (cname, city) VALUES
('Anil', 'Pune'),
('John', 'Bombay'),
('Sara', 'Delhi'),
('Alex', 'Bombay'),
('Mia', 'Pune');

-- Inserting data into Deposit table
INSERT INTO Deposit (actno, cname, bname, amount, adate) VALUES
(101, 'Anil', 'Perryridge', 5000.00, '2023-05-10'),
(102, 'John', 'Greenwich', 4000.00, '2023-06-15'),
(103, 'Sara', 'Riverside', 15000.00, '2023-01-20'),
(104, 'Alex', 'Sunshine', 2000.00, '2023-03-18'),
(105, 'Mia', 'Perryridge', 7000.00, '2023-04-05');

-- Inserting data into Borrow table
INSERT INTO Borrow (loanno, cname, bname, amount) VALUES
(201, 'Anil', 'Perryridge', 2000.00),
(202, 'John', 'Greenwich', 10000.00),
(203, 'Sara', 'Riverside', 5000.00),
(204, 'Alex', 'Sunshine', 3000.00),
(205, 'Mia', 'Perryridge', 8000.00);




-- a. Display names of all branches located in city Bombay.
SELECT bname
FROM Branch
WHERE city = 'Bombay';


-- b. Display account no. and amount of depositors.
SELECT actno, amount
FROM Deposit;


-- c. Update the city of customers Anil from Pune to Mumbai
UPDATE Customers
SET city = 'Mumbai'
WHERE cname = 'Anil' AND city = 'Pune';

-- d. Find the number of depositors in the bank
SELECT COUNT(*) AS number_of_depositors
FROM Deposit;

-- e. Calculate Min,Max amount of customers.
SELECT MIN(amount) AS Min_Amount, MAX(amount) AS Max_Amount
FROM Deposit;


-- f. Create an index on deposit table
CREATE INDEX idx_amount ON Deposit(amount);

-- g. Create View on Borrow table.
CREATE VIEW Borrow_View AS
SELECT loanno, cname, bname, amount
FROM Borrow;
