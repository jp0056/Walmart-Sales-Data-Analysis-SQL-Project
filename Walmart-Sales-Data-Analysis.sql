-- Create table sales 

CREATE TABLE sales (
    invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(5) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(10) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price NUMERIC(10, 2) NOT NULL,
    quantity INT NOT NULL,
    vat FLOAT NOT NULL,
    total NUMERIC(12, 4) NOT NULL,
    date TIMESTAMP NOT NULL,
    time TIME NOT NULL,
    payment VARCHAR(15) NOT NULL,
    cogs NUMERIC(10, 2) NOT NULL,
    gross_margin_pct FLOAT,
    gross_income NUMERIC(12, 4),
    rating FLOAT
);

SELECT * FROM sales Limit 10

--   Generic Questions

--1) How many distinct cities are present in the dataset?
--2) In which city is each branch situated?

-- Solution 1:-

	SELECT DISTINCT city FROM sales

-- Solution 2 :-

	SELECT
		DISTINCT city,
		branch
	FROM sales
	

--   Product Analysis

--1) How many distinct product lines are there in the dataset?

	SELECT COUNT(DISTINCT product_line) FROM sales
	
--2) What is the most common payment method?

	SELECT payment, COUNT(payment) AS common_payment_method 
    FROM sales GROUP BY payment ORDER BY common_payment_method DESC LIMIT 1;
	
--3) What is the most selling product line?

	SELECT product_line, count(product_Line) AS most_selling_product
    FROM sales GROUP BY product_line ORDER BY most_selling_product DESC LIMIT 1;

--4) What is the total revenue by month?

	SELECT EXTRACT(Month from date) AS month_name, SUM(total) AS total_revenue
    FROM SALES GROUP BY month_name ORDER BY total_revenue DESC;

--5) Which month recorded the highest Cost of Goods Sold (COGS)?

	SELECT EXTRACT(Month from date) AS month_name, SUM(cogs) AS total_cogs
    FROM sales GROUP BY month_name ORDER BY total_cogs DESC;

--6) Which product line generated the highest revenue?

	SELECT product_line, SUM(total) AS total_revenue
    FROM sales GROUP BY product_line ORDER BY total_revenue DESC LIMIT 1;
	
--7) Which city has the highest revenue?

	SELECT city,SUM(total) AS highest_rev
	FROM sales GROUP BY city ORDER BY highest_rev DESC LIMIT 1


--8) Which product line incurred the highest VAT?

	SELECT product_line, MAX(VAT) AS highest_vat
	FROM sales GROUP BY 1 ORDER BY 2 DESC LIMIT 1
	
-- 9.Retrieve each product line and add a column product_category, indicating 'Good' or 'Bad,'based on whether its sales are above the average.

ALTER TABLE sales ADD COLUMN product_category VARCHAR(20);

UPDATE sales 
SET product_category= 
(CASE 
	WHEN total >= (SELECT AVG(total) FROM sales) THEN "Good"
    ELSE "Bad"
END)FROM sales;

-- 10.Which branch sold more products than average product sold?
SELECT branch, SUM(quantity) AS quantity
FROM sales GROUP BY branch HAVING SUM(quantity) > AVG(quantity) ORDER BY quantity DESC LIMIT 1;

-- 11.What is the most common product line by gender?
SELECT gender, product_line, COUNT(gender) total_count
FROM sales GROUP BY gender, product_line ORDER BY total_count DESC;

-- 12.What is the average rating of each product line?
SELECT product_line, ROUND(AVG(rating),2) average_rating
FROM sales GROUP BY product_line ORDER BY average_rating DESC;


Sales Analysis
-- 1.Number of sales made in each time of the day per weekday
SELECT day_name, time_of_day, COUNT(invoice_id) AS total_sales
FROM sales GROUP BY day_name, time_of_day HAVING day_name NOT IN ('Sunday','Saturday');

SELECT day_name, time_of_day, COUNT(*) AS total_sales
FROM sales WHERE day_name NOT IN ('Saturday','Sunday') GROUP BY day_name, time_of_day;

-- 2.Identify the customer type that generates the highest revenue.
SELECT customer_type, SUM(total) AS total_sales
FROM sales GROUP BY customer_type ORDER BY total_sales DESC LIMIT 1;

-- 3.Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, SUM(VAT) AS total_VAT
FROM sales GROUP BY city ORDER BY total_VAT DESC LIMIT 1;

-- 4.Which customer type pays the most in VAT?
SELECT customer_type, SUM(VAT) AS total_VAT
FROM sales GROUP BY customer_type ORDER BY total_VAT DESC LIMIT 1;

Customer Analysis

-- 1.How many unique customer types does the data have?
SELECT COUNT(DISTINCT customer_type) FROM sales;

-- 2.How many unique payment methods does the data have?
SELECT COUNT(DISTINCT payment) FROM sales;

-- 3.Which is the most common customer type?
SELECT customer_type, COUNT(customer_type) AS common_customer
FROM sales GROUP BY customer_type ORDER BY common_customer DESC LIMIT 1;

-- 4.Which customer type buys the most?
SELECT customer_type, SUM(total) as total_sales
FROM sales GROUP BY customer_type ORDER BY total_sales LIMIT 1;

SELECT customer_type, COUNT(*) AS most_buyer
FROM sales GROUP BY customer_type ORDER BY most_buyer DESC LIMIT 1;

-- 5.What is the gender of most of the customers?
SELECT gender, COUNT(*) AS all_genders 
FROM sales GROUP BY gender ORDER BY all_genders DESC LIMIT 1;

-- 6.What is the gender distribution per branch?
SELECT branch, gender, COUNT(gender) AS gender_distribution
FROM sales GROUP BY branch, gender ORDER BY branch;

-- 7.Which time of the day do customers give most ratings?
SELECT time_of_day, AVG(rating) AS average_rating
FROM sales GROUP BY time_of_day ORDER BY average_rating DESC LIMIT 1;

-- 8.Which time of the day do customers give most ratings per branch?
SELECT branch, time_of_day, AVG(rating) AS average_rating
FROM sales GROUP BY branch, time_of_day ORDER BY average_rating DESC;

SELECT branch, time_of_day,
AVG(rating) OVER(PARTITION BY branch) AS ratings
FROM sales GROUP BY branch;

-- 9.Which day of the week has the best avg ratings?
SELECT day_name, AVG(rating) AS average_rating
FROM sales GROUP BY day_name ORDER BY average_rating DESC LIMIT 1;

-- 10.Which day of the week has the best average ratings per branch?
SELECT  branch, day_name, AVG(rating) AS average_rating
FROM sales GROUP BY day_name, branch ORDER BY average_rating DESC;