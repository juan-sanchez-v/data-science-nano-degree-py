/*
Betleman Data Science with Python Nano Degree - Project 1
Author: 	Juan Sanchez
Date: 		04-05-2023

*/

/*
QUESTION SET #1 - Q1
We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.

Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.

For this query, you will need 5 tables: Category, Film_Category, Inventory, Rental and Film. Your solution should have three columns: Film title, Category name and Count of Rentals.
*/

SELECT f.title as film_title,
       c.name as category_name,
       COUNT(r.rental_id) rental_count
FROM film f
    JOIN film_category fc
        ON f.film_id = fc.film_id
    JOIN Category c
        ON fc.category_id = c.category_id
    JOIN inventory i
        ON i.film_id = f.film_id
    JOIN rental r
        ON r.inventory_id = i.inventory_id
WHERE LOWER(c.name) IN ( 'animation', 'children', 'classics', 'comedy', 'family', 'music' )
GROUP BY 1,2
ORDER by 2;


-- Question Set # 2
-- Q1.Using the Inventory table for store ID

Select i.store_id, 
		DATE_PART('year', r.rental_date) as rental_year, 
		DATE_PART('month', r.rental_date) as rental_month,
		Count(*) as rental_count_per_month
From inventory i 
Join rental r
ON i.inventory_id = r.inventory_id
Group By 1,2,3
Order by i.store_id, rental_year, rental_month;

/*
Q: Top payment customer montlhy payment with payment count

*/

With top_ten_paying_customers as(
	Select customer_id,
	SUM(amount) as total_paid
	From payment 
	Group by customer_id
	Order by total_paid DESC
	Limit 10
) 
Select c.customer_id, 
	   CONCAT(c.first_name, ' ',c.last_name) as customer_name,
	   LEFT(CAST(p.payment_date as character varying(12)), 7) as payment_date,
	   SUM(amount) as monthly_paid,
	   Count(*) as payment_count
FROM customer c
JOIN top_ten_paying_customers t
ON c.customer_id = t.customer_id
Join payment p
ON c.customer_id = p.customer_id
Where DATE_PART('year', p.payment_date) = 2007
Group by 1,2,3
order by c.customer_id;


/*

Question 2:

*/

-- Final
WITH top_ten_paying_customers as(
		Select customer_id,
			SUM(amount) as total_paid
			From payment 
			Group by customer_id
			Order by total_paid DESC
			Limit 10
		), 
	t1 as (
	Select customer_id, 
	   customer_name, 
	   payment_date, 
	   payment_count, 
	   monthly_paid,  
	   LAG(monthly_paid) OVER customer_monthly_payment_window as lag_montly_paid,
	   monthly_paid - LAG(monthly_paid) OVER customer_monthly_payment_window as monthly_paid_diff
FROM (
		
		Select c.customer_id, 
			   CONCAT(c.first_name, ' ',c.last_name) as customer_name,
			   LEFT(CAST(p.payment_date as character varying(12)), 7) as payment_date,
			   SUM(amount) as monthly_paid,
			   Count(*) as payment_count
		FROM customer c		
		Join payment p
		ON c.customer_id = p.customer_id
		Where DATE_PART('year', p.payment_date) = 2007 AND 
		c.customer_id IN (Select customer_id from top_ten_paying_customers)
		Group by 1,2,3		
	) SUB WINDOW customer_monthly_payment_window AS(
		Partition by customer_id 
		Order by payment_date
	)
)
Select *, 
CASE WHEN monthly_paid_diff = (SELECT MAX(monthly_paid_diff) from t1)  THEN 'T' 
	 ELSE null END AS max_spent_customer
From t1;