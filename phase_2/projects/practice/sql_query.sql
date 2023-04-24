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