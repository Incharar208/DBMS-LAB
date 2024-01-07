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
where SAILORS.sname = 'Albert'; 

-- Find all sailor id’s of sailors who have a rating of at least 8 or reserved boat 103
select RSERVERS.sid from RSERVERS
join SAILORS on RSERVERS.sid = SAILORS.sid
where SAILORS.rating >= 8.0 or RSERVERS.bid = 103;

-- Find the names of sailors who have not reserved a boat whose name contains the string “storm”. Order the names in ascending order
select SAILORS.sname from SAILORS
where sid not in (select distinct sid from RSERVERS)
and sname like "%storm%"
order by sname;

-- Find the names of sailors who have reserved all boats
select SAILORS.sname from
SAILORS join
RSERVERS on SAILORS.sid = RSERVERS.sid
group by SAILORS.sid
having COUNT(distinct RSERVERS.sid) = (select COUNT(*) from BOAT);

-- Find the name and age of the oldest sailor
select SAILORS.sname, SAILORS.age from SAILORS
order by age desc
limit 1;

-- For each boat which was reserved by at least 2 sailors with age >= 40, find the boat id and the average age of such sailors
select RSERVERS.bid, AVG(SAILORS.age) as averageAge
from RSERVERS join SAILORS on
RSERVERS.sid = SAILORS.sid
where SAILORS.age >= 40
group by RSERVERS.bid
having COUNT(distinct RSERVERS.sid) >= 2;

-- Create a view that shows the names and colours of all the boats that have been reserved by a sailor with a specific rating 9.0
create view Display_Colours_Names
as select BOAT.bname , BOAT.color
from BOAT join RSERVERS ON
BOAT.bid = RSERVERS.bid
join SAILORS on SAILORS.sid = RSERVERS.sid
where SAILORS.rating like 6.6;

select * from Display_Colours_Names;

-- A trigger that prevents boats from being deleted If they have active reservations
delimiter //
create trigger preventDeletion
before delete on BOAT
for each row
begin
	if (old.bid in (select distinct bid from RSERVERS)) then
		signal sqlstate '45000' set message_text = 'Boat under reservation hence cannot be deleted';
	end if;
end;//
delimiter ;
        
delete from BOAT where bid = 101;
-- gives an error as there is an active reservation
