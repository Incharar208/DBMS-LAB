create database Insurance;

use Insurance;

create table PERSON (
driver_id varchar(10) primary key,
name varchar(20) not null,
address varchar(20) not null 
);
 
create table CAR (
reg_no varchar(15) primary key,
model varchar(10) not null,
cyear int not null
);

create table ACCIDENT (
report_number int primary key,
accident_date date not null,
location varchar(20) not null
);

create table OWNS (
driver_id varchar(10) not null,
reg_no varchar(15) not null,
foreign key (driver_id) references PERSON(driver_id) on delete cascade,
foreign key (reg_no) references CAR(reg_no) on delete cascade
);

create table PARTICIPATED (
driver_id varchar(10) not null,
reg_no varchar(15) not null,
report_number int not null,
damage_amount int not null,
foreign key (driver_id) references PERSON(driver_id) on delete cascade,
foreign key (reg_no) references CAR(reg_no) on delete cascade,
foreign key (report_number) references ACCIDENT(report_number) on delete cascade
);

insert into PERSON(driver_id, name, address)
values
('D001', 'Smith', 'Kuvempunagar'),
('D002', 'Alex', 'Vijaynagar'),
('D003', 'John', 'R K Nagar'),
('D004', 'Kumar', 'K P Layout'),
('D005', 'Patil', 'J P Nagar');

insert into CAR (reg_no, model, cyear)
values
('KA09FG2435', 'Swift', 2009),
('KA12TT5667', 'Verna', 2015),
('KA22RN3548', 'Mazda', 2021),
('KA27LL9472', 'Kushaq', 2022),
('KA09MA1234', 'Kia', 2020);

insert into ACCIDENT (report_number, accident_date, location)
values
(101, '2022-01-12', 'R G layout'),
(102, '2022-02-12', 'Vijaynagar'),
(103, '2021-03-12', 'Kuvempnagara'),
(104, '2023-04-12', 'J P Nagar'),
(105, '2021-05-12', 'Jaynagar'),
(106, '2021-07-12', 'R T Nagar');

insert into OWNS (driver_id , reg_no)
values
('D001', 'KA09FG2435'),
('D002', 'KA12TT5667'),
('D001', 'KA22RN3548'),
('D003', 'KA27LL9472'),
('D005', 'KA09MA1234');

insert into PARTICIPATED (driver_id, reg_no, report_number, damage_amount)
values
('D001', 'KA09FG2435', 101, 26000),
('D002', 'KA12TT5667', 102, 36000),
('D001', 'KA22RN3548', 103, 46000),
('D003', 'KA27LL9472', 104, 56000),
('D005', 'KA09MA1234', 106, 66000);

-- Find the total number of people who owned cars that were involved in accidents in 2021
select count(distinct driver_id) as total
from PARTICIPATED join
ACCIDENT on
PARTICIPATED.report_number = ACCIDENT.report_number
where accident_date like '2021%';

-- Find the number of accidents in which the cars belonging to “Smith” were involved
select count(PARTICIPATED.driver_id) as Accidents_by_Smith
from PARTICIPATED join
PERSON on PARTICIPATED.driver_id = PERSON.driver_id
where PERSON.name like '%Smith%';


SET SQL_SAFE_UPDATES = 0;
-- Delete the Mazda belonging to “Smith”.
delete from CAR where model = 'Mazda'
and reg_no in
(select OWNS.reg_no from OWNS join PERSON on
OWNS.driver_id = PERSON.driver_id
where PERSON.name like '%Smith%');

select * from CAR;

-- Add a new accident to the database; assume any value for the atributes
insert into ACCIDENT (report_number, accident_date, location)
values
(108, '2020-09-16', 'Bogadi');

-- Update the damage amount for the car with license number "KA09MA1234" in the accident with an appropriate report number
update PARTICIPATED
set damage_amount = 70000
where reg_no = 'KA09MA1234'
and report_number = 106;

-- A view that shows models and year of cars that are involved in accident
create view displayModelsYears
as select CAR.model, CAR.cyear 
from CAR join PARTICIPATED
on PARTICIPATED.reg_no = CAR.reg_no;

select * from displayModelsYears;

-- A trigger that prevents a driver from participating in more than 2 accidents in a given year
delimiter //
create trigger preventParticipation
before insert on PARTICIPATED
for each row
begin
	if (select COUNT(*) from PARTICIPATED where driver_id = new.driver_id) >= 2 then
		signal sqlstate '45000' set message_text = 'Already 2 accidents crossed';
	end if;
end;//
delimiter ;

insert into PARTICIPATED 
values
('D001', 'KA09FG2435', 101, 26000);
    
