-- PROJECT NAME: Northwind Sales Data Anylysis
-- Author: Ankita Sahu
-- Discription: Anylizing sales trands,Customer behavior and logistics
:--------------------------------------------------------------------------:
-- 1. Calculate the total Revenue by year:

CREATE DATABASE NORTHWIND;
USE NORTHWIND;

SELECT SUM(Unit_Price * quantity *(1 - discount)) AS Total_Revenue
FROM northwind_order_details;

-- 2. Calculate total numbers of Orders:

SELECT COUNT(DISTINCT order_id) AS Total_orders
FROM northwind_orders;
---------------------------------------------------------------------------:
--3. calculate the Average Order value:

SELECT SUM(unit_price *quantity *(1-discount)) 
/COUNT(DISTINCT O.Order_id)AS Avg_orders_value
FROM northwind_order_details od 
JOIN northwind_orders o
ON o.order_id=od.order_id;
----------------------------------------------------------------------------:
-- 4.Calculate the top 5 highest Revenue Orders:

SELECT order_id,
SUM(Unit_Price * quantity *(1 - discount)) AS Total_Revenue
FROM northwind_order_details
GROUP BY order_id order by Total_Revenue DESC LIMIT 5;

-- 5. which Country is generating the most revenue?
-----------------------------------------------------------------------------:

SELECT ship_country,
SUM(od.Unit_Price * od.quantity *(1 - od.discount)) AS Total_Revenue
FROM northwind_order_details od
JOIN northwind_orders o
ON o.order_id=od.order_id
GROUP BY ship_country
ORDER BY ship_country DESC;

-- 6. What is the month-wise trand?
-----------------------------------------------------------------------------:

SELECT YEAR(order_date)AS Yearly,
MONTH(order_date)AS Monthly,
SUM(od.Unit_Price * od.quantity *(1 - od.discount)) AS Monthely_Revenue
FROM northwind_order_details od
JOIN northwind_orders o
ON o.order_id=od.order_id
GROUP BY order_date
ORDER BY order_date DESC;

-- 7. What is the impact of Discount on Revenue?
------------------------------------------------------------------------------:

SELECT CASE WHEN discount>0 THEN "Discount" ELSE "NOdiscount" END AS Discount_type,
SUM(Unit_Price * quantity *(1 - discount)) AS Total_Revenue
FROM northwind_order_details
GROUP BY Discount_type;

-- 8. show the Top 10 Best-selling products:
--------------------------------------------------------------------------------:

SELECT product_id,
SUM(quantity) AS
Total_Units_Sold
FROM northwind_order_details
GROUP BY product_id
ORDER BY Total_Units_Sold DESC;

-- 9. Top 5 customer by revenue:
-------------------------------------------------------------------------------:

SELECT o.customer_id,
SUM(od.Unit_Price * od.quantity *(1 - od.discount)) AS Total_Revenue
FROM northwind_orders o
JOIN northwind_order_details od
ON o.order_id= od.order_id
GROUP BY o.customer_id
ORDER BY Total_Revenue DESC LIMIT 5;

-- 10. give the Revenue Ranking:
--------------------------------------------------------------------------------:

SELECT o.customer_id,
SUM(od.Unit_Price * od.quantity *(1 - od.discount)) AS Total_Revenue,
RANK() OVER(PARTITION BY o.customer_id ORDER BY SUM(od.Unit_Price * od.quantity *(1 - od.discount)) DESC)AS RANK_REVENUE
FROM northwind_order_details od
JOIN northwind_orders o
ON o.order_id=od.order_id
GROUP BY o.customer_id;
