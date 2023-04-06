Select DATE_PART('day', return_date::timestamp - rental_date::timestamp) 	as rental_duration_days,
       DATE_PART('hour', return_date::timestamp - rental_date::timestamp) 	as rental_duration_hours,
	   (CAST(DATE_PART('day', return_date::timestamp - rental_date::timestamp) as numeric) * 24 +
	   DATE_PART('hour', return_date::timestamp - rental_date::timestamp)) / 24	as total_rental_days
From rental
Where return_date is not null
Order by rental_duration_days, rental_duration_hours;


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


-- Get the top paying customers first

With top_ten_paying_customers as(
Select customer_id,
		SUM(amount) as total_paid
From payment 
Group by customer_id
Order by total_paid DESC
Limit 10
) 
Select c.customer_id, 
	   c.first_name,
	   c.last_name,
	   DATE_PART('year', p.payment_date) as payment_year,
	   DATE_PART('month', p.payment_date) as payment_month,
	   DATE_TRUNC('month', p.payment_date) as payment_date_trunc,
	   SUM(amount) as monthly_paid,
	   Count(*) as payment_count
FROM customer c
JOIN top_ten_paying_customers t
ON c.customer_id = t.customer_id
Join payment p
ON c.customer_id = p.customer_id
Group by 1,2,3,4,5,6
order by c.customer_id



-- Or user a condensed version
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