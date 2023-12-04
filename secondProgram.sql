-- creating the database
create database secondProgram;

-- selecting the database to be used
use secondProgram;

-- creating the table
CREATE TABLE Student (
 SID int primary key,
 NAME varchar(30),
 BRANCH varchar(20),
 SEMESTER int,
 ADDRESS varchar(50),
 PHONE varchar(10),
 EMAIL varchar(30)
 );
 
 -- inserting 10 tuples 
 INSERT INTO Student(SID, NAME, BRANCH, SEMESTER, ADDRESS, PHONE, EMAIL)
 VALUES
(101,"Ananya","CSE",5,"Srirampura","9089764524","ananya@gmail.com"),
(208,"Arnav","ISE",5,"Kuvempunagar","9346578167","arnav@gmail.com"),
(312,"Bindu","ECE",3,"Niveditha Nagar","9871635123","bindu@gmail.com"),
(326,"Chaitra","ECE",3,"Vijaynagar","8452736457","chaitra@gmail.com"),
(157,"Pruthvi","CSE",5,"T K Layout","6534127689","pruthvi@gmail.com"),
(180,"Sanjay","CSE",5,"Arvind Nagar","8726354909","sanjay@gmail.com"),
(486,"Sourav","EEE",5,"Kuvempunagar","7614867790","sourav@gmail.com"),
(567,"Keerthana","EIE",5,"Kuvempunagar","8145267589","keerthana@gmail.com"),
(678,"Vinay","CVE",5,"J P Nagar","7145628904","vinay@gmail.com"),
(215,"Jahnavi","ISE",5,"Kuvempunagar","8145627891","jahnavi@gmail.com");

-- a). Insert a new student
INSERT INTO Student VALUES (380,"Shwetha","ECE",3,"Vijaynagar","6295627489","shwetha@gmail.com");

-- b). Modify the address of the student based on SID
UPDATE Student SET ADDRESS = "Kuvempunagar" WHERE SID = 101;

-- c). Delete a Student
DELETE FROM Student WHERE SID = 678;

-- d). List all the students
SELECT * FROM Student;

-- e). List all the students of CSE branch
SELECT * FROM Student WHERE BRANCH = "CSE";

-- f). List all the students of CSE Branch and reside in Kuvempunagar
SELECT * FROM Student WHERE BRANCH = "CSE" AND ADDRESS = "Kuvempunagar";

 
