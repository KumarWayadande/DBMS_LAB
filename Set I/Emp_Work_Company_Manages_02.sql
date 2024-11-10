-- Create a database
-- 1. employee (employee name, street, city) ,employee name is primary key
-- 2. works (employee name, company name, salary)
-- 3. company (company name, city) ,company name is primary key
-- 4. manages (employee name, manager name)
-- Give an expression in SQL for each of the following queries.
-- 1. Find the names of all employees who work for First Bank Corporation.
-- 2. Find all employees who do not work for First Bank Coorporation
-- 3. Find the company that has most employees.
-- 4. Find all companies located in every in which small bank corporation is located
-- 5. Find details of employee having salary greater than 10,000.
-- 6. Update salary of all employees who work for First Bank Corporation by 10%.
-- 7. Find employee and their managers.
-- 8. Find the names, street and cities of all employees who work for First Bank
-- Corporation and earn more than 10,000.
-- 9. Find those companies whose employees earn a higher salary,on average, than th
-- average salary at First Bank Corporation

-- Create the database
CREATE DATABASE company_db;

-- Use the newly created database
USE company_db;

-- Create 'employee' table
CREATE TABLE employee (
    employee_name VARCHAR(50) PRIMARY KEY,
    street VARCHAR(50),
    city VARCHAR(50)
);

-- Create 'works' table
CREATE TABLE works (
    employee_name VARCHAR(50),
    company_name VARCHAR(50),
    salary DECIMAL(10, 2),
    FOREIGN KEY (employee_name) REFERENCES employee(employee_name)
);

-- Create 'company' table
CREATE TABLE company (
    company_name VARCHAR(50) PRIMARY KEY,
    city VARCHAR(50)
);

-- Create 'manages' table
CREATE TABLE manages (
    employee_name VARCHAR(50),
    manager_name VARCHAR(50),
    FOREIGN KEY (employee_name) REFERENCES employee(employee_name)
);

-- Insert some demo values into the 'employee' table
INSERT INTO employee (employee_name, street, city) VALUES
('John Doe', '123 Main St', 'New York'),
('Alice Smith', '456 Oak St', 'San Francisco'),
('Bob Johnson', '789 Pine St', 'New York'),
('Eve Davis', '321 Maple Ave', 'Los Angeles'),
('Charlie Brown', '654 Elm St', 'Chicago');

-- Insert demo values into the 'company' table
INSERT INTO company (company_name, city) VALUES
('First Bank Corporation', 'New York'),
('Small Bank Corporation', 'San Francisco'),
('Tech Solutions', 'Los Angeles'),
('Global Corp', 'Chicago');

-- Insert demo values into the 'works' table
INSERT INTO works (employee_name, company_name, salary) VALUES
('John Doe', 'First Bank Corporation', 12000),
('Alice Smith', 'Small Bank Corporation', 9000),
('Bob Johnson', 'First Bank Corporation', 8000),
('Eve Davis', 'Tech Solutions', 15000),
('Charlie Brown', 'Global Corp', 7000);

-- Insert demo values into the 'manages' table
INSERT INTO manages (employee_name, manager_name) VALUES
('John Doe', 'Bob Johnson'),
('Alice Smith', 'John Doe'),
('Bob Johnson', 'Charlie Brown'),
('Eve Davis', 'Alice Smith'),
('Charlie Brown', 'Eve Davis');


-- 1. employee (employee name, street, city) ,employee name is primary key
SELECT employee_name FROM works WHERE company_name = 'First Bank Corporation';


-- 2. Find all employees who do not work for First Bank Coorporation
SELECT employee_name FROM works WHERE company_name != 'First Bank Corporation';


-- 3. Find the company that has most employees.
SELECT company_name FROM works GROUP BY company_name ORDER BY COUNT(employee_name) DESC LIMIT 1;


-- 4. Find all companies located in every in which small bank corporation is located
SELECT DISTINCT company_name FROM company WHERE city IN (
    SELECT city 
    FROM company 
    WHERE company_name = 'Small Bank Corporation'
);


-- 5. Find details of employee having salary greater than 10,000.
SELECT employee_name, company_name, salary FROM works  WHERE salary > 10000;


-- 6. Update salary of all employees who work for First Bank Corporation by 10%.
UPDATE works SET salary = salary * 1.10 WHERE company_name = 'First Bank Corporation';


-- 7. Find employee and their managers.
SELECT e.employee_name, m.manager_name FROM manages m JOIN employee e ON e.employee_name = m.employee_name;


-- 8. Find the names, street and cities of all employees who work for First Bank
-- Corporation and earn more than 10,000.
SELECT e.employee_name, e.street, e.city FROM employee e JOIN works w ON e.employee_name = w.employee_name WHERE w.company_name = 'First Bank Corporation' AND w.salary > 10000;


-- 9. Find those companies whose employees earn a higher salary,on average, than th
-- average salary at First Bank Corporation
SELECT w.company_name FROM works w GROUP BY w.company_name 
HAVING AVG(w.salary) > (
    SELECT AVG(salary)
    FROM works
    WHERE company_name = 'First Bank Corporation'
);




