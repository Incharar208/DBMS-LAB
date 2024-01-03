create database Sailors;

use Sailors;

create table SAILORS (
sid int primary key,
sname varchar(20) not null,
rating float not null,
age int not null 
);

create table BOAT (
bid int primary key,
bname varchar(20) not null,
color varchar(20) not null 
);

create table RSERVERS (
sid int not null,
bid int not null,
reserve_date date not null,
foreign key (sid) references SAILORS(sid) on delete cascade,
foreign key (bid) references BOAT(bid) on delete cascade
);

insert into SAILORS (sid, sname, rating, age)
values
(201, 'Albert', 8.9, 43),
(202, 'Stormy', 9.1, 23),
(203, 'Boystorm', 6.6, 31),
(204, 'Harrystorms', 9.3, 45),
(205, 'Kumar', 7.9, 48),
(206, 'Patil', 9.5, 40),
(207, 'Shetty', 9.0, 35);

insert into BOAT (bid, bname, color)
values
(101, 'Boat1', 'Red'),
(102, 'Boat2', 'Green'),
(103, 'Boat3', 'Yellow'),
(104, 'Boat4', 'Beige'),
(105, 'Boat5', 'Pink'),
(106, 'Boat6', 'Blue');

insert into RSERVERS (sid, bid, reserve_date)
values
(201, 103, '2023-01-15'),
(202, 105, '2023-02-15'),
(203, 101, '2023-03-15'),
(204, 102, '2023-04-15'),
(205, 104, '2023-05-15'),
(206, 106, '2023-06-15'),
(207, 103, '2023-07-15');

-- Find the colours of boats reserved by Albert
select BOAT.color from BOAT
join RSERVERS on BOAT.bid = RSERVERS.bid
join SAILORS on SAILORS.sid = RSERVERS.sid
where sname = 'Albert'; 

-- Find all sailor id’s of sailors who have a rating of at least 8 or reserved boat 103
select RSERVERS.sid from RSERVERS
join SAILORS on RSERVERS.sid = SAILORS.sid
where rating >= 8.0 or bid = 103;

-- Find the names of sailors who have not reserved a boat whose name contains the string “storm”. Order the names in ascending order
select sname from SAILORS
where sid not in (select distinct sid from RSERVERS)
and sname like "%storm%"
order by sname;

-- Find the names of sailors who have reserved all boats
SELECT SAILORS.sname
FROM SAILORS 
JOIN RSERVERS  ON SAILORS.sid = RSERVERS.sid
GROUP BY SAILORS.sid
HAVING COUNT(DISTINCT RSERVERS.bid) = (SELECT COUNT(*) FROM BOAT);


-- Find the name and age of the oldest sailor
select sname, age from SAILORS
order by age desc
limit 1;

-- For each boat which was reserved by at least 2 sailors with age >= 40, find the boat id and the average age of such sailors
SELECT RSERVERS.bid, AVG(SAILORS.age) AS average_age
FROM RSERVERS 
JOIN SAILORS  ON RSERVERS.sid = SAILORS.sid
WHERE SAILORS.age >= 40
GROUP BY RSERVERS.bid
HAVING COUNT(DISTINCT RSERVERS.sid) >= 2;


-- Create a view that shows the names and colours of all the boats that have been reserved by a sailor with a specific rating 9.0
create view Display_Colours_Names
as select bname , color
from BOAT join RSERVERS ON
BOAT.bid = RSERVERS.bid
join SAILORS on SAILORS.sid = RSERVERS.sid
where SAILORS.rating like 6.6;

select * from Display_Colours_Names;

-- A trigger that prevents boats from being deleted If they have active reservations
DELIMITER //
CREATE TRIGGER Prevent_Deletion
BEFORE DELETE ON BOAT
FOR EACH ROW
BEGIN
    IF (OLD.bid IN (SELECT DISTINCT bid FROM RSERVERS)) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Boat is reserved and hence cannot be deleted';
    END IF;
END//
DELIMITER ;

delete from BOAT where bid = 101;


