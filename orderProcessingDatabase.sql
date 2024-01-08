create database orderProcessing;

use orderProcessing;

create table Customer (
 cust int primary key,
 cname varchar(50),
 city varchar(50) 
);

create table Orders (
 order_id int primary key,
 odate date ,
 orderAmt int ,
 cust int,
 foreign key (cust) references Customer(cust) on delete cascade
);

create table Item (
 itemID int primary key,
 unitprice int 
);

create table OrderItems (
 order_id int ,
 itemID int ,
 qty int,
 foreign key (order_id) references Orders(order_id) on delete cascade ,
 foreign key (itemID) references Item(itemID) on delete cascade
);

create table Warehouse (
 warehouseID int primary key,
 city varchar(50) 
);


create table Shipment (
order_id int ,
warehouseID int ,
ship_date date ,
foreign key (warehouseID) references Warehouse(warehouseID) on delete cascade,
foreign key (order_id) references Orders(order_id) on delete cascade
);

insert into Customer (cust, cname, city)
values 
(1,"Kumar","Pune"),
(2,"Rahul Sharma","Mumbai"),
(3,"Sneha Kapoor","Kolkata"),
(4,"Rajesh Gupta","Chennai"),
(5,"Priya Singh","Delhi");


insert into Item (itemID, unitprice)
values
(51,45),
(52,67),
(53,90),
(54,12),
(55,150);

insert into Warehouse (warehouseID, city)
values
(81,"Mandya"),
(82,"Shivamogga"),
(83,"Madikeri"),
(84,"Kanpur"),
(85,"Jaipur");

insert into Orders (order_id, odate, orderAmt, cust)
values
(101, '2023-01-15', 1000, 1),
(102, '2023-02-20', 2000, 2),
(103, '2023-03-10', 3000, 3),
(104, '2023-04-05', 9000, 4),
(105, '2023-05-12', 6000, 5);

insert into OrderItems (order_id,  itemID, qty)
values
(101, 52, 6),
(102, 53, 3),
(103, 51, 4),
(104, 55, 12),
(105, 54, 15);

insert into Shipment (order_id , warehouseID, ship_date)
values
(101, 81, '2023-02-15'),
(102, 83, '2023-03-20'),
(103, 83, '2023-04-10'),
(104, 84, '2023-05-05'),
(105, 83, '2023-06-12');

-- List the Order# and Ship_date for all orders shipped from Warehouse# "W2"
select Shipment.order_id , Shipment.ship_date from Shipment where warehouseID = 83;

--  List the Warehouse information from which the Customer named "Kumar" was supplied his orders. Produce a listing of Order#, Warehouse#.
select Shipment.order_id, Shipment.warehouseId
from Shipment join Orders on
Shipment.order_id = Orders.order_id
join Customer on
Orders.cust = Customer.cust
where Customer.cname like "%Kumar%";

--  Produce a listing: Cname, #ofOrders, Avg_Order_Amt, where the middle column is the total number of orders by the customer and the last column is the average order amount for that customer. (Use aggregate functions)
select Customer.cname, COUNT(Orders.order_id) as NumberOfOrders, AVG(orderAmt) as OrderAmount
from Customer join 
Orders on Customer.cust = Orders.cust
group by Customer.cname;

-- Delete all orders for customer named "Kumar"
delete from Orders where cust = 
(select cust from Customer where cname like "%Kumar%");

-- Find the item with the maximum unit price
select Item.itemID from Item
order by unitprice desc
limit 1;

-- Create a view to display orderID and shipment date of all orders shipped from a warehouse 
create view order_shipment
as select Shipment.order_id , Shipment.ship_date 
from Shipment
where warehouseID = 83;

select * from order_shipment;

-- A trigger that updates order_amout based on quantity and unitprice of order_item
delimiter //
create trigger updateAmount
after insert on OrderItems
for each row
begin
	update Orders
    set orderAmt = (select unitprice from Item where itemId = new.itemID) * new.qty
    where order_id = new.order_id;
end;//
delimiter ;

insert into Orders 
values
(115, "2020-12-23",1200 , 1);

insert into OrderItems 
values
(115,51,9);

select * from Orders;
