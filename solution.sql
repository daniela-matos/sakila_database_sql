-- Display the first and last names of all actors from the table actor.

SELECT first_name, last_name
FROM sakila.actor;

-- Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column Actor Name.

SELECT first_name,
		last_name,
        UPPER (CONCAT (first_name , ' ',last_name)) AS Actor_Name
FROM sakila.actor;	

-- You need to find the ID number, first name, and last name of an actor, 
-- of whom you know only the first name, "Joe." What is one query would you use 
-- to obtain this information?	

SELECT actor_id, first_name, last_name
FROM sakila.ACTOR 
WHERE first_name LIKE 'JOE';

-- Find all actors whose last name contain the letters GEN:

SELECT *
FROM sakila.actor
WHERE last_name LIKE '%GEN%';

-- Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:

SELECT last_name, first_name, actor_id, last_update
FROM sakila.actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name, first_name;

-- Using IN, display the country_id and country columns of the following countries: 
-- Afghanistan, Bangladesh, and China:

SELECT country_id, country
FROM sakila.country
Where country IN ('Afghanistan', 'Bangladesh', 'China');

-- You want to keep a description of each actor. You don't think you will be performing queries 
-- on a description, so create a column in the table actor named description and use the 
-- data type BLOB (Make sure to research the type BLOB, as the difference between it and 
-- VARCHAR are significant).

ALTER TABLE sakila.actor
ADD Description BLOB;

-- Very quickly you realize that entering descriptions for each actor is too much effort. 
-- Delete the description column.

ALTER TABLE sakila.actor
DROP Description;

-- List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(last_name)
FROM sakila.actor
GROUP BY last_name;

-- List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors:

SELECT last_name, COUNT(last_name)
FROM sakila.actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2;

-- The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. 
-- Write a query to fix the record.

UPDATE sakila.actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO'
AND last_name = 'Williams';

-- Perhaps we were too hasty in changing GROUCHO to HARPO. It turns out that GROUCHO was the correct 
-- name after all! In a single query, if the first name of the actor is currently HARPO, change it 
-- to GROUCHO.

UPDATE sakila.actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO'
AND last_name = 'williams';

-- You cannot locate the schema of the address table. Which query would you use to re-create it?

SHOW CREATE TABLE sakila.address;


-- Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:

SELECT s.first_name, s.last_name, a.address
FROM sakila.staff s
INNER JOIN sakila.address a 
USING (address_id);

-- Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.

SELECT staff_id, first_name, last_name, SUM(amount) AS total_amount
FROM sakila.staff s
JOIN sakila.payment p
USING (staff_id)
WHERE p.payment_date LIKE '2005-08%'
GROUP BY staff_id;

-- List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join.

SELECT title, COUNT(a.actor_id) AS number_of_actors
FROM sakila.film_actor a
JOIN sakila.film 
USING (film_id)
GROUP BY title;

-- How many copies of the film Hunchback Impossible exist in the inventory system?

SELECT title, COUNT(title) AS number_of_copies
FROM sakila.film 
JOIN sakila.inventory 
USING (film_id)
WHERE title= 'Hunchback Impossible';

-- Using the tables payment and customer and the JOIN command, list the total paid by each customer.
-- List the customers alphabetically by last name:

SELECT last_name, first_name, customer_id, SUM(amount) AS total_amount_paid
FROM sakila.customer
JOIN sakila.payment
USING (customer_id)
GROUP BY customer_id
ORDER BY last_name;

--  The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared 
-- in popularity. Use subqueries to display the titles of movies starting with the letters 
-- K and Q whose language is English.

SELECT title, name
FROM sakila.film 
JOIN sakila.language 
USING (language_id)
WHERE title REGEXP '^k|^Q'
AND name='english';

-- Use subqueries to display all actors who appear in the film Alone Trip.

SELECT first_name, last_name, title
FROM sakila.actor
JOIN sakila.film_actor
USING (actor_id)
JOIN sakila.film
USING(film_id)
WHERE title = 'Alone Trip';

-- You want to run an email marketing campaign in Canada, 
-- for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.

SELECT first_name, last_name, email, country
FROM sakila.customer
JOIN sakila.address
USING (address_id)
JOIN sakila.city
USING (city_id)
JOIN sakila.country
USING (country_id)
WHERE country = 'Canada';

-- Sales have been lagging among young families, and you wish to target all family movies 
-- for a promotion. Identify all movies categorized as family films.

SELECT title, name AS category 
FROM sakila.film
JOIN sakila.film_category
USING (film_id)
JOIN sakila.category
USING (category_id)
WHERE category_id = 8;

-- Display the most frequently rented movies in descending order.

SELECT title, COUNT(rental_date) AS total_rental_days
FROM film
JOIN inventory
USING (film_id)
JOIN rental
USING (inventory_id)
GROUP BY title
ORDER BY total_rental_days DESC;

-- Write a query to display how much business, in dollars, each store brought in.

SELECT store_id, CONCAT('$ ', FORMAT(SUM(amount), 2)) AS total_amount
FROM sakila.payment
JOIN sakila.staff
USING (staff_id)
JOIN sakila.store
USING (store_id)
GROUP BY store_id;

-- Write a query to display for each store its store ID, city, and country.

SELECT store_id, city, country
FROM sakila.store
JOIN address
USING (address_id)
JOIN city
USING (city_id)
JOIN country
USING (country_id);

-- List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

SELECT name AS genres, CONCAT('$ ', FORMAT(SUM(amount), 2)) AS gross_revenue
FROM category
JOIN film_category
USING (category_id)
JOIN inventory
USING (film_id)
JOIN rental
USING (inventory_id)
JOIN payment
USING (rental_id)
GROUP BY name
ORDER BY gross_revenue DESC
LIMIT 5;

-- In your new role as an executive, you would like to have an easy way of viewing the 
-- Top five genres by gross revenue. Use the solution from the problem above to 
-- create a view. If you haven't solved 7h, you can substitute another query to create a view.

CREATE VIEW sakila.top_five_genre (Genres, Gross_Revenue)
AS
SELECT name AS Genres, CONCAT('$ ', FORMAT(SUM(amount), 2)) AS Gross_Revenue
FROM payment
JOIN rental
USING (rental_id)
JOIN inventory
USING (inventory_id)
JOIN film_category
USING (film_id)
JOIN category
USING (category_id)
GROUP BY name
ORDER BY Gross_Revenue DESC
LIMIT 5;

-- How would you display the view that you created in 8a?

SELECT *
FROM sakila.top_five_genre;

-- You find that you no longer need the view top_five_genres. Write a query to delete it.

DROP VIEW sakila.top_five_genre;