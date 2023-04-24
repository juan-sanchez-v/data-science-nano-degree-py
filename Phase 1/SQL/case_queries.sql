-- Case When channel = 'facebook' THEN 'yes' ELSE 'no' END AS is_facebook
-- Case When channel = 'facebook' OR channel = 'direct' THEN 'yes' ELSE 'no' END AS is_facebook

-- CASE must include the following components: WHEN, THEN, and END. ELSE is an optional component to catch cases that didn’t meet any of the other previous CASE conditions.
-- You can make any conditional statement using any conditional operator (like WHERE) between WHEN and THEN. This includes stringing together multiple conditional statements using AND and OR.


Select account_id,
occurred_at,
total,
Case WHEN total > 500 THEN 'Over 500'
    WHEN total > 300 AND total < = 500 THEN '301 - 500'
    WHEN total > 100 AND total < = 300 THEN '101 - 300'
    ELSE '100 or under' END AS total_group
FROM orders;


-- Division by 0
SELECT account_id, CASE WHEN standard_qty = 0 OR standard_qty IS NULL THEN 0
                        ELSE standard_amt_usd/standard_qty END AS unit_price
FROM orders
LIMIT 10;


-- Case and Agregation
-- Select bids over, at and under the reserve using agreation and case

--Write a query to display for each order, the account ID, the total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.
Select account_id, total_amt_usd, Case WHEN total_amt_usd > 3000 THEN 'Large' ELSE 'Small' END AS order_level
From orders
Group by 1,2;


-- Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.
Select CASE WHEN total >= 2000 THEN 'At Least 2000'
			WHEN total < 2000 AND total >= 1000 THEN 'Between 1000 and 2000'
            WHEN total < 1000 THEN 'Less than 1000' END AS category,
            Count(*) as num_orders
FROM orders
Group by 1;

-- We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top-level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.
