-- RETAIL SALES ANALYSIS PROJECT
DROP DATABASE IF EXISTS retail_sales_analysis;
-- CREATE DATABASE
CREATE DATABASE retail_sales_analysis;


DROP TABLE IF EXISTS retail_sales_table;
-- CREATE TABLE
CREATE TABLE retail_sales_table
			(
				transactions_id	INT,
				sale_date	DATE,
				sale_time	TIME,
				customer_id	INT,
				gender	VARCHAR(15),
				age	INT,
				category	VARCHAR(15),
				quantiy	INT,
				price_per_unit	FLOAT,
				cogs	FLOAT,
				total_sale INT
			);
            
SHOW TABLES;
DESC retail_sales_table;
SELECT COUNT(*) FROM retail_sales_table;

SELECT * FROM retail_sales_table LIMIT 10;

-- DATA CLEANING
SELECT * FROM retail_sales_table 
	WHERE 
		transactions_id IS NULL OR 
        sale_date IS NULL OR 
        sale_time IS NULL OR
        customer_id IS NULL OR
        gender IS NULL OR
        age IS NULL OR
        category IS NULL OR
        quantiy IS NULL OR
        price_per_unit IS NULL OR
        cogs IS NULL OR
        total_sale IS NULL;
        

DELETE FROM retail_sales_table 
	WHERE 
		transactions_id IS NULL OR 
        sale_date IS NULL OR 
        sale_time IS NULL OR
        customer_id IS NULL OR
        gender IS NULL OR
        age IS NULL OR
        category IS NULL OR
        quantiy IS NULL OR
        price_per_unit IS NULL OR
        cogs IS NULL OR
        total_sale IS NULL;
        
-- DATA EXPLORATION

-- 1. how many sales we have?
SELECT COUNT(*) as total_sales FROM retail_sales_table;

-- 2. how many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as customers FROM retail_sales_table;

-- 3. how many unique categories we have?
SELECT DISTINCT category FROM retail_sales_table;

-- DATA ANALYSIS AND BUSINESS KEY PROBLEMS

-- 1. Retrieve all column of sales made on '2022-11-05'
SELECT * FROM retail_sales_table WHERE sale_date = '2022-11-05';

-- 2. Retrieve all the transactions where the category is clothing and quantity sold is more than 3 in the month of NOV-2022
SELECT 
*
FROM retail_sales_table 
WHERE category = 'Clothing'
AND
DATE_FORMAT (sale_date, '%Y-%m') = '2022-11'
AND
quantiy > 3;

-- 3. Calculate total sales for each category

SELECT 
	category,
    SUM(total_sale)
FROM retail_sales_table
GROUP BY 1;

-- 4. Find the avg age of the customer who purchased items from the Beauty category

SELECT 
ROUND(AVG(age),2) AS average_age
FROM retail_sales_table
WHERE category = 'Beauty'; 

-- 5. Retrieve all the transactions where total sales  > 1000

SELECT * FROM retail_sales_table
WHERE total_sale >1000;

-- 6. Retrieve all the transactions (transaction id)  made by each gender in each category
SELECT 
category, gender,count(transactions_id) 
FROM retail_sales_table 
group by category,gender
order by 1;

-- 7. calculate the avg sale of each month . find out best selling month in each year.
select year,month,average_sale 
	from(
		SELECT 
		EXTRACT( year from sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as average_sale,
		RANK() over(partition by EXTRACT( year from sale_date) order by AVG(total_sale)desc) as rank1
		FROM retail_sales_table group by 1,2 
	) as T1
WHERE rank1 =1;

-- order by 1, 3 desc;

-- 8. Find top 5 customers based on the highest total sales.

select customer_id, sum(total_sale) as total_sale  from retail_sales_table group by 1 order by 2 desc limit 5;

-- 9. find number of unique customers who purchased items for each category

select category, count(distinct customer_id) from retail_sales_table group by 2;

-- 10. create each shift and number of orders (eg, morning <=12, afternoon between12 & 17, evening >17)

WITH hourly_sale
AS
(
	SELECT *,
		CASE 
			WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
			ELSE 'Evening'
		END 
		as shift
	FROM retail_sales_table
)
SELECT shift, count(*) from hourly_sale group by shift ;

-- END OF THE PROJECT