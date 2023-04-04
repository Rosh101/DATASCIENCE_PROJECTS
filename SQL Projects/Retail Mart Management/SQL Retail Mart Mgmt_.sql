-- Create Database
Create database SQLBASICS;
-- Select Database 
USE SQLBASICS; 
-- Creating Product,Customers & Sales Table

CREATE TABLE IF NOT EXISTS Product (
  product_code INT(4) PRIMARY KEY, 
  product_name VARCHAR(30), 
  price FLOAT(6), 
  stock INT(5), 
  category VARCHAR(10)
);

Create TABLE IF NOT EXISTS Customer(
customer_id int(5) PRIMARY KEY,
customer_name varchar(30), 
customer_location varchar(30), 
customer_phone_number int(10)
);
CREATE TABLE IF NOT EXISTS Sales(
order_date date, 
order_number char(4), 
customer_id int(4),
customer_name varchar(30),
product_code int(2),
product_name varchar(30),
quantity int(4),
price float(6));
-- View Tables & their columns in details
show tables;
describe product;
describe customer;
describe sales;
-- Inserting Values in the Columns
-- Right click on the Tables, Table Data Import Wizard, Browse CSV file path, use existing table(select),import

-- Altering Sales Table
Select * From sales;
Alter Table sales
Change s_code p_code int(3);
-- Adding S_no and categories to the sales table.
Alter Table sales
Add S_no int(4), Add Categories varchar(30);

Select * From sales;
Select * From product;
Select * From customer;
-- Changing the type of stock in the product Table to Varchar
Describe product;
Alter Table product
Modify stock varchar(4);
-- Changing Customer Table to Customer_Details
Alter Table customer
Rename  customer_details;
Describe customer_details;
-- Dropping the S_no and Categories from the Sales Table
Alter Table sales
Drop S_no, Drop Categories;
Describe Sales;
select * from sales;
select * from customer_details;
-- Query to display order id, customer id, order date, price, and quantity from the sales table.
Select Null as order_no , customer_id,Null as order_date , Null as price ,Null as qty 
from customer_details
union
Select order_no, Null as customer_id, order_date, price, qty
from sales;
-- Query to display all the details in the product table if the category is stationary.
Select * from product;
Select * from product
where category="Stationary";
-- Query to find distinct categories in product table
Select Distinct category from product;
-- Query to display the sales details if quantity is greater than 2 and price is lesser than 500 from the sales table.
Select * from sales
where qty > 2 And price <500;
-- Query to display the customer’s name if the name ends with a.
Select * from customer_details;
Select customer_name From customer_details
Where customer_name Like "%a";
--  Query to display the product details in descending order of the price.
Select * from product
Order by price DESC ;
-- Query to display the product code and category from similar categories that are greater than or equal to 2.
Select * from product;
SELECT p_code, category, COUNT(*) as count_category
FROM product
GROUP BY p_code, category
HAVING COUNT(*) >= 2;
-- Query to display the order number and the customer name to combine the results of the order 
-- and the customer tables including duplicate rows.
Select * from customer_details;	
Select * from sales; 
Select order_no, Null as customer_name from sales
Union All
Select Null as order_no, customer_name from customer_details;




