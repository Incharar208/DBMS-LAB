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
foreign key (sid) references SAILORS(sid),
foreign key (bid) references BOAT(bid) 
);

insert into SAILORS (sid, sname, rating, age)
values
(101, 'Albert', 8.9, 43),
(102, 'Stormy', 9.1, 23),
(103, 'Boystorm', 6.6, 31),
(104, 'Harrystorms', 9.3, 45),
(105, 'Kumar', 7.9, 48),
(106, 'Patil', 9.5, 40),
(107, 'Shetty', 9.0, 35);

insert into BOAT (bid, bname, color)
values
(201, 'Boat1', 'Red'),
(202, 'Boat2', 'Green'),
(203, 'Boat3', 'Yellow'),
(204, 'Boat4', 'Beige'),
(205, 'Boat5', 'Pink'),
(206, 'Boat6', 'Blue');

insert into RSERVERS (sid, bid, reserve_date)
values
(101, 203, '2023-01-15'),
(102, 205, '2023-02-15'),
(103, 201, '2023-03-15'),
(104, 202, '2023-04-15'),
(105, 204, '2023-05-15'),
(106, 206, '2023-06-15');
