create database sales;
use sales;

select * from orders;
select * from restaurants;

-- QUESTIONS
-- A.KPI's
-- Total Orders
select count(distinct(OrderID)) from orders;
-- Total No.of restaurants
select count(RestaurantID) from restaurants;
-- Total Sales
select sum(OrderAmount) from orders;
-- Average delivery time
select avg(DeliveryTime_mins) from orders;
-- Average order value 
select avg(OrderAmount) from orders;
-- Maximum order quantity
select max(QuantityofItems) from orders;
-- Total Cuisines
select count(distinct Cuisine) from restaurants;
-- Date
select distinct(OrderDate) from orders;

-- B.Which top 5 restaurant received the most orders?
select B.* ,dense_rank() over (order by total_orders desc) as rnk from
(select A.RestaurantName ,count(OrderID) as total_orders from
(select a.RestaurantID,a.OrderID,b.RestaurantName from orders a inner join restaurants b on a.RestaurantID=b.RestaurantID)A 
group by RestaurantID,RestaurantName)B limit 5;
# in case of ties rank() function skips rank so we should go for dense_rank()

-- C.Which top 5 restaurant saw most sales?
select B.* ,rank() over (order by total_sales DESC) AS rnk from
(select A.RestaurantName ,sum(OrderAmount) as total_sales from
(select a.RestaurantID,a.OrderAmount,b.RestaurantName from orders a inner join restaurants b 
on a.RestaurantID=b.RestaurantID)A group by RestaurantID,RestaurantName)B limit 5;

-- D.When do customers order more in a day?
-- Hourly trend line
SELECT hour(OrderTime) as order_hours, COUNT(DISTINCT OrderID) as total_orders from orders
group by hour(OrderTime) order by hour(OrderTime);

-- E.Which is the most liked cuisines based on customer ratings?
select B.* ,dense_rank() over (order by Ratings desc) from
(select A.Cuisine,sum(CustomerRating_Food) as Ratings from
(select a.RestaurantID,a.CustomerRating_Food,b.Restaurantname,b.Cuisine from orders a inner join restaurants b 
on a.RestaurantID=b.RestaurantID)A group by Cuisine)B limit 5;

-- F.Which zone has the most sales?
select A.Zone,sum(OrderAmount) as total_sales from 
(select a.RestaurantID,a.OrderAmount,b.Zone from orders a inner join restaurants b on a.RestaurantID=b.RestaurantID)A
group by Zone;

-- G.% sales by category
select A.Category, sum(OrderAmount) as total_sales,
(sum(A.OrderAmount) / (select sum(OrderAmount) from orders)) * 100 AS percentage from
(select a.OrderAmount,b.Category from orders a inner join restaurants b on a.RestaurantID=b.RestaurantID)A
group by Category;

-- H.Which restaurants are providing good delivery service?
select b.RestaurantName,avg(a.CustomerRating_Delivery) as overall_rating
from orders a inner join restaurants b ON a.RestaurantID = b.RestaurantID
group by b.RestaurantName order by overall_rating desc limit 5;


