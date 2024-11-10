-- Consider the following database
-- Project(project_id,proj_name,chief_arch) , project_id is primary key
-- Employee(Emp_id,Emp_name) , Emp_id is primary key
-- Assigned-To(Project_id,Emp_id)
-- Find the SQL queries for the following:
-- 1. Get the details of employees working on project C353
-- 2. Get employee number of employees working on project C353
-- 3. Obtain details of employees working on Database project
-- 4. Get details of employees working on both C353 and C354
-- 5. Get employee numbers of employees who do not work on project C453

create database ProjectDB_07;
use ProjectDB_07;

-- Create Project Table
CREATE TABLE Project (
    project_id VARCHAR(10) PRIMARY KEY,
    proj_name VARCHAR(100),
    chief_arch VARCHAR(100)
);

-- Create Employee Table
CREATE TABLE Employee (
    Emp_id INT PRIMARY KEY,
    Emp_name VARCHAR(100)
);

-- Create Assigned-To Table
CREATE TABLE Assigned_To (
    Project_id VARCHAR(10),
    Emp_id INT,
    PRIMARY KEY (Project_id, Emp_id),
    FOREIGN KEY (Project_id) REFERENCES Project(project_id),
    FOREIGN KEY (Emp_id) REFERENCES Employee(Emp_id)
);


-- Insert into Project Table
INSERT INTO Project (project_id, proj_name, chief_arch) VALUES
('C353', 'Database Migration', 'Alice'),
('C354', 'Mobile App Development', 'Bob'),
('C453', 'Cloud Infrastructure', 'Charlie'),
('D123', 'Database Project', 'David');

-- Insert into Employee Table
INSERT INTO Employee (Emp_id, Emp_name) VALUES
(1001, 'John Doe'),
(1002, 'Alice Smith'),
(1003, 'Bob Johnson'),
(1004, 'Eve Davis'),
(1005, 'Charlie Brown');

-- Insert into Assigned-To Table
INSERT INTO Assigned_To (Project_id, Emp_id) VALUES
('C353', 1001),
('C353', 1002),
('C354', 1001),
('C354', 1003),
('C453', 1004),
('C453', 1005),
('D123', 1002),
('D123', 1003);


-- 1. Get the details of employees working on project C353
SELECT e.Emp_id, e.Emp_name
FROM Employee e
JOIN Assigned_To a ON e.Emp_id = a.Emp_id
WHERE a.Project_id = 'C353';


-- 2. Get employee number of employees working on project C353
SELECT e.Emp_id
FROM Employee e
JOIN Assigned_To a ON e.Emp_id = a.Emp_id
WHERE a.Project_id = 'C353';

-- 3. Obtain details of employees working on Database project
SELECT e.Emp_id, e.Emp_name
FROM Employee e
JOIN Assigned_To a ON e.Emp_id = a.Emp_id
JOIN Project p ON a.Project_id = p.project_id
WHERE p.proj_name LIKE '%Database%';

-- 4. Get details of employees working on both C353 and C354
SELECT e.Emp_id, e.Emp_name
FROM Employee e
JOIN Assigned_To a1 ON e.Emp_id = a1.Emp_id
JOIN Assigned_To a2 ON e.Emp_id = a2.Emp_id
WHERE a1.Project_id = 'C353'
  AND a2.Project_id = 'C354';


-- 5. Get employee numbers of employees who do not work on project C453
SELECT e.Emp_id
FROM Employee e
WHERE e.Emp_id NOT IN (
    SELECT a.Emp_id
    FROM Assigned_To a
    WHERE a.Project_id = 'C453'
);
