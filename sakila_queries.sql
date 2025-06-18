# RAJAS WANIKAR

# QUERY 1
# All films with PG-13 films with rental rate of 2.99 or lower
SELECT title FROM film 
WHERE rental_rate <= 2.99 AND rating = "PG-13";

# QUERY 2
# All films that have deleted scenes
SELECT title FROM film 
WHERE special_features LIKE "%Deleted scenes%";

# QUERY 3
# All active customers
SELECT customer.first_name,customer.last_name FROM customer
WHERE customer.active = 1;
SELECT concat(customer.first_name," ",customer.last_name) AS full_name FROM customer
WHERE customer.active = 1;
SELECT COUNT(active) FROM customer
WHERE active = 1;         # To find total Active Customers

# QUERY 4
# Names of customers who rented a movie on 26th July 2005
SELECT concat(customer.first_name," ",customer.last_name) AS full_name FROM customer
INNER JOIN rental 
ON customer.customer_id = rental.customer_id
WHERE date(rental.rental_date) LIKE "2005-07-26";

# QUERY 5
# Distinct names of customers who rented a movie on 26th July 2005
SELECT distinct(concat(customer.first_name," ",customer.last_name)) AS full_name FROM customer
INNER JOIN rental 
ON customer.customer_id = rental.customer_id
WHERE date(rental.rental_date) LIKE "2005-07-26";

# QUERY 6
# How many rentals we do on each day?
SELECT date(rental_date) AS Day ,COUNT(*) AS Count FROM rental
GROUP BY date(rental_date);
SELECT date(rental_date) AS Day ,COUNT(*) AS Count FROM rental
GROUP BY date(rental_date)
ORDER BY Count DESC
LIMIT 1;               # To find the Busiest Day

# QUERY 7
# All Sci-fi films in our catalogue
SELECT film.title FROM film
INNER JOIN film_category
ON film.film_id = film_category.film_id
LEFT JOIN category
ON film_category.category_id = category.category_id
WHERE category.name = "Sci-Fi";

# QUERY 8
# Customers and how many movies they rented from us so far?
SELECT concat(customer.first_name," ",customer.last_name) AS full_name,COUNT(*) AS Count FROM customer
INNER JOIN rental
ON customer.customer_id = rental.customer_id
GROUP BY full_name
ORDER BY Count DESC;

# QUERY 9
# Which movies should we discontinue from our catalogue (less than 2 lifetime rentals)
WITH low_rentals AS 
	(SELECT inventory_id,COUNT(*) AS Count FROM rental
	GROUP BY inventory_id
	HAVING Count <= 2)
SELECT low_rentals.inventory_id, inventory.film_id, film.title FROM low_rentals
INNER JOIN inventory
ON low_rentals.inventory_id = inventory.inventory_id
INNER JOIN film
ON inventory.film_id = film.film_id;

# Correct One

with low_rentals as 
	(select i.film_id, count(*)
	from rental r
    join inventory i on i.inventory_id = r.inventory_id
	group by i.film_id
	having count(*)<=5)
select low_rentals.film_id, f.title
 from low_rentals
join film f on f.film_id = low_rentals.film_id;

# QUERY 10 
# Which movies are not returned yet?
SELECT film.title FROM rental
JOIN inventory
ON rental.inventory_id = inventory.inventory_id
JOIN film
ON inventory.film_id = film.film_id
WHERE rental.return_date IS NULL
ORDER BY film.title;

# ADVANCED QUERY
# How much money and rentals we make for Store 1 by day?
SELECT date(rental.rental_date) AS Day ,SUM(film.rental_rate) AS Money, COUNT(rental.rental_id) Rentals FROM film
JOIN inventory 
ON film.film_id = inventory.film_id
JOIN rental
ON inventory.inventory_id = rental.inventory_id
WHERE inventory.store_id = 1
GROUP BY date(rental.rental_date);

# Correct One

select date(r.rental_date) as Rental_Date, st.store_id, count(*) as Total_Rentals, 
	date(p.payment_date) as Payment_Date, sum(p.amount) as Total_Payments 
from rental r
join staff s on s.staff_id = r.staff_id
join store st on st.store_id = s.store_id
join payment p on p.rental_id = r.rental_id
where st.store_id = 1
group by date(r.rental_date), date(p.payment_date);

# Another Query
# What are the three top earning days so far?
SELECT date(rental.rental_date) AS Day, SUM(payment.amount) AS Total_Amount FROM rental
JOIN payment ON rental.rental_id = payment.rental_id
GROUP BY date(rental.rental_date)
ORDER BY Total_Amount DESC
LIMIT 3;
