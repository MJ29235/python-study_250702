# 초급
USE sakila;
SELECT first_name, last_name, email FROM customer;
SELECT actor_id, last_name FROM actor WHERE first_name = "JULIA";
SELECT rental_id, rental_date FROM rental ORDER BY rental_date DESC LIMIT 5;
SELECT customer_id, SUM(amount) FROM payment GROUP BY customer_id ORDER BY SUM(amount) DESC;
SELECT name, COUNT(*) FROM category JOIN film_category USING(category_id) GROUP BY category_id ORDER BY COUNT(*) DESC LIMIT 1;
SELECT DISTINCT rental_date  FROM rental WHERE DATE(2005); #########
SELECT actor_id, CONCAT(first_name," ",last_name) actor_name, COUNT(*) FROM actor JOIN film_actor USING(actor_id) JOIN film USING(film_id) GROUP BY actor_id ORDER BY COUNT(*) DESC;
SELECT customer_id,payment_date,SUM(amount) FROM payment GROUP BY customer_id
HAVING MONTH(payment_date) =;
SELECT customer_id, YEAR(payment_date),MONTH(payment_date), SUM(amount)  FROM payment
GROUP BY customer_id;
SELECT 
    customer_id,
    MONTH(payment_date) AS month,
    SUM(amount) AS total_payment
FROM payment
GROUP BY MONTH(payment_date),customer_id
ORDER BY customer_id, month;
SELECT 
    YEAR(payment_date) AS year,
    MONTH(payment_date) AS month,
    SUM(amount) AS total_payment
FROM payment
GROUP BY YEAR(payment_date), MONTH(payment_date)
ORDER BY year, month;

