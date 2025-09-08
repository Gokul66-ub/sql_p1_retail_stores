-- SQL Retail Sales Analysis - P1

CREATE DATABASE retail_store;

-- CREATE TABLE
CREATE TABLE retail_sales (
    transaction_id INT PRIMARY KEY,
    sale_date VARCHAR(20),   -- keep as text first
    sale_time TIME,
    customer_id INT,
    gender VARCHAR(10),
    age INT,
    category VARCHAR(50),
    quantity INT,
    price_per_unit DECIMAL(10,2),
    cogs DECIMAL(10,2),
    total_sale DECIMAL(10,2)
);



SELECT * FROM retail_sales
LIMIT 10


SELECT 
    COUNT(*) 
FROM retail_sales

-- Data Cleaning
UPDATE retail_sales
SET sale_date = STR_TO_DATE(sale_date, '%d-%m-%Y')

ALTER TABLE retail_sales MODIFY sale_date DATE;

SELECT * FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- 
DELETE FROM retail_sales
WHERE 
    transaction_id IS NULL
    OR
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantity IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many uniuque customers we have ?

SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales

-- Identify all unique product categories in the dataset?

SELECT DISTINCT category FROM retail_sales


-- Data Analysis & Business Key Problems & Answers

-- My Analysis & Findings
-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.
-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year
-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)



 -- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';


-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022

select
*
from retail_sales
where
    category='Clothing' and 
    sale_date between '2022-11-01' and '2022-11-30' and
    quantity>=4;


-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.

select
    category,
    sum(total_sale) as total_sales,count(*) as total_orders
from retail_sales
group by category
order by total_sales desc;

-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.

SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'


-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

SELECT * FROM retail_sales
WHERE total_sale > 1000


-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select
    gender,
    category,
    count(transaction_id)
from retail_sales
group by gender,category
order by category,gender desc


-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

with top_month as (select 
    month(sale_date) as MONTH,
    year(sale_date) as year,
    avg(total_sale) as AVERAGE_SALE,
    row_number() over(order by year(sale_date),avg(total_sale) desc) as rn
    from retail_sales
    group by year(sale_date),month(sale_date)
)

SELECT
    YEAR,
    MONTH,
    AVERAGE_SALE,
    MONTHNAME(STR_TO_DATE(CONCAT(year,'-',month,'-01'), '%Y-%m-%d')) AS MONTH_NAME
FROM top_month
WHERE rn % 12 = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 

SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.

SELECT
    category,count(distinct customer_id) as UNIQUE_CUSTOMER
from retail_sales
group by category


-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)

with shift_schedule
as
(
select *,
case 
    when hour(sale_time)<12 then 'Morning'
    when hour(sale_time) between 12 and 17 then 'Afternoon'
    else 'Evening'
end as Shift
from retail_sales
)

select
    shift,
    count(*) as TOTAL_ORDERS
from shift_schedule
group by shift

-- End of project




