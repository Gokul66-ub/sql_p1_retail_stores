# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `retail_store`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `retail_store`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE retail_store;

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
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Change datatype**: For sale date convert the VARCHAR data type into DATE data type.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT count(*) as TOTAL_SALES from retail_sales
SELECT COUNT(DISTINCT customer_id) as TOTAL_CUSTOMER FROM retail_sales;
SELECT DISTINCT category  FROM retail_sales;


UPDATE retail_sales
SET sale_date = STR_TO_DATE(sale_date, '%d-%m-%Y')

ALTER TABLE retail_sales MODIFY sale_date DATE;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
select * from retail_sales
where sale_date='2022-11-05'';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
select
*
from retail_sales
where
    category='Clothing' and 
    sale_date between '2022-11-01' and '2022-11-30' and
    quantity>=4;
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
select
    category,
    sum(total_sale) as total_sales,count(*) as total_orders
from retail_sales
group by category
order by total_sales desc;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
select
    round(avg(age),2) as AVERAGE_AGE
from retail_sales
where category='Beauty';
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
select
* 
from retail_sales
where total_sale>1000;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
select
    gender,
    category,
    count(transaction_id)
from retail_sales
group by gender,category
order by category,gender desc
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales.**:
```sql

select
    customer_id,
    sum(total_sale) as TOTAL_SALE
from retail_sales
group by 1
order by 2 DESC
limit 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
select
    category,count(distinct customer_id) as UNIQUE_CUSTOMER
from retail_sales
group by category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```

## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project serves as a comprehensive introduction to SQL for data analysts, covering database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance.


