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
location varchar(10) not null
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
('KA22RN3548', 'Tiago', 2021),
('KA27LL9472', 'Mazda', 2022),
('KA05QS4629', 'Kia', 2020);




