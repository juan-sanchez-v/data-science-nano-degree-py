-- Subquery
-- Use subqueries when you have the need to manipulate an existing table to sudo-create a table that is then used as part of a larger query.
-- With example
--WITH subquery_name (column_name1,...) AS (
--  SELECT...
--)
--SELECT...

-- Inline example
SELECT student_name
FROM (
    SELECT student_id,
      student_name,
      grade
    FROM student
    WHERE teacher = 10
  ) d
WHERE d.grade > 80;

-- Nested example
SELECT s.s_id,
  s.s_name,
  g.final_grade
FROM student s,
  grades g
WHERE s.s_id = g.s_id IN (
    SELECT final_grade
    FROM grades g
    WHERE final_grade > 3.7
  );
-- Scalar example
SELECT s.student_name (
    SELECT AVG(final_score)
    FROM grades g
    WHERE g.student_id = s.student_id
  ) AS avg_score
FROM student s;
-- steps to build a subquery
-- Build the Subquery: The aggregation of an existing table that you’d like to leverage as a part of the larger query.
-- Run the Subquery: Because a subquery can stand independently, it’s important to run its content first to get a sense of whether this aggregation is the interim output you are expecting.
-- Encapsulate and Name: Close this subquery off with parentheses and call it something. In this case, we called the subquery table ‘sub.’
-- Test Again: Run a SELECT * within the larger query to determine if all syntax of the subquery is good to go.
-- Build Outer Query: Develop the SELECT * clause as you see fit to solve the problem at hand, leveraging the subquery appropriately.
Select Date_TRUNC('day', occurred_at) as day,
  channel,
  Count(*) as event_count
From web_events
Group by 1,
  2
Order by 3 DESC;
Select channel,
  AVG(event_count) as daily_avg
FROM (
    Select Date_TRUNC('day', occurred_at) as day,
      channel,
      Count(*) as event_count
    From web_events
    Group by 1,
      2
  ) sub
Group by channel
Order by 2;
-- Example of Subquery that return orders placed in the month that the first order was placed
-- You dont need an alias when you write a subquery in a Conditional Statement.
Select *
From orders
Where Date_TRUNC('month', occurred_at) = (
    Select DATE_TRUNC('month', MIN(occurred_at)) as min_month
    From orders
  )
ORDER BY occurred_at;
-- Quiz
--  Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.
Select t3.sname as name,
  t3.reg_name as region,
  t3.total_sold_usd as max_sold
FROM (
    Select s.name as sname,
      r.name as reg_name,
      SUM(o.total_amt_usd) as total_sold_usd
    From sales_reps s
      Join accounts a On s.id = a.sales_rep_id
      Join orders o On a.id = o.account_id
      Join region rr ON r.id = s.region_id
    Group by 1,
      2
  ) t3
  JOIN (
    Select t1.reg_name,
      MAX(total_sold_usd) as max_sold
    FROM (
        Select s.name as sname,
          r.name as reg_name,
          SUM(o.total_amt_usd) as total_sold_usd
        From sales_reps s
          Join accounts a On s.id = a.sales_rep_id
          Join orders o On a.id = o.account_id
          Join region r On r.id = s.region_id
        Group by 1,
          2
      ) t1
    Group by 1
  ) t2 
  ON t2.reg_name = t3.reg_name
  AND t3.total_sold_usd = t2.max_sold
Order by 1,  2;

-- For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed?
Select t3.name,
  t3.ct,
  t3.total
FROM (
    Select r.name as name,
      Count(*) as ct,
      SUM(total_amt_usd) as total
    From sales_reps s
      Join accounts a On s.id = a.sales_rep_id
      Join orders o On a.id = o.account_id
      Join region r On r.id = s.region_id
    Group by 1
  ) t3
  Join (
    Select Max(t1.total_sold_usd) as mx
    From (
        Select r.name as reg_name,
          SUM(o.total_amt_usd) as total_sold_usd
        From sales_reps s
          Join accounts a 
          On s.id = a.sales_rep_id
          Join orders o 
          On a.id = o.account_id
          Join region r 
          On r.id = s.region_id
        Group by 1
      ) t1
  ) t2 ON t3.total = t2.mx;
-- Subquery strategy
-- 1. Do I really need a subquery
-- 2. If needed, determine where you need to place it
-- 3. Run the subquery as an independent query first: is the output what you expect?
-- 4. Run the entire query -- both the inner and outer query.
-- WITH Exaple
-- With: statement "scoped" technique to improve the structure of the subquery
-- Advantageous for readability
With average_price as (
  Select brand_id,
    AVG(product_price) as brand_avg_price
  From products_records
)
Select a.brand_id,
  a.total_brand,
  b.brand_avg_price
From brand_table a
  Join average_price b 
  On b.brand_id = a.brand_id
ORDER BY a.total_brand_sales desc;
-- CTE stands for Common Table Expression. A CTE allows you to define a temporary result, such as a table, to then be reference in later part of the query.
-- You need to find the average number of events for each channel per day.
-- without WITH
SELECT channel,
  AVG(events) AS average_events
FROM (
    SELECT DATE_TRUNC('day', occurred_at) AS day,
      channel,
      COUNT(*) as events
    FROM web_events
    GROUP BY 1,
      2
  ) sub
GROUP BY channel
ORDER BY 2 DESC;
-- Use WITH
WITH events AS (
  SELECT DATE_TRUNC('day', occurred_at) AS day,
    channel,
    COUNT(*) as events
  FROM web_events
  GROUP BY 1, 2
)
SELECT channel,
  AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;
-- Multiple table in the WITH statement
WITH table1 AS (
  SELECT *
  FROM web_events
),
table2 AS (
  SELECT *
  FROM accounts
)
SELECT *
FROM table1
  JOIN table2 
  ON table1.account_id = table2.id;
-- Nested Subquery
-- Query with a subquery in the WHERE clause.
-- Used when we want to filter an output using a condition met from another table
-- Makes the code easy to read.
SELECT *
FROM students
WHERE student_id IN (
    SELECT DISTINCT student_id
    FROM gpa_table
    WHERE gpa > 3.5
  );
-- Inline Subquery
-- Very similar to the With subqueries. Creates a pseudo table.
-- Placed in the From clause
SELECT dept_name,
  max_gpa
FROM department_db x (
    SELECT dept_id MAX(gpa) as max_gpa
    FROM students
    GROUP BY dept_id
  ) y
WHERE x.dept_id = y.dept_id
ORDER BY dept_name;
-- Scalar subquery
-- Selects only one query or expresion and returns only one row. Used in the select clause of the main query
-- Advantageous for performance or when the data set is small
-- If a scalar subquery does not find a match, it returns a NULL.
-- If a scalar subquery finds multiple matches, it reutnrs an Error.
SELECT (
    SELECT MAX(salary)
    FROM employees_db
  ) AS top_salary,
  employee_name
FROM employees_db;