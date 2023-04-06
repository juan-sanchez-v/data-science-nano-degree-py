/*
Betleman Data Science with Python Nano Degree - Project 1
Author: 	Juan Sanchez
Date: 		04-05-2023

Question # 1:

*/

-- film_details table Joins the film_category and film table to get a list of all the films and their category
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
		Group by i.film_id
)
Select fd.title, fd.category, rh.rental_count
From film_details fd
Join rental_history rh
On fd.film_id = rh.film_id
Order by category, title;