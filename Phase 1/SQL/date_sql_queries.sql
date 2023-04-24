-- DATE_TRUNC allows you to truncate your date to a particular part of your date-time column. Common truncations are day, month, and year. NOTE: Group by 1 means group by the 1st column.

Select DATE_TRUNC('day', occurred_at) as day, SUM(standard_qty) as standard_qty_sum
FROM demo.orders
Group by 1
Order BY 1;

-- DATE_TRUNC('second', 2017-04-01 12:15:01)
-- DATE_TRUNC('day', 2017-04-01 12:15:01)
-- DATE_TRUNC('month', 2017-04-01 12:15:01)
-- DATE_TRUNC('year', 2017-04-01 12:15:01)

-- DATE_PART can be useful for pulling a specific portion of a date, but notice pulling month or day of the week (dow) means that you are no longer keeping the years in orde

-- DATE_PART('year', date)

-- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?
Select DATE_PART('year', occurred_at) as year, SUM(total_amt_usd) as yearly_sales
From orders
Group by 1
Order by 2;


-- Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?
Select DATE_TRUNC('month', occurred_at) as month, SUM(total_amt_usd) as total_sales
From Orders
Group by 1
Order by 2 DESC;

-- removing 2013 and 2017 since there are only one month worth of sale in the data for each year. That is why each month
-- is not evenly distributed in the data.
SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC;

-- Which year did Parch & Posey have the greatest sales in terms of the total number of orders? Are all years evenly represented by the dataset?
Select DATE_Part('year', occurred_at) as year,
Count(*) as total_orders
From orders
Group by 1
Order by 2 DESC;

-- Which month did Parch & Posey have the greatest sales in terms of the total number of orders? Are all months evenly represented by the dataset?
Select DATE_TRUNC('month', occurred_at) as month, SUM(total_amt_usd) as total_sales
From Orders
Group by 1
Order by 2 DESC;

-- In which month of which year did Walmart spend the most on gloss paper in terms of dollars?
Select DATE_TRUNC('month', o.occurred_at) as month,
SUM(o.gloss_amt_usd) as monthly_gloss_spent_usd
From orders o 
Join accounts a
On o.account_id = a.id
Where a.name = 'Walmart'
Group by 1
Order by 2 DESC;