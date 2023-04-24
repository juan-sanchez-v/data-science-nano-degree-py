/*
QUESTION SET #1 - Q1
We want to understand more about the movies that families are watching. The following categories are considered family movies: Animation, Children, Classics, Comedy, Family and Music.

Create a query that lists each movie, the film category it is classified in, and the number of times it has been rented out.

For this query, you will need 5 tables: Category, Film_Category, Inventory, Rental and Film. Your solution should have three columns: Film title, Category name and Count of Rentals.
*/

SELECT f.title as title,
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

/*
Question Set#1 - Question 2
Now we need to know how the length of rental duration of these family-friendly movies compares to the duration that all movies are rented for. Can you provide a table with the movie titles and divide them into 4 levels (first_quarter, second_quarter, third_quarter, and final_quarter) based on the quartiles (25%, 50%, 75%) of the average rental duration(in the number of days) for movies across all categories? Make sure to also indicate the category that these family-friendly movies fall into.

Using Family friendly movie only and NTILE(4) for the quartile
*/

SELECT f.title,
       c.name as category_name,
       f.rental_duration,
	   NTILE(4) Over( Order by f.rental_duration) as standard_quartile
FROM film f
    JOIN film_category fc
        ON f.film_id = fc.film_id
    JOIN Category c
        ON fc.category_id = c.category_id
WHERE LOWER(c.name) IN ( 'animation', 'children', 'classics', 'comedy', 'family', 'music' )
ORDER BY 4;




/*
Question Set#1 - Question 3
Finally, provide a table with the family-friendly film category, each of the quartiles, and the corresponding count of movies within each combination of film category for each corresponding rental duration category. The resulting table should have three columns:

Category
Rental length category
Count

Using Family friendly movie only and NTILE(4) for the quartile
*/

With fam_friendly_movies AS (
SELECT f.title,
       c.name as category_name,
       f.rental_duration,
	   NTILE(4) Over( Order by f.rental_duration) as standard_quartile
FROM film f
    JOIN film_category fc
        ON f.film_id = fc.film_id
    JOIN Category c
        ON fc.category_id = c.category_id
WHERE LOWER(c.name) IN ( 'animation', 'children', 'classics', 'comedy', 'family', 'music' )

)
Select category_name as name,
		standard_quartile,
		Count(*)
FROM fam_friendly_movies
Group By 1,2
Order by 1,2