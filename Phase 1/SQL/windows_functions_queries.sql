-- Window function: Is a calculation accross a set of rows in a table that are somehow related to the current row.
-- When to use Windows functions:
-- 1. When you want to measure trends or changes over rows or records in your data.
-- 2. When you want to rank a column for outreach or prioritization.
-- When window functions are used, you’ll notice new column names like the following:
-- Average running price
-- Running total orders
-- Running sum sales
-- Rank
-- Percentile
-- A window function is similar to aggregate functions combined with group by clauses but have one key difference: Window functions retain the total number of rows between the input table and the output table (or result). Behind the scenes, the window function is able to access more than just the current row of the query result.
-- Core Window Functions
SELECT standard_amt_usd,
    DATE_TRUNC('year', occurred_at) as year,
    SUM(standard_amt_usd) OVER (
        PARTITION BY DATE_TRUNC('year', occurred_at)
        ORDER BY occurred_at
    ) AS running_total
FROM orders
SELECT order_id,
    order_total,
    order_price,
    SUM(order_total) OVER (
        PARTITION BY month(order_date)
        ORDER BY order_date
    ) AS running_monthly_sales,
    COUNT(order_id) OVER (
        PARTITION BY month(order_date)
        ORDER BY order_date
    ) AS running_monthly orders,
    AVG(order_price) OVER (
        PARTITION BY month(order_date)
        ORDER BY order_date
    ) AS average_monthly_price
FROM amazon_sales_db
WHERE order_date < '2017-01-01';


SELECT id,
    account_id,
    standard_qty,
    DATE_TRUNC('month', occurred_at) AS month,
    DENSE_RANK() OVER (
        PARTITION BY account_id
        ORDER BY DATE_TRUNC('month', occurred_at)
    ) AS dense_rank,
    SUM(standard_qty) OVER (
        PARTITION BY account_id
        ORDER BY DATE_TRUNC('month', occurred_at)
    ) AS sum_standard_qty,
    COUNT(standard_qty) OVER (
        PARTITION BY account_id
        ORDER BY DATE_TRUNC('month', occurred_at)
    ) AS count_standard_qty,
    AVG(standard_qty) OVER (
        PARTITION BY account_id
        ORDER BY DATE_TRUNC('month', occurred_at)
    ) AS avg_standard_qty,
    MIN(standard_qty) OVER (
        PARTITION BY account_id
        ORDER BY DATE_TRUNC('month', occurred_at)
    ) AS min_standard_qty,
    MAX(standard_qty) OVER (
        PARTITION BY account_id
        ORDER BY DATE_TRUNC('month', occurred_at)
    ) AS max_standard_qty
FROM orders 

-- The ORDER BY clause is one of two clauses integral to window functions. The ORDER and PARTITION define what is referred to as the “window”
-- The ordered subset of data over which calculations are made.

    --------------- Ranking Window Functions ---------------
    Row_number(): -- Distinct #s for each records.
Select ROW_Number() Over (
        Order by date_time
    ) as rank,
    date_time
From db;
Rank(): -- Ties are given the same number and number are skipped for subsequent records.
Select RANK() Over (
        Order by date_time
    ) as rank,
    date_time
From db;
Dense_rank(): -- Ties are given the same number and numbers are not skipped for subsequent records.
Select DENSE_RANK() Over (
        Order by date_time
    ) as rank,
    date_time
From db;
-- Advanced Windows Functions ----
-- Aliases: Help your syntax when writing multiple windows functions that leverage the same Partition By, Over, and Order By in a single query.
SELECT order_id,
    order_total,
    order_price,
    SUM(order_total) OVER monthly_window AS running_monthly_sales,
    COUNT(order_id) OVER monthly_window AS running_monthly orders,
    AVG(order_price) OVER monthly_window AS average_monthly_price
FROM amazon_sales_db
WHERE order_date < '2017-01-01' WINDOW monthly_window AS (
        PARTITION BY month(order_date)
        ORDER BY order_date
    );
-- Re-write this query using aliases
SELECT id,
    account_id,
    DATE_TRUNC('year', occurred_at) AS year,
    DENSE_RANK() OVER (
        PARTITION BY account_id
        ORDER BY DATE_TRUNC('year', occurred_at)
    ) AS dense_rank,
    total_amt_usd,
    SUM(total_amt_usd) OVER (
        PARTITION BY account_id
        ORDER BY DATE_TRUNC('year', occurred_at)
    ) AS sum_total_amt_usd,
    COUNT(total_amt_usd) OVER (
        PARTITION BY account_id
        ORDER BY DATE_TRUNC('year', occurred_at)
    ) AS count_total_amt_usd,
    AVG(total_amt_usd) OVER (
        PARTITION BY account_id
        ORDER BY DATE_TRUNC('year', occurred_at)
    ) AS avg_total_amt_usd,
    MIN(total_amt_usd) OVER (
        PARTITION BY account_id
        ORDER BY DATE_TRUNC('year', occurred_at)
    ) AS min_total_amt_usd,
    MAX(total_amt_usd) OVER (
        PARTITION BY account_id
        ORDER BY DATE_TRUNC('year', occurred_at)
    ) AS max_total_amt_usd
FROM orders


Select id,
    account_id,
    DATE_TRUNC('year', occurred_at) as year,
    Dense_Rank() Over account_year_window as dense_rank,
    total_amt_usd,
    Sum(total_amt_usd) Over account_year_window as sum_total_amt_usd,
    Count(total_amt_usd) Over account_year_window as count_total_amt_usd,
    AVG(total_amt_usd) Over account_year_window as avg_total_amt_usd,
    MIN(total_amt_usd) Over account_year_window as min_total_amt_usd,
    MAX(total_amt_usd) Over account_year_window as max_total_amt_usd
From orders WINDOW account_year_window AS (
        PARTITION BY account_id
        ORDER BY DATE_TRUNC('year', occurred_at)
    ) 

--------- Comparing Row to Preview Row - LAG ------------
-- LAG function : Returns the value of the previous row to the current row. 
SELECT account_id,
    standard_sum,
    LAG(standard_sum) OVER(
        ORDER BY standard_sum
    ) AS lag,
    LEAD(standard_sum) OVER (
        ORDER BY standard_sum
    ) AS lead,
    standard_sum - LAG(standard_sum) OVER (
        ORDER BY standard_sum
    ) AS lag_difference,
    LEAD(standard_sum) OVER (
        ORDER BY standard_sum
    ) - standard_sum AS lead_difference
FROM (
        SELECT account_id,
            SUM(standard_qty) AS standard_sum
        FROM orders
        GROUP BY 1
    ) sub 
    
--- Lead Function : Return the value from the row following the current row in the table.
SELECT account_id,
    standard_sum,
    LEAD(standard_sum) OVER (
        ORDER BY standard_sum
    ) AS lead,
    LEAD(standard_sum) OVER (
        ORDER BY standard_sum
    ) - standard_sum AS lead_difference
FROM (
        SELECT account_id,
            SUM(standard_qty) AS standard_sum
        FROM orders
        GROUP BY 1
    ) sub 
    
    -- When you need to compare the values in adjacent rows or rows that are offset by a certain number, LAG and LEAD come in very handy.
    --- Imagine you're an analyst at Parch & Posey and you want to determine how the current order's total revenue ("total" meaning from sales of all types of paper) compares to the next order's total revenue.
SELECT occurred_at,
    total_amt_usd,
    LEAD(total_amt_usd) OVER (
        ORDER BY occurred_at
    ) AS lead,
    LEAD(total_amt_usd) OVER (
        ORDER BY occurred_at
    ) - total_amt_usd AS lead_difference
FROM (
        SELECT occurred_at,
            SUM(total_amt_usd) AS total_amt_usd
        FROM orders
        GROUP BY 1
    ) sub 
    
    -- Percentiles: Percentiles help better describe large datasets
    NTILE( # of buckets) Over (Order by ranking_column) as new_column_name
        -- Format example
        SELECT customer_id,
            composite_score,
            NTILE(100) OVER(
                ORDER BY composite_score
            ) AS percentile
        FROM customer_lead_score;
-- Use the NTILE functionality to divide the accounts into 4 levels in terms of the amount of standard_qty for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of standard_qty paper purchased, and one of four levels in a standard_quartile column.
Select account_id,
    occurred_at,
    standard_qty,
    NTILE(4) OVER (
        Partition by account_id
        Order by standard_qty
    ) as standard_quartile
From orders
Order by 4 DESC;
-- Use the NTILE functionality to divide the accounts into two levels in terms of the amount of gloss_qty for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of gloss_qty paper purchased, and one of two levels in a gloss_half column.
Select account_id,
    occurred_at,
    gloss_qty,
    NTILE(2) OVER (
        Partition by account_id
        Order by gloss_qty
    ) as gloss_quartile
From orders
Order by 4 DESC;
-- Use the NTILE functionality to divide the orders for each account into 100 levels in terms of the amount of total_amt_usd for their orders. Your resulting table should have the account_id, the occurred_at time for each order, the total amount of total_amt_usd paper purchased, and one of 100 levels in a total_percentile column.
Select account_id,
    occurred_at,
    total_amt_usd,
    NTILE(100) OVER (
        Partition by account_id
        Order by total_amt_usd
    ) as total_quartile
From orders
Order by 1 DESC;