create database FlightDB;

use FlightDB;

create table Flight(
FlightId int Primary key,
FlightName varchar(25),
source varchar(25),
destination varchar(25),
startdate datetime,
enddate datetime
);
 -- insertin data into flight table
insert into flight values(1,'Air India','HYD','CHN','2025-10-18 06:00:00','2025-10-18 08:00:00'),
(2,'Air India','HYD','CHN','2025-10-28 06:00:00','2025-10-28 08:00:00'),
(3,'Indigo','CHN','MUMBAI','2025-11-18 06:00:00','2025-11-18 08:00:00'),
(4,'Qatar','HYD','CHN','2025-10-18 06:00:00','2025-10-18 08:00:00'),
(5,'Indigo','PUNE','Delhi','2025-10-18 09:00:00','2025-10-18 12:00:00'),
(6,'AirWays','Mumbai','Delhi','2025-11-22 06:00:00','2025-11-22 08:00:00');

select * from flight;

use flightdb;
create user 'asha_user'@'localhost' identified by 'Test@1234';

grant all privileges on flightdb.* to 'asha_user'@'localhost';


revoke update on flightdb.flight from 'asha_user'@'localhost';

show grants for 'asha_user'@'localhost';

-- order by --
-- get flightdetails which are startling earlier from hyd -- where + order by
use flightdb;
select * from flight order by startdate desc;

select * from flight where source='HYD' order by startdate desc;

-- count no.of flight going to chennai  --count, where

select destination, count(*) as flightcount from flight group by destination order by flightcount;


select * from flight limit 2 offset 3;

select count(*) from flight;

select current_timestamp();
select round(123.456,2);
select (5*3-2);
-- case when

select 
case when startdate > now() then 'Scheduled'
when startdate < now() then 'Departed'
else 'OnrunWay' end as flightstatus
from flight;

-- mathematic functions -- abs, round, floor, ceiling

select *, abs(timestampdiff(hour, startdate, enddate)) as abstime from flight;

select *, round(timestampdiff(hour, startdate, enddate)/24, 2) as abstime from flight order by abstime desc;

select *, ceiling(timestampdiff(hour, startdate, enddate)/24) as abstime from flight order by abstime desc;

select power(2,3);

select sqrt(16);

-- min, max -- 

use flightdb;
update flight set flightname = '   Air india' where flightid=4;
select * from flight;
select min(startdate) from flight where cast(startdate as date) = curdate();

select cast(startdate as date) from flight;

-- concate, replace -- 

select flightid, concat(source, ' to ',destination) as route from flight;

select flightid, replace(Flightname, ' ' ,'') as route from flight;

update flight set flightname = replace(Flightname, ' ' ,'') where flightid = 1;

-- char_length, left, right, substring

select char_length(flightname) from flight;

select right(flightname, 3) from flight;

select substring(flightname, 2,4) from flight;

select locate('Air', flightname) as indexposition from flight;

select lower(flightname) from flight;

select ltrim(flightname) from flight;
select * from flight;
-- isnull, ifnull
insert into flight values(6, null, 'Delhi','MUMBAI','2025-11-26 08:00:00','2025-11-26 12:00:00');
select isnull(flightname) from flight;
update flight set destination='Delhi' where flightid = 2
select ifnull(flightname,'default') from flight;

-- and, or, not

select flightname from flight where source= 'HYD' or destination = 'CHN';

select * from flight where source <> 'HYD';

-- subqueries

-- display all flight details where startdate is earliest among all flights from 'hyd'

select min(startdate) from flight where startdate = min(startdate) and source = 'HYD';

select * from flight where source ='HYD' and startdate=(
select min(startdate) from flight where source='HYD');

create table booking(
bookingid int primary key,
bookingname varchar(30),
bookingdate datetime,
seatno varchar(5),
flightid int,
foreign key(flightid) references flight(flightid)
);

insert into booking values(101, 'Yamuna','2025-11-18 06:00:00','A2',1),
(102, 'Asha','2025-11-03 06:00:00','A1',1),
(103, 'aysha','2025-11-15 06:00:00','B3',2),
(104, 'Priya','2025-11-18 06:00:00','C1',1);

select * from booking;

-- list all flights that have atleast 2 booking;
select * from flight where flightid=(
select flightid from booking group by flightid having count(*) >= 2);

-- get the flightdetails that are scheduled to start after last endate destination to delhi

select * from flight where startdate >(
select max(enddate) from flight where destination='Delhi');

-- joins -- left join, right join, inner join, cross join,  self join

use flightdb;
select * from flight;

select *from booking;

select count(*) from flight f cross join booking b;

-- get the passengernames who booked flight from hyd;

select b.bookingname from flight f join booking b on f.flightid = b.flightid where 
f.source = 'HYD';

-- find the flights that have not been booked by any passenger
select * from flight f left join booking b on f.flightid = b.flightid
where bookingid is null;

-- show all the flights details along with no.of bookings in that flight;
select f.flightid,f.flightname, count(b.bookingid) from flight f left join booking b on f.flightid = b.flightid
group by f.flightid, f.flightname;

-- get the flightnames that have more booking than the average number of booking across all flights..

-- CTE
-- find all passengers who booked flight from hyd
select b.bookingname from flight f join booking b on f.flightid = b.flightid where 
f.source = 'HYD';
-- 
with cte as(
select flightid from flight where source = 'HYd'
)
select * from booking b join cte c on b.flightid = c.flightid;

-- show flights that have more than 2 booking
select * from flight f where f.flightid in (
select b.flightid from booking b group by b.flightid having count(*) >= 1);

select * from flight f where f.flightid = (
select f.flightid from flight f join booking b on f.flightid = b.flightid
group by b.flightid having count(*) > 2);

with cte as(
select b.flightid, count(*) as booking_count from booking b group by b.flightid 
)
select * from flight f join cte c on f.flightid = c.flightid where c.booking_count>2 ;

---  group by, cube , rollup







