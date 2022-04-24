CREATE DATABASE Hotel

USE Hotel

create table RoomType(
	Id int primary key identity,
	Name nvarchar(100)
)

create table RoomStatus(
	Id int primary key identity,
	Status bit default 1
)

create table Customers(
	Id int primary key identity,
	FullName nvarchar(100),
	Adress nvarchar(255),
	Email nvarchar(100),
	Phone nvarchar(100)
)

create table Room(
	Id int primary key identity,
	type_id int references RoomType(Id),
	status_id int references RoomStatus(Id)
)

create table Reservation(
	Id int primary key identity,
	customer_id int references Customers(Id),
	room_id int references Room(Id),
	ReservationDate date,
)

create table Spendings(
	Id int primary key identity,
	Spend decimal
)

create table Payments(
	Id int primary key identity,
	reservation_id int references Reservation(Id),
	spending_id int references Spendings(Id)
)

insert into RoomType values('Single'),('Double'),('Triple'),('Quen'),('King')

insert into RoomStatus values(0),(1)

insert into Room values (1,1),(2,2),(3,1),(4,2),(5,1)

insert into Customers values ('Ferrux Aliyev','Suraxani','f@gmail.com','0552223322'),('Samir Aliyev','Nizami','s@gmail.com','0505343434'),('Emil Haci','Suraxani','e@gmail.com','0707645545')

insert into Reservation values (2,5,'2022/05/25'),(3,4,'2022/05/01'),(1,1,'2022/04/28')

insert into Spendings values (45.60),(34.67),(96.32),(96.32)

insert into Payments values(2,3),(4,2),(3,1)

create view ReservationsCount
AS
select Count(customer_id) 'Count'
from Reservation

create proc ReservationById(@id int)
AS
BEGIN
	select *
	from Reservation
	where @id = Reservation.Id
END

EXEC ReservationById 2


create proc ReservationByName(@fullname nvarchar(100))
AS
BEGIN
	select c.FullName,r.room_id,r.ReservationDate
	from Reservation as r
	Join Customers as c
	ON r.customer_id = c.Id
	where c.FullName = Trim(@fullname)
END

EXEC ReservationByName 'Ferrux Aliyev'

create proc RoomTypeByName(@fullname nvarchar(100))
AS
BEGIN
	select c.FullName,rt.Name
	from Reservation as r
	join Customers as c
	ON r.customer_id = c.Id
	join Room as rm
	ON r.room_id = rm.Id
	join RoomType as rt
	ON rm.type_id = rt.Id
	where c.FullName = Trim(@fullname)
END

EXEC RoomTypeByName 'Samir Aliyev  '

create view logic
as
select rs.Status
from Room as r
JOIN RoomStatus as rs
ON r.status_id = rs.Id


create function RoomStatusFunc(@start nvarchar(100))
returns decimal
AS
BEGIN
	declare @result decimal;
	while (select spend from Spendings) != (select top 1 Spend from Spendings ORDER BY Id DESC)
	BEGIN
	set @result = @result + (select Spend from Spendings)
	END
	return @result
END

Select * from dbo.RoomStatusFunc('start')

create trigger ShowCustomers
ON Customers
AFTER Insert
AS
BEGIN
	SELECT * FROM Customers
END

insert into Customers values ('Ali Vali','28-May','a@gmail.com','0503234534')