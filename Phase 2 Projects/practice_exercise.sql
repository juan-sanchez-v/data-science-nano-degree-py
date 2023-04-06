/*

Provides the following details: actor's first and last name combined as full_name, film title, film description and length of the movie.

*/
Select CONCAT(a.first_name, ' ', a.last_name) as full_name,
	   f.title,
	   f.description,
	   f.length
FROM actor a
Join film_actor fa
ON a.actor_id = fa.actor_id
Join film f
ON f.film_id = fa.film_id
-- Where f.length > 60;


/*
Query that captures the actor id, full name of the actor, and counts the number of movies each actor has made
*/

Select  a.actor_id,
		CONCAT(a.first_name, ' ', a.last_name) as full_name,
		COUNT(*) as movies_made   
FROM actor a
Join film_actor fa
ON a.actor_id = fa.actor_id
Group by 1,2
order by movies_made DESC;


/*
Displays a table with 4 columns: actor's full name, film title, length of movie, and a column name "filmlen_groups" that classifies movies based on their length. Filmlen_groups should include 4 categories: 1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours.
*/


Select CONCAT(a.first_name, ' ', a.last_name) as full_name,
	   f.title,	   
	   f.length,
	   CASE WHEN f.length <= 60  THEN '1 hour or less'
	   		WHEN f.length <= 120 THEN 'Between 1-2 hours' 
			WHEN f.length <= 180 THEN 'Between 2-3 hours'
			WHEN f.length > 180  THEN 'More than 3 hours'
		END AS filmlen_groups
FROM actor a
Join film_actor fa
ON a.actor_id = fa.actor_id
Join film f
ON f.film_id = fa.film_id;


/*
Create a count of movies in each of the 4 filmlen_groups: 1 hour or less, Between 1-2 hours, Between 2-3 hours, More than 3 hours.
*/

WITH movie_claf_table AS (
	Select f.title,	   
		   f.length,
		   CASE WHEN f.length <= 60  THEN '1 hour or less'
				WHEN f.length > 60 	AND f.length <= 120 THEN 'Between 1-2 hours' 
				WHEN f.length > 120 AND f.length <= 180 THEN 'Between 2-3 hours'
				ELSE 'More than 3 hours' END AS filmlen_groups
	FROM film f
)
SELECT DISTINCT(filmlen_groups),
	   COUNT(title) over (Partition by filmlen_groups) as filmcount_bylencat
FROM movie_claf_table



