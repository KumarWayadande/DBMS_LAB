-- Create the following tables. And Solve following queries by SQL
-- • Deposit (actno,cname,bname,amount,adate)
-- • Branch (bname,city)
-- • Customers (cname, city)
-- • Borrow(loanno,cname,bname, amount)
-- Add primary key and foreign key wherever applicable.
-- Insert data into the above created tables.
-- 1. Display names of depositors having amount greater than 4000.
-- 2. Display account date of customers Anil
-- 3. Display account no. and deposit amount of customers having account opened
-- between dates 1-12-96 and 1-5-97
-- 4. Find the average account balance at the Perryridge branch.
-- 5. Find the names of all branches where the average account balance is more
-- than $1,200.
-- 6. Delete depositors having deposit less than 5000
-- 7. Create a view on deposit table.

create database DepositDB_09;
use DepositDB_09;

-- Create Branch Table
CREATE TABLE Branch (
    bname VARCHAR(100) PRIMARY KEY,    -- Branch name as the primary key
    city VARCHAR(100)                  -- City where the branch is located
);

-- Create Customers Table
CREATE TABLE Customers (
    cname VARCHAR(100) PRIMARY KEY,    -- Customer name as the primary key
    city VARCHAR(100)                  -- Customer's city
);

-- Create Deposit Table
CREATE TABLE Deposit (
    actno INT PRIMARY KEY,             -- Account number as the primary key
    cname VARCHAR(100),                -- Customer name (Foreign Key referencing Customers)
    bname VARCHAR(100),                -- Branch name (Foreign Key referencing Branch)
    amount DECIMAL(10, 2),             -- Deposit amount
    adate DATE,                        -- Account date
    FOREIGN KEY (cname) REFERENCES Customers(cname),  -- Foreign Key linking to Customers
    FOREIGN KEY (bname) REFERENCES Branch(bname)      -- Foreign Key linking to Branch
);

-- Create Borrow Table
CREATE TABLE Borrow (
    loanno INT PRIMARY KEY,            -- Loan number as the primary key
    cname VARCHAR(100),                -- Customer name (Foreign Key referencing Customers)
    bname VARCHAR(100),                -- Branch name (Foreign Key referencing Branch)
    amount DECIMAL(10, 2),             -- Loan amount
    FOREIGN KEY (cname) REFERENCES Customers(cname),  -- Foreign Key linking to Customers
    FOREIGN KEY (bname) REFERENCES Branch(bname)      -- Foreign Key linking to Branch
);


-- Insert into Branch Table
INSERT INTO Branch (bname, city) VALUES
('Perryridge', 'Perryridge City'),
('Greenwich', 'Greenwich City'),
('Riverside', 'Riverside City');

-- Insert into Customers Table
INSERT INTO Customers (cname, city) VALUES
('Anil', 'Perryridge City'),
('John', 'Greenwich City'),
('Sara', 'Riverside City'),
('Alex', 'Perryridge City'),
('Mia', 'Greenwich City');

-- Insert into Deposit Table
INSERT INTO Deposit (actno, cname, bname, amount, adate) VALUES
(101, 'Anil', 'Perryridge', 3000.00, '1996-12-01'),
(102, 'John', 'Greenwich', 5000.00, '1997-03-15'),
(103, 'Sara', 'Riverside', 7000.00, '1996-06-20'),
(104, 'Alex', 'Perryridge', 12000.00, '1997-04-10'),
(105, 'Mia', 'Greenwich', 1500.00, '1997-02-01'),
(106, 'Anil', 'Perryridge', 6000.00, '1996-08-15');

-- Insert into Borrow Table
INSERT INTO Borrow (loanno, cname, bname, amount) VALUES
(201, 'Anil', 'Perryridge', 2000.00),
(202, 'John', 'Greenwich', 10000.00),
(203, 'Sara', 'Riverside', 5000.00),
(204, 'Alex', 'Perryridge', 3000.00),
(205, 'Mia', 'Greenwich', 8000.00);


-- 1. Display names of depositors having amount greater than 4000.
SELECT cname
FROM Deposit
WHERE amount > 4000;

-- 2. Display account date of customers Anil
SELECT actno, adate
FROM Deposit
WHERE cname = 'Anil';

-- 3. Display account no. and deposit amount of customers having account opened
-- between dates 1-12-96 and 1-5-97
SELECT actno, amount
FROM Deposit
WHERE adate BETWEEN '1996-12-01' AND '1997-05-01';


-- 4. Find the average account balance at the Perryridge branch.
SELECT AVG(amount) AS avg_balance
FROM Deposit
WHERE bname = 'Perryridge';

-- 5. Find the names of all branches where the average account balance is more
-- than $1,200.
SELECT bname
FROM Deposit
GROUP BY bname
HAVING AVG(amount) > 1200;


-- 6. Delete depositors having deposit less than 5000
DELETE FROM Deposit WHERE amount < 5000;

-- 7. Create a view on deposit table.
CREATE VIEW Deposit_View AS
SELECT actno, cname, bname, amount, adate
FROM Deposit;

-- To view from created view
SELECT * FROM Deposit_View;


