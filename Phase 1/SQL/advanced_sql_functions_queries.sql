-- Full outer Joins : A full outer join returns unmatched records in each table with null values for the columns that came from the opposite table.

SELECT column_name(s)
FROM Table_A
FULL OUTER JOIN Table_B ON Table_A.column_name = Table_B.column_name;

-- adding WHERE Table_A.column_name IS NULL OR Table_B.column_name IS NULL will return unmatched rows only.


-- Join without an Equal sign




-- Join with inequalities
Select a.name as account,
	   a.primary_poc,
       s.name as sale_rep
FROM accounts a
Left Join sales_reps s
On a.sales_rep_id = s.id
AND a.primary_poc < s.name;

-- Self Join

-- Select orders that happen after the first order and withing 28 days 
SELECT o1.id AS o1_id,
       o1.account_id AS o1_account_id,
       o1.occurred_at AS o1_occurred_at,
       o2.id AS o2_id,
       o2.account_id AS o2_account_id,
       o2.occurred_at AS o2_occurred_at
FROM   orders o1
LEFT JOIN orders o2
ON     o1.account_id = o2.account_id
AND    o2.occurred_at > o1.occurred_at
AND    o2.occurred_at <= o1.occurred_at + INTERVAL '28 days'
ORDER BY o1.account_id, o1.occurred_at

-- Using the web table
SELECT we1.id AS we_id,
       we1.account_id AS we1_account_id,
       we1.occurred_at AS we1_occurred_at,
       we1.channel AS we1_channel,
       we2.id AS we2_id,
       we2.account_id AS we2_account_id,
       we2.occurred_at AS we2_occurred_at,
       we2.channel AS we2_channel
  FROM web_events we1 
 LEFT JOIN web_events we2
   ON we1.account_id = we2.account_id
  AND we1.occurred_at > we2.occurred_at
  AND we1.occurred_at <= we2.occurred_at + INTERVAL '1 day'
ORDER BY we1.account_id, we2.occurred_at


--- Union: combine two or more tables together
--- Union removes duplicates
--- Union all does not remove duplicate rows
Select *
From web_events as w1

Union 

Select *
From web_events as w2

--- You more likely use union all more often that just union

SELECT *
FROM web_events
WHERE channel = 'facebook'
UNION ALL
SELECT *
FROM web_events_2

-- Performing actions on the Union result 
CREATE VIEW web_events_2
AS (SELECT * FROM web_events)

WITH web_events AS (
      SELECT *
      FROM web_events
      UNION ALL
      SELECT *
      FROM web_events_2
     )
SELECT channel,
       COUNT(*) AS sessions
FROM  web_events
GROUP BY 1
ORDER BY 2 DESC

-- Performance tunning 
-- Reduce the number of calculation in your queries.
-- Reduce joins, table size and Aggregations

-- Filter the data to include the observations you need will improve the performance of the queries
-- Limit the subquery to test and run your aggregations faster
-- Limit on an Aggregated or Group By query will not do much since the aggregation happens first.
-- If you limit the result set in the subquery, you can speed up the process when building the query.

SELECT account_id,
       SUM(poster_qty) AS sum_poster_qty
FROM   (SELECT * FROM orders LIMIT 100) sub
WHERE  occurred_at >= '2016-01-01'
AND    occurred_at < '2016-07-01'
GROUP BY 1;

-- Make your Join less complicated
-- Do the agregations on one table first and then use subquery to join the outer table

SELECT a.name,
       sub.web_events
FROM   (SELECT account.id,
       COUNT( AS web_events
       FROM web_events
        GROUP BY 1) sub
JOIN   accounts a 
ON     a.id = sub.account_id
ORDER BY 2 DESC

-- Explain
-- You can add Explain before any query to see how long it will take.
-- It is not 100% accurate but it is a usefull tool.

EXPLAIN
SELECT *
FROM   web_events
WHERE  occurred_at >='2016-01-01'
AND    occurred_at < '2016-02-01'

EXPLAIN
SELECT *
FROM   web_events
WHERE  occurred_at >='2016-01-01'
AND    occurred_at < '2016-02-01'
LIMIT 100

-- Joining Subqueries
-- Count Distinct takes a long time
SELECT DATE_TRUNC('day', o.occurred_at) AS date,
       COUNT(DISTINCT a.sales_rep_id) AS active_sales_reps,
       COUNT(DISTINCT o.id) AS orders
FROM   accounts a
JOIN   orders o
ON     o.account_id = a.id
GROUP BY 1

SELECT DATE_TRUNC('day', we.occurred_at) AS date,
       COUNT(we.id) AS web_visits
FROM   web_events we
GROUP BY 1


SELECT COALESCE(orders.date, web_events.date) AS date,
       orders.active_sales_reps,
       orders.orders,
       web_events.web_visits
FROM(  
   SELECT DATE_TRUNC('day', o.occurred_at) AS date,
          COUNT(DISTINCT a.sales_rep_id) AS active_sales_reps,
          COUNT(DISTINCT o.id) AS orders
   FROM   accounts a
   JOIN   orders o
   ON     o.account_id = a.id
   GROUP BY 1) AS orders

FULL JOIN(
   SELECT DATE_TRUNC('day', we.occurred_at) AS date,
          COUNT(we.id) AS web_visits
   FROM   web_events we
   GROUP BY 1) AS web_events

ON orders.date = web_events.date
ORDER BY 1 DESC