-- Question # 1:
/*
This is a comment
*/
With film_details as (
		Select f.film_id, f.title, c.name as category
		From film f
		Join film_category fc
		On f.film_id = fc.film_id
		Join Category c
		On fc.category_id = c.category_id

),
rental_history as (
		Select i.film_id, count(*) as rental_count
		From rental r
		Join inventory i
		On r.inventory_id = i.inventory_id
		Group by 1
		Order by i.film_id
)
Select fd.title, fd.category, rh.rental_count
From film_details fd
Join rental_history rh
On fd.film_id = rh.film_id
Order by category, title;