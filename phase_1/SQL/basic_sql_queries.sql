SELECT * From Orders;

-- Write a query to return the 10 earliest orders in the orders table

Select id, occurred_at, total_amt_usd From orders ORDER BY occurred_at  Limit 10;

--Write a query to return the top 5 orders in terms of the largest total_amt_usd. Include the id, account_id, and total_amt_usd.
Select id, account_id, total_amt_usd From orders ORDER BY total_amt_usd DESC Limit 5;


--Write a query to return the lowest 20 orders in terms of the smallest total_amt_usd. Include the id, account_id, and total_amt_usd.
Select id, account_id, total_amt_usd From orders ORDER BY total_amt_usd  Limit 20;

--Write a query that displays the order ID, account ID, and total dollar amount for all the orders, sorted first by the account ID (in ascending order), and then by the total dollar amount (in descending order).
Select id, account_id, total_amt_usd 
From orders
Order by account_id, total_amt_usd DESC;

-- Now write a query that again displays order ID, account ID, and total dollar amount for each order, but this time sorted first by total dollar amount (in descending order), and then by account ID (in ascending order).
Select id, account_id, total_amt_usd
From orders
ORDER BY total_amt_usd DESC, account_id;


-- Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. Limit the results to the first 10 orders, and include the id and account_id fields.
Select id, account_id, standard_amt_usd/standard_qty as standard_paper_unit_price
From orders
Limit 10;

-- Write a query that finds the percentage of revenue that comes from poster paper for each order. You will need to use only the columns that end with _usd. (Try to do this without using the total column.) Display the id and account_id fields also.

Select id, account_id, (poster_amt_usd / (standard_amt_usd + gloss_amt_usd + poster_amt_usd)) * 100 as percentage_revenue_poster_paper
From orders
Limit 10;

-- Use the accounts table to find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.
Select name, primary_poc, sales_rep_id
From accounts
Where name in ('Walmart', 'Target', 'Nordstrom');

-- Use the web_events table to find all information regarding individuals who were contacted via the channel of organic or adwords.
Select * 
From web_events 
Where channel in ('organic', 'adwords');

-- Quiz using AND and Between Operators
Select * 
From orders
Where standard_qty > 1000 and poster_qty = 0 and gloss_qty = 0;

Select *
From accounts
Where name not like 'C%' and name not like '%s';

Select occurred_at, gloss_qty
From orders
Where gloss_qty between 24 and 29
Order by gloss_qty;

Select *
From web_events
Where channel in ('organic', 'adwords') and occurred_at >= '2016-01-01'
Order by occurred_at DESC;
