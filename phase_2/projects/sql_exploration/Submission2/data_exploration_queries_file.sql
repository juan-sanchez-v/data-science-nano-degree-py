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
    COUNT(r.rental_id) rental_count
FROM
    film f
    JOIN film_category fc ON f.film_id = fc.film_id
    JOIN category c ON fc.category_id = c.category_id
    JOIN inventory i ON i.film_id = f.film_id
    JOIN rental r ON r.inventory_id = i.inventory_id
WHERE
    LOWER(c.name) IN ('animation', 'children', 'classics', 'comedy', 'family', 'music')
GROUP BY
    category_name;

/* Query 2 - query used for second insight. */
SELECT
    title,
    category_name,
    CONCAT(title, ' - ', category_name) AS title_category,
    rental_count
FROM
    (
        WITH
            movie_rentals AS (
                SELECT
                    i.film_id,
                    DATE_TRUNC('year', r.rental_date) AS rent_year,
                    COUNT(*) AS rental_count
                FROM
                    rental r
                    JOIN inventory AS i ON r.inventory_id = i.inventory_id
                WHERE
                    DATE_PART('year', rental_date) = '2005'
                GROUP BY
                    i.film_id,
                    rent_year
            ),
            non_family_friendly_movies AS (
                SELECT          -- Filter our family friendly categories
                    category_id
                FROM
                    category
                WHERE
                    LOWER(NAME) NOT IN ('animation', 'children', 'classics', 'comedy', 'family', 'music')
            )
        SELECT
            f.title,
            mr.rental_count,
            c.name AS category_name,
            DENSE_RANK() OVER (    -- Rank top movie for each category
                PARTITION BY
                    fc.category_id
                ORDER BY
                    mr.rental_count DESC
            ) AS ranking
        FROM
            film AS f
            JOIN movie_rentals AS mr ON f.film_id = mr.film_id
            JOIN film_category AS fc ON f.film_id = fc.film_id
            JOIN category c ON fc.category_id = c.category_id
            AND c.category_ID IN ( 
                SELECT
                    *
                FROM
                    non_family_friendly_movies
            )
    ) AS derived_table
WHERE
    ranking = 1  
ORDER BY
    title_category,
    rental_count;

/*Query 3 - query used for third insight */
WITH
    fam_friendly_movies AS (
        SELECT
            f.title,
            c.name AS category_name,
            f.rental_duration,
            NTILE(4) OVER (
                ORDER BY
                    f.rental_duration
            ) AS standard_quartile
        FROM
            film f
            JOIN film_category fc ON f.film_id = fc.film_id
            JOIN category c ON fc.category_id = c.category_id
        WHERE
            LOWER(c.name) IN ('animation', 'children', 'classics', 'comedy', 'family', 'music' )
    )
SELECT
    category_name AS NAME,
    standard_quartile,
    COUNT(*)
FROM
    fam_friendly_movies
GROUP BY
    category_name,
    standard_quartile
ORDER BY
    category_name,
    standard_quartile;
    
/* Querry 4 - query used for the fourth insight.  */
WITH
    top_ten_paying_customers AS (
        SELECT
            customer_id,
            SUM(amount) AS total_paid
        FROM
            payment
        GROUP BY
            customer_id
        ORDER BY
            total_paid DESC
        LIMIT
            10
    ),
    t1 AS (
        SELECT
            customer_id,
            fullname,
            pay_mon,
            pay_countpermon,
            pay_amount,
            LAG(pay_amount) OVER customer_monthly_payment_window AS lag_montly_paid,
            pay_amount - LAG(pay_amount) OVER customer_monthly_payment_window AS monthly_paid_diff
        FROM
            (
                SELECT
                    c.customer_id,
                    CONCAT(c.first_name, ' ', c.last_name) AS fullname,
                    DATE_TRUNC('month', p.payment_date) AS pay_mon,
                    SUM(amount) AS pay_amount,
                    COUNT(*) AS pay_countpermon
                FROM
                    customer c
                    JOIN payment p ON c.customer_id = p.customer_id
                WHERE
                    DATE_PART('year', p.payment_date) = 2007
                    AND c.customer_id IN (
                        SELECT
                            customer_id
                        FROM
                            top_ten_paying_customers
                    )
                GROUP BY
                    c.customer_id,
                    fullname,
                    pay_mon
            ) sub
        WINDOW
            customer_monthly_payment_window AS (
                PARTITION BY
                    customer_id
                ORDER BY
                    pay_mon
            )
    )
SELECT
    *,
    CASE
        WHEN monthly_paid_diff = (
            SELECT
                MAX(monthly_paid_diff)
            FROM
                t1
        ) THEN 'T'
        ELSE NULL
    END AS max_spent_customer
FROM
    t1;