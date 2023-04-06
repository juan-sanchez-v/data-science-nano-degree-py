/*
Betleman Data Science with Python Nano Degree - Project 1
Author:   Juan Sanchez
Date:     04-05-2023

*/

/*
QUESTION SET #1 - Q1
We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.

Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.

For this query, you will need 5 tables: Category, Film_Category, Inventory, Rental and Film. Your solution should have three columns: Film title, Category name and Count of Rentals.
*/
SELECT 
  f.title AS film_title, 
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
GROUP BY 
  1, 
  2 
ORDER BY 
  2;
  
/*
Question Set#1 - Question 2

Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for. Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the average rental duration(in the number of days) for movies across all categories? Make sure to also indicate the category that these family-friendly movies fall into.

Using Family friendly movie only and NTILE(4) for the quartile
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
Question Set#1 - Question 3
Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category. The resulting table should have three columns:

Category
Rental length category
Count

Using Family friendly movie only and NTILE(4) for the quartile
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
    Question Set # 2 - Q1
  
    We want to find out how the two stores compare in their count of rental orders during every month for all the years we have data for. Write a query that returns the store ID for the store, the year and month and the number of rental orders each store has fulfilled for that month. Your table should include a column for each of the following: year, month, store ID and count of rental orders fulfilled during that month.
  
    The query below uses the inventory table instead of the staff table.
  
    */
SELECT 
  date_part('month', r.rental_date) AS rental_month, 
  date_part('year', r.rental_date) AS rental_year, 
  i.store_id, 
  count(*) AS count_rentals 
FROM 
  inventory i 
  JOIN rental r ON i.inventory_id = r.inventory_id 
GROUP BY 
  1, 
  2, 
  3 
ORDER BY 
  rental_month DESC, 
  rental_year, 
  count_rentals;
/*
Question Set #2 - Q2
We would like to know who were our top 10 paying customers, how many payments they made on a monthly basis during 2007, and what was the amount of the monthly payments. Can you write a query to capture the customer name, month and year of payment, and total payment amount for each month by these top 10 paying customers?

*/
-- Get the top 10 paying customers
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
) 
SELECT 
  c.customer_id, 
  concat(c.first_name, ' ', c.last_name) AS fullname, 
  date_trunc('month', p.payment_date) AS pay_mon, 
  count(*) AS pay_countpermon, 
  sum(amount) AS pay_amount 
FROM 
  customer c 
  JOIN top_ten_paying_customers t ON c.customer_id = t.customer_id 
  JOIN payment p ON c.customer_id = p.customer_id 
WHERE 
  date_part('year', p.payment_date) = 2007 
GROUP BY 
  1, 
  2, 
  3 
ORDER BY 
  2;
/*
Question Set #2 - Q3
Finally, for each of these top 10 paying customers, I would like to find out the difference across their monthly payments during 2007. Please go ahead and write a query to compare the payment amounts in each successive month. Repeat this for each of these 10 paying customers. Also, it will be tremendously helpful if you can identify the customer name who paid the most difference in terms of payments.

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
