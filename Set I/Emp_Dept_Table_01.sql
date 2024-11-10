-- 1. Create a db called company consist of the following tables.
-- 1.Emp (eno,ename, job,hiredate,salary,commission,deptno,)
-- 2.dept(deptno,deptname,location)
-- eno is primary key in emp
-- deptno is primary key in dept
-- Solve Queries by SQL
-- 1. List the maximum salary paid to salesman
-- 2. List name of emp whose name start with ‘I’
-- 3. List details of emp who have joined before ’30-sept-81’
-- 4. List the emp details in the descending order of their basic salary
-- 5. List of no. of emp & avg salary for emp in the dept no ‘20’
-- 6. List the avg salary, minimum salary of the emp hiredatewise for dept no ‘10’.
-- 7. List emp name and its department
-- 8. List total salary paid to each department
-- 9. List details of employee working in ‘Dev’ department
-- 10. Update salary of all employees in deptno 10 by 5 %.


create database company;

use company;

create table dept(
	deptno int primary key,
	deptname varchar(50),
	location varchar(50)
)

create table Emp(
	eno int primary key,
	ename varchar(50),
	job varchar(50),
	hiredate Date,
	salary decimal,
	commission decimal,	
	deptno int,
	foreign key (deptno) references dept(deptno)
)


-- Inserting records into the 'dept' table
INSERT INTO dept (deptno, deptname, location) VALUES
(10, 'Accounting', 'New York'),
(20, 'Research', 'Dallas'),
(30, 'Sales', 'Chicago'),
(40, 'Operations', 'Boston'),
(50, 'Dev', 'San Francisco');


-- Inserting records into the 'emp' table
INSERT INTO emp (eno, ename, job, hiredate, salary, commission, deptno) VALUES
(1001, 'John Smith', 'Manager', '1981-06-09', 5000.00, NULL, 10),
(1002, 'Jane Doe', 'Analyst', '1982-12-10', 4000.00, NULL, 20),
(1003, 'Alice Johnson', 'Clerk', '1981-01-12', 1500.00, NULL, 20),
(1004, 'Bob King', 'Salesman', '1983-03-15', 2800.00, 300.00, 30),
(1005, 'Jim Brown', 'Salesman', '1981-05-18', 2500.00, 500.00, 30),
(1006, 'Irene Wells', 'Analyst', '1981-09-01', 3500.00, NULL, 10),
(1007, 'Tom Ford', 'Clerk', '1980-12-15', 1200.00, NULL, 10),
(1008, 'Igor Ivanov', 'Developer', '1980-11-13', 4000.00, NULL, 50),
(1009, 'Nancy Green', 'Manager', '1982-09-10', 6000.00, NULL, 40),
(1010, 'Jack White', 'Clerk', '1981-07-22', 1800.00, NULL, 20);
(1011, 'Ishan White', 'Clerk', '1981-07-22', 1800.00, NULL, 20);




-- 1. List the maximum salary paid to salesman
Select MAX(salary) as Max_Salary_Of_Salesman from emp where job = 'Salesman';

-- 2. List name of emp whose name start with ‘I’
select ename from emp where ename like "I%";

-- 3. List details of emp who have joined before ’30-sept-81’
select * from emp where hiredate < '1981-09-30';

-- 4. List the emp details in the descending order of their basic salary
select * from emp order by salary desc;

-- 5. List of no. of emp & avg salary for emp in the dept no ‘20’
select count(eno) as no_of_employees, avg(salary) as avg_salary from emp where deptno = 20;

-- 6. List the avg salary, minimum salary of the emp hiredatewise for dept no ‘10’.
SELECT hiredate, AVG(salary) AS AvgSalary, MIN(salary) AS MinSalary FROM emp WHERE deptno = 10 GROUP BY hiredate;

-- 7. List emp name and its department
select e.ename, d.deptname from emp e join dept d on  e.deptno = d.deptno;

-- 8. List total salary paid to each department
SELECT d.deptname, SUM(e.salary) AS TotalSalary FROM emp e JOIN dept d ON e.deptno = d.deptno GROUP BY d.deptname;

-- 9. List details of employee working in ‘Dev’ department
SELECT e.* FROM emp e JOIN dept d ON e.deptno = d.deptno WHERE d.deptname = 'Dev';

-- 10. Update salary of all employees in deptno 10 by 5 %.
update Emp set salary = (salary * 1.05) where deptno = 10;