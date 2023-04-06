/*
Author: 	Juan Sanchez
Date  : 	04-06-2023
Project:	SQL Exploration 
*/

/* Query 1 - query used for first insight.
NOTE: Movies under the following categories are considered family friendly: Animation, Children, Classics, Comedy, Family and Music.
Slighly modified version of Question 1 in Question Set # 1.
*/

SELECT   
  c.name AS category_name, 
  count(r.rental_id) rental_count
FROM 
  film f 
  JOIN film_category fc ON f.film_id = fc.film_id 
  JOIN category c ON fc.category_id = c.category_id 
  JOIN inventory i ON i.film_id = f.film_id 
  JOIN rental r ON r.inventory_id = i.inventory_id 
WHERE 
  lower(c.name) IN (
    'animation', 'children', 'classics', 
    'comedy', 'family', 'music'
  ) 
GROUP BY category_name;


/*
Query 2 - query used for second insight.
Question from Question Set #1
*/

SELECT 
  f.title, 
  c.name AS category_name, 
  f.rental_duration, 
  ntile(4) over(
    ORDER BY 
      f.rental_duration
  ) AS standard_quartile 
FROM 
  film f 
  JOIN film_category fc ON f.film_id = fc.film_id 
  JOIN category c ON fc.category_id = c.category_id 
WHERE 
  lower(c.name) IN (
    'animation', 'children', 'classics', 
    'comedy', 'family', 'music'
  ) 
ORDER BY 
  4;


  /*
Query 3 - query used for third insight
  */
  WITH fam_friendly_movies AS (
  SELECT 
    f.title, 
    c.name AS category_name, 
    f.rental_duration, 
    ntile(4) over(
      ORDER BY 
        f.rental_duration
    ) AS standard_quartile 
  FROM 
    film f 
    JOIN film_category fc ON f.film_id = fc.film_id 
    JOIN category c ON fc.category_id = c.category_id 
  WHERE 
    lower(c.name) IN (
      'animation', 'children', 'classics', 
      'comedy', 'family', 'music'
    )
) 
SELECT 
  category_name AS name, 
  standard_quartile, 
  count(*) 
FROM 
  fam_friendly_movies 
GROUP BY 
  1, 
  2 
ORDER BY 
  1, 
  2 

  /*
Querry 4 - query used for the fourth insight.
  */
WITH top_ten_paying_customers AS (
  SELECT 
    customer_id, 
    sum(amount) AS total_paid 
  FROM 
    payment 
  GROUP BY 
    customer_id 
  ORDER BY 
    total_paid DESC 
  LIMIT 
    10
), t1 AS (
  SELECT 
    customer_id, 
    fullname, 
    pay_mon, 
    pay_countpermon, 
    pay_amount, 
    lag(pay_amount) OVER customer_monthly_payment_window AS lag_montly_paid, 
    pay_amount - lag(pay_amount) OVER customer_monthly_payment_window AS monthly_paid_diff 
  FROM 
    (
      SELECT 
        c.customer_id, 
        concat(c.first_name, ' ', c.last_name) AS fullname, 
        date_trunc('month', p.payment_date) AS pay_mon, 
        sum(amount) AS pay_amount, 
        count(*) AS pay_countpermon 
      FROM 
        customer c 
        JOIN payment p ON c.customer_id = p.customer_id 
      WHERE 
        date_part('year', p.payment_date) = 2007 
        AND c.customer_id IN (
          SELECT 
            customer_id 
          FROM 
            top_ten_paying_customers
        ) 
      GROUP BY 
        1, 
        2, 
        3
    ) sub WINDOW customer_monthly_payment_window AS(
      PARTITION BY customer_id 
      ORDER BY 
        pay_mon
    )
) 
SELECT 
  *, 
  CASE WHEN monthly_paid_diff = (
    SELECT 
      max(monthly_paid_diff) 
    FROM 
      t1
  ) THEN 'T' ELSE NULL END AS max_spent_customer 
FROM 
  t1;