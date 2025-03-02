--Sql Retail Sales Analysis--
Create DataBase retail_project2

--create table---
CREATE TABLE retail_sales (
			transactions_id INT PRIMARY KEY,
			sale_date DATE,
			sale_time TIME,
			customer_id INT,
			gender VARCHAR(15),
			age INT,
			category VARCHAR(14),
			quantiy INT,
			price_per_unit  FLOAT,
			cogs FLOAT, 
			total_sale FLOAT
)
ALTER TABLE retail_sales 
RENAME COLUMN quantiy TO quantity;

SELECT * From retail_sales
limit 10


--DATA CLEANING---
--check the null values in dataset---

SELECT * From retail_sales
where transactions_id IS NULL

SELECT * From retail_sales
where sale_date = NULL

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	customer_id IS NULL 
	OR 
    gender IS NULL 
	OR
	age IS NULL 
	OR
	category IS NULL
	OR 
    quantity IS NULL
	OR 
	price_per_unit IS NULL 
	OR
	cogs IS NULL;


--Delete the data where the column contains NULL values


DELETE FROM retail_sales
WHERE 
    sale_date IS NULL
	OR 
	sale_time IS NULL
	OR
	customer_id IS NULL 
	OR 
    gender IS NULL 
	OR
	age IS NULL 
	OR
	category IS NULL
	OR 
    quantity IS NULL
	OR 
	price_per_unit IS NULL 
	OR
	cogs IS NULL;

--DATA EXPLORATION

--how many sales we have 
select count(*) as Total_sales  from retail_sales

--how many customers we have?
select count(customer_id) as Total_sales from retail_sales

--how many unique customers we have?
select count(DISTINCT customer_id) as Total_sales from retail_sales

--how many unique category we have?
select count(DISTINCT category) as Total_sales from retail_sales


--DATA ANALYSIS & FINDINGS ------


--question1:-Write a SQL query to retrieve all columns for sales made on '2022-11-05?
	SELECT * 
	FROM retail_sales
	WHERE sale_date =' 2022-11-05';
 
--question2:-Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022?
			SELECT * 
			FROM retail_sales
			WHERE category='Clothing' AND quantity >=4 AND TO_CHAR(sale_date, 'YYYY-MM') = '2022-11';
--question3:-Write a SQL query to calculate the total sales (total_sale) for each category ?
				SELECT 
				category,
				SUM(total_sale) as net_sale,
				COUNT(*) as total_orders
				FROM retail_sales
				GROUP BY 1;

--question4:-Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
				SELECT Round(AVG(age),2)as Avg_age from retail_sales where category='Beauty';

--question5:-Write a SQL query to find all transactions where the total_sale is greater than 1000?
				SELECT * from retail_sales where total_sale >1000;

--question6:-Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category?
				SELECT 
			    category,
			    gender,
			    COUNT(*) as total_trans
				FROM retail_sales
				GROUP 
			    BY 
			    category,
			    gender
				ORDER BY 1

--question7:-Write a SQL query to calculate the average sale for each month. Find out best selling month in each year?
			SELECT 
			year,
			month,
			avg_sale
			FROM 
			(    
			SELECT 
			    EXTRACT(YEAR FROM sale_date) as year,
			    EXTRACT(MONTH FROM sale_date) as month,
			    AVG(total_sale) as avg_sale,
			    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
			FROM retail_sales
			GROUP BY 1, 2
			) as t1
			WHERE rank = 1

--question8:-Write a SQL query to find the top 5 customers based on the highest total sales **?
		SELECT 
		customer_id,
		SUM(total_sale) as total_sales
		FROM retail_sales
		GROUP BY 1
		ORDER BY 2 DESC
		LIMIT 5

--question9:-Write a SQL query to find the number of unique customers who purchased items from each category?
				SELECT 
				category,    
				COUNT(DISTINCT customer_id) as cnt_unique_cs
				FROM retail_sales
				GROUP BY category
--question10:-Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)?
			   WITH hourly_sale
			   AS
				(
				SELECT *,
				    CASE
				        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
				        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
				        ELSE 'Evening'
				    END as shift
				FROM retail_sales
				)
				SELECT 
				    shift,
				    COUNT(*) as total_orders    
				FROM hourly_sale
				GROUP BY shift
