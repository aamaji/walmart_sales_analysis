create table if not exists walmart_table(
	invoice_id VARCHAR(30) NOT NULL PRIMARY KEY,
    branch VARCHAR(30) NOT NULL,
    city VARCHAR(30) NOT NULL,
    customer_type VARCHAR(30) NOT NULL,
    gender VARCHAR(30) NOT NULL,
    product_line VARCHAR(100) NOT NULL,
    unit_price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    VAT FLOAT(6, 4) NOT NULL,
    total DECIMAL(10, 2) NOT NULL,
    date DATETIME NOT NULL,
    time TIME NOT NULL,
    payment DECIMAL(10, 2) NOT NULL,
    cogs DECIMAL(10, 2) NOT NULL,
    gross_margin_pct FLOAT(11, 9),
    gross_income DECIMAL(10, 2) NOT NULL,
    rating FLOAT(2,1) 
)


#-------------------------------------------------------------------------------
#-----------------------------Feature Engineering-------------------------------

-- time_of_day-----

SELECT 
    time,
    (CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END) AS time_of_day
FROM
    walmart_table;
    
ALTER TABLE walmart_table ADD time_of_day VARCHAR(20);

UPDATE walmart_table 
SET time_of_day = (
	CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);

------------------

--- Day_Name -----

SELECT date, dayname(date) as Day FROM walmart_table;

ALTER TABLE walmart_table ADD day_name VARCHAR(10);

UPDATE walmart_table 
SET day_name = dayname(date);

-------------------
------ Month_name----------

SELECT date, monthname(date) FROM walmart_table;

ALTER TABLE walmart_table ADD month_name VARCHAR(10);

UPDATE walmart_table
SET month_name = monthname(date);

-- --------------------------------------
-- -------------------Generic --------------
-- How many unique cities does the data have?
SELECT distinct(city) FROM walmart_table;

-- In which city is each branch?
SELECT distinct(branch), city FROM walmart_table;

-- -----------Product--------------------
-- How many unique product lines does the data have?
SELECT count(product_line) FROM walmart_table;

-- What is the most common payment method?
SELECT payment, count(payment) FROM walmart_table
group by payment
order by count(payment) desc
limit 1;


-- What is the most selling product line?
SELECT product_line, count(product_line) FROM walmart_table
group by product_line
order by count(product_line) desc
limit 1;

-- What is the total revenue by month?
SELECT month_name, sum(total) FROM walmart_table
GROUP BY month_name;

-- What month had the largest COGS?
SELECT month_name, sum(cogs) FROM walmart_table
GROUP BY month_name
ORDER BY sum(cogs) desc
limit 1;

-- What product line had the largest revenue?
SELECT product_line, sum(total) FROM walmart_table
GROUP BY product_line
ORDER BY sum(total) desc
limit 1;

-- What is the city with the largest revenue?
SELECT city, sum(total) FROM walmart_table
GROUP BY city
ORDER BY sum(total) desc
limit 1;

-- What product line had the largest VAT?
SELECT product_line, avg(VAT) FROM walmart_table
GROUP BY product_line
ORDER BY avg(VAT) desc
limit 1;

-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
ALTER TABLE walmart_table ADD time_of_day VARCHAR(20);

UPDATE walmart_table 
SET time_of_day = (
	CASE
        WHEN time BETWEEN '00:00:00' AND '12:00:00' THEN 'Morning'
        WHEN time BETWEEN '12:01:00' AND '16:00:00' THEN 'Afternoon'
        ELSE 'Evening'
    END
);

-- Which branch sold more products than average product sold?
SELECT branch, sum(quantity) FROM walmart_table
GROUP BY branch
HAVING sum(quantity) > (SELECT avg(quantity) FROM walmart_table)
ORDER BY sum(quantity) desc
limit 1;

-- What is the most common product line by gender?
SELECT gender, product_line, count(gender) FROM  walmart_table
group by gender, product_line
order by count(gender) desc;

-- What is the average rating of each product line?
SELECT product_line, round(avg(rating), 2) FROM walmart_table
GROUP BY product_line
ORDER BY avg(rating);

-- ----------------------SALES----------------------------
-- Number of sales made in each time of the day per weekday
SELECT time_of_day, count(*) FROM walmart_table
WHERE day_name = 'Monday'
GROUP BY time_of_day
ORDER BY count(*) desc;

-- Which of the customer types brings the most revenue?
SELECT customer_type, sum(total) FROM walmart_table
GROUP BY customer_type
ORDER BY sum(total) desc;

-- Which city has the largest tax percent/ VAT (Value Added Tax)?
SELECT city, round(avg(VAT), 2) as VAT_perc FROM walmart_table
GROUP BY city
ORDER BY avg(VAT) desc;

-- Which customer type pays the most in VAT?
SELECT customer_type, round(AVG(VAT), 2) FROM walmart_table
GROUP BY customer_type
ORDER BY avg(VAT) desc;

-- --------------------------CUSTOMER----------------------------
-- How many unique customer types does the data have?
SELECT count(DISTINCT(customer_type)) FROM walmart_table;

-- How many unique payment methods does the data have?
SELECT count(DISTINCT(payment)) FROM walmart_table;

-- What is the most common customer type?
SELECT customer_type, count(customer_type) FROM walmart_table
GROUP BY customer_type
ORDER BY count(customer_type) desc;

-- Which customer type buys the most?
SELECT customer_type, count(quantity) FROM walmart_table
GROUP BY customer_type
ORDER BY count(quantity) desc;

-- What is the gender of most of the customers?
SELECT gender, count(quantity) FROM walmart_table
GROUP BY gender
ORDER BY count(quantity) desc;

-- What is the gender distribution per branch?
SELECT gender, branch, count(gender) FROM walmart_table
GROUP BY gender, branch
ORDER BY count(gender);

-- Which time of the day do customers give most ratings?
SELECT time_of_day, count(rating) FROM walmart_table
GROUP BY time_of_day
ORDER BY count(rating) desc;

-- Which time of the day do customers give most ratings per branch?
SELECT time_of_day, branch, count(rating) FROM walmart_table
GROUP BY time_of_day, branch
ORDER BY count(rating) desc;

-- Which day of the week has the best avg ratings?
SELECT day_name, avg(rating) FROM walmart_table
GROUP BY day_name
ORDER BY avg(rating) desc;

-- Which day of the week has the best average ratings per branch?
SELECT day_name, branch, avg(rating) FROM walmart_table
GROUP BY day_name, branch
ORDER BY avg(rating) desc;
