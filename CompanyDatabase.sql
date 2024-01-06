CREATE DATABASE COMPANY;

USE COMPANY;

CREATE TABLE Employee (
	ssn INT PRIMARY KEY,
    ename VARCHAR(30) NOT NULL,
    address VARCHAR(45) NOT NULL,
    sex VARCHAR(7) NOT NULL,
    salary FLOAT NOT NULL, 
    superSSN INT,
    dno int,
    FOREIGN KEY (superSSN) REFERENCES Employee(ssn) ON DELETE CASCADE
);

CREATE TABLE Department (
	dno INT PRIMARY KEY,
    dname VARCHAR(15) NOT NULL,
    mgrSSN INT,
    mgrStartDate DATE,
    FOREIGN KEY (mgrSSN) REFERENCES Employee(ssn) ON DELETE CASCADE
);

ALTER TABLE Employee ADD FOREIGN KEY (dno) REFERENCES Department(dno) ON DELETE CASCADE;

CREATE TABLE DLocation (
	dno INT,
	dloc VARCHAR(35) NOT NULL,
    FOREIGN KEY(dno) REFERENCES Department(dno)
);

CREATE TABLE Project (
	pno INT PRIMARY KEY,
    pname VARCHAR(45) NOT NULL,
    plocation VARCHAR(30) NOT NULL,
    dno INT NOT NULL,
    FOREIGN KEY (dno) REFERENCES Department(dno) ON DELETE CASCADE
);

CREATE TABLE Works_on (
	ssn INT,
    pno INT,
    hours INT,
    FOREIGN KEY (ssn) REFERENCES Employee (ssn) ON DELETE CASCADE,
    FOREIGN KEY (pno) REFERENCES Project (pno) ON DELETE CASCADE
);


-- REQUIREMENTS 
-- EMPLOYEE WITH LAST NAME SCOTT
-- PROJECT NAMED IOT
-- DEPARTMENT NAMED ACCOUNTS, AND DEPARTMENT NUMBER 5
-- SALARY > 6L

INSERT INTO Employee (ssn, ename, address, sex, superSSN, salary) VALUES 
(104, "Sachin Elevendulkar", "Near Antilia, Mumbai", "Male",NULL, 100000),
(101, "Peter Scott", "KRS Road, London", "Male", 104, 750000),
(102, "Mustafa Kumar Scott", "Dharavi, Bombay", "Male",104, 62000),
(103, "Alexandra Cleopatra Singh", "New Yolk, Bengaluru West", "Female", 104, 980000),
(105, "Mahendra King Dhoni", "Ranchi, India", "Male",104, 777777);

INSERT INTO Department VALUES 
(001, "Accounts", 102, '2023-05-15'),
(002, "CS", 103, '2023-06-15'),
(003, "Administration", 101, '2023-07-15'),
(005, "Sports", 105, '2023-07-07');

UPDATE Employee SET dno = 001 WHERE ssn = 102;
UPDATE Employee SET dno = 002 WHERE ssn = 103;
UPDATE Employee SET dno = 003 WHERE ssn = 101;
UPDATE Employee SET dno = 005 WHERE ssn = 105;

SELECT * FROM Employee;

INSERT INTO DLocation VALUES
(001, "Bombay"),
(002, "Bengaluru"),
(003, "London"),
(005, "Ranchi");

INSERT INTO Project VALUES 
(1001, "Money Heist", "Spain", 001),
(1002, "IOT", "Mysuru", 002),
(1003, "Cricket", "Ranchi", 005);

INSERT INTO Works_On VALUES 
(105, 1003, 10),
(104, 1002, 8),
(103, 1002, 7),
(102, 1001, 12);

-- Make a list of all project numbers for projects that involve an employee whose last name is ‘Scott’, either as a worker or as a manager of the department that controls the project
select Project.Pno, Project.pname from
Project join Department on
Project.dno = Department.dno
join 
Employee on 
Department.dno = Employee.dno
where ename like '%Scott';


-- Show the resulting salaries if every employee working on the ‘IoT’ project is given a 10 percent raise
select Employee.ename, Employee.salary as "Old Salary" , Employee.salary * 1.1 as "New Salary"
from Employee 
join Project on
Employee.dno = Project.dno
where Project.pname = "IOT";

-- Find the sum of the salaries of all employees of the ‘Accounts’ department, as well as the maximum salary, the minimum salary, and the average salary in this department
select SUM(Employee.salary) as SUMSALARY, MAX(Employee.salary) as MAXSALARY, MIN(Employee.salary) as MINSALARY
from Employee join
Department on
Employee.dno = Department.dno
where Department.dname = 'Accounts'
group by Department.dname;

-- Retrieve the name of each employee who works on all the projects controlled by department number 5
select Employee.ename from
Employee join Project
on Employee.dno = Project.dno
where Project.dno = 5;

-- For each department that has more than five employees, retrieve the department number and the number of its employees who are making more than Rs. 6,00,000
select Department.dno, COUNT(Employee.ssn) as EmployeeCount from
Department join
Employee on Department.dno = Employee.dno
where Employee.salary > 600000 
group by Department.dno 
having COUNT(Employee.ssn) > 0;

-- Create a view that shows name, dept name and location of all employees
create view DisplayRequired
as select Employee.ename, Department.dname, Dlocation.dloc
from Employee join
Department on
Employee.dno = Department.dno
join Dlocation on Department.dno = Dlocation.dno;

select * from DisplayRequired;

-- Create a trigger that prevents a project from being deleted if it is currently being worked by any employee.
delimiter //
create trigger deletePrevention
before delete on Project
for each row
begin
    if(old.pno in (select pno from Works_on where Works_on.pno = old.pno))
    then
    signal sqlstate '45000' set
    message_text = "Project cannot be deleted";
    end if;
end; //
delimiter ;
    
delete from Project where pno = "1001";
