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
cyear varchar(10) not null
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

