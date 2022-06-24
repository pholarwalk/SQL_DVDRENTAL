--to query all information in a section of a table--
SELECT *
FROM film;

SELECT *
FROM CATEGORY;

SELECT *
FROM CUSTOMER;

--What are the categories of the films we rent out?--
SELECT DISTINCT NAME
FROM CATEGORY;

---What are the names of the actors in the films we rent out?
SELECT FIRST_NAME, LAST_NAME
FROM ACTOR;

/*Please provide a list of all our 
customers including their contact details (email address).*/
SELECT FIRST_NAME, LAST_NAME, EMAIL
FROM CUSTOMER;

/*What are the unique rental durations of films in this rental company? */
SELECT DISTINCT RENTAL_DURATION
FROM FILM;

/*What are the titles of films that are at least 60 mins long?*/
SELECT TITLE, LENGTH
FROM FILM
WHERE LENGTH >=60;

/*What are the titles of films that are rated either PG, PG-13 or G?*/
SELECT TITLE, RATING
FROM FILM
WHERE RATING = 'PG' OR RATING ='PG-13' OR RATING='G';

SELECT TITLE, RATING
FROM FILM
WHERE RATING IN ('PG', 'PG-13','G');

SELECT TITLE, RATING
FROM FILM
WHERE RATING  NOT IN ('PG', 'PG-13','G');

/*Which films are rated PG and are not more than 50 mins long?*/
SELECT TITLE, RATING, LENGTH
FROM FILM
WHERE RATING = 'PG' AND LENGTH <=50;

/*Which films are rated PG-13 and are between 60 to 120 mins long?*/
SELECT TITLE, RATING, LENGTH
FROM FILM
WHERE LENGTH BETWEEN 60 AND 120 AND RATING = 'PG-13';

/*List the names of actors whose names start with the letter “B”.*/
SELECT FIRST_NAME, LAST_NAME
FROM ACTOR
WHERE FIRST_NAME LIKE 'B%';

/*List the names of actors whose names start with the letter “B” and 3 letter words.*/
SELECT FIRST_NAME, LAST_NAME
FROM ACTOR
WHERE FIRST_NAME LIKE 'B__';

/*ILIKE FOR CASE SENSITIVE ON POSTGRE*/
SELECT FIRST_NAME, LAST_NAME
FROM ACTOR
WHERE FIRST_NAME ILIKE 'b%';

/*Provide the rental date of the last 10 rentals.*/
SELECT RENTAL_DATE
FROM RENTAL
ORDER BY RENTAL_DATE DESC
LIMIT 10;

/*Write a query to return the earliest 100 rentals. Include the rental id, rental date and the return date.*/
SELECT RENTAL_ID, RENTAL_DATE, RETURN_DATE
FROM RENTAL
ORDER BY RENTAL_DATE ASC
LIMIT 100;

/*Write a query that displays the rental ID, customer ID, and return date for all the rentals, sorted first by the rental and then by the return date*/
SELECT RENTAL_DATE, RENTAL_ID, CUSTOMER_ID, RETURN_DATE
FROM RENTAL
ORDER BY RENTAL_DATE, RETURN_DATE;

/*	Write a query that displays the payment ID, customer ID, payment amount and the payment date, sorted first by the customer ID (in ascending order), and then by the payment amount (in descending order)*/
SELECT CUSTOMER_ID, PAYMENT_ID, AMOUNT, PAYMENT_DATE
FROM PAYMENT
ORDER BY CUSTOMER_ID ASC, AMOUNT DESC;

--categorise film in three way by duration--
/*short film that has duration less than 50 min
  medium film that has duration 50 min to 100min
  long film that has duration 100min above*/

SELECT TITLE, LENGTH,
CASE	WHEN LENGTH < 50 THEN 'SHORT FILM'
		WHEN LENGTH BETWEEN 50 AND 100 THEN 'MEDIUM FILM'
		WHEN LENGTH >100 THEN 'LONG FILM'
		END AS LENGTH_CATEGORY 

FROM FILM
ORDER BY LENGTH_CATEGORY DESC;		

---HOW MANY ACTORS IN THE DATABASE---
SELECT COUNT(*) AS NO_OF_ACTOR
FROM ACTOR;

--WHAT IS THE LONGEST DURATION OF FILM IN DATABASE--
SELECT  MAX (LENGTH) AS LENGTH_DURATION
FROM FILM;

--WHAT IS THE HIGHEST AMOUT PAID BY CUSTOMER ALSO SHOW FROM THE HIGHEST PAID--
SELECT CUSTOMER_ID, SUM(AMOUNT) HIGH_PAY
FROM PAYMENT
GROUP BY CUSTOMER_ID
ORDER BY HIGH_PAY DESC


---How many films are rated PG or PG-13?

SELECT COUNT(TITLE) AS NO_OF_FILMS
FROM FILM
WHERE RATING = 'PG' OR RATING = 'PG-13'


--	How many movies did each actor act in?
SELECT ACTOR_ID, COUNT(FILM_ID) AS NO_ACT 
FROM FILM_ACTOR
GROUP BY ACTOR_ID
ORDER BY ACTOR_ID DESC
---write a query to return all custmer who paid and amount more that five dollar--
SELECT CUSTOMER_ID, AMOUNT
FROM PAYMENT 
WHERE AMOUNT > 5;

---write a query to return all custmer who paid A REVENUE GREATER THAN 200 AGREGATE--
SELECT CUSTOMER_ID, SUM(AMOUNT) 
FROM PAYMENT
GROUP BY CUSTOMER_ID
HAVING SUM(AMOUNT) > 200;

/*WHAT IS THE PERCENTAGE OF REVENUE EACH CUSTOMER
HAS BROUGHT IN TO THE COMPANY*/
--TOTAL AMOUNT BY CUSTOMER
SELECT CUSTOMER_ID, SUM(AMOUNT) AS REVENUE
FROM PAYMENT
GROUP BY CUSTOMER_ID;

---TOTAL REVENUE OF THE COMPANY
SELECT SUM(AMOUNT) AS REVENUE
FROM PAYMENT;
 
--NOW PERCENTAGE 
SELECT CUSTOMER_ID, SUM(AMOUNT) AS REVENUE,
SUM(AMOUNT) * 100/(SELECT SUM(AMOUNT) AS REVENUE
FROM PAYMENT)AS PERCENTAGE
FROM PAYMENT
GROUP BY CUSTOMER_ID;

--CATERGORISE CUSTOMERS BASED ON NUMBER OF MOVIES RENTED--
SELECT CUSTOMER_ID, COUNT(RENTAL_ID) AS RENTAL_COUNT
FROM RENTAL
GROUP BY CUSTOMER_ID;

SELECT CUSTOMER_ID, COUNT(RENTAL_ID) AS RENTAL_COUNT,
CASE WHEN COUNT(RENTAL_ID) > 30 THEN 'HIGH'
		WHEN COUNT(RENTAL_ID) BETWEEN 20 AND 300 THEN 'MEDIUM'
		WHEN COUNT(RENTAL_ID) <20 THEN 'LOW'
		END AS RENTAL_CATEGORY 
FROM RENTAL
GROUP BY CUSTOMER_ID;

---WHICH MOVIE COUNT CATEGORY HAD THE HIGHEST COUNT CUSTOMER---
SELECT RENTAL_CATEGORY, COUNT(CUSTOMER_ID) AS RENTAL_COUNT
FROM (SELECT CUSTOMER_ID, COUNT(RENTAL_ID) AS RENTAL_COUNT,
CASE WHEN COUNT(RENTAL_ID) > 30 THEN 'HIGH'
		WHEN COUNT(RENTAL_ID) BETWEEN 20 AND 300 THEN 'MEDIUM'
		WHEN COUNT(RENTAL_ID) <20 THEN 'LOW'
		END AS RENTAL_CATEGORY
FROM RENTAL
GROUP BY CUSTOMER_ID) AS HIGHEST_COUNT
GROUP BY RENTAL_CATEGORY
ORDER BY COUNT(CUSTOMER_ID) DESC
LIMIT 1;



----PART 2----
--WORKIN WITH DATES--
SELECT *
FROM PAYMENT;

SELECT payment_date, DATE_PART('month',payment_date)
FROM payment;

SELECT payment_date, DATE_TRUNC('month',payment_date)
FROM payment;

---1.	In what month was the highest number of movies rented?
SELECT DATE_PART('month', rental_date) AS month, COUNT(rental_id) AS RENTA_COUNT
FROM rental
GROUP BY MONTH
ORDER BY RENTA_COUNT DESC;

---2.	Were all the movies rented paid for on the same day?

---TO GET THE AMOUNT OF BOTH ID ON RENTAL AND PAYMENT 
SELECT COUNT(RENTAL.rental_id) AS RENTAL_CNT, COUNT(PAYMENT.rental_id)
FROM RENTAL 
LEFT JOIN PAYMENT ON RENTAL.rental_id = PAYMENT.rental_id
ORDER BY RENTAL_CNT;

SELECT RENTAL.RENTAL_ID, RENTAL.RENTAL_DATE, RENTAL.RETURN_DATE, PAYMENT.PAYMENT_DATE
FROM RENTAL
FULL OUTER JOIN PAYMENT ON RENTAL.RENTAL_ID = PAYMENT.RENTAL_ID
ORDER BY RENTAL_ID

---4.	Return a list of all the movies rented but not paid for, the customers who rented them and the date they were rented---
SELECT FILM.title AS film, CUSTOMER.first_name, CUSTOMER.last_name, RENTAL.rental_date, PAYMENT.payment_date
FROM FILM
JOIN INVENTORY ON FILM.film_id = INVENTORY.film_id
JOIN RENTAL ON RENTAL.inventory_id = INVENTORY.inventory_id
JOIN CUSTOMER ON CUSTOMER.customer_id = RENTAL.customer_id
LEFT JOIN PAYMENT ON RENTAL.rental_id = PAYMENT.rental_id
WHERE PAYMENT.payment_date IS NULL

---5.	Assign groups to customers based on their total spend with the company: High spend is above 150 dollars, Middle spend is between 100 and 150 dollars, Low spend is below 100 dollars.---
SELECT CUSTOMER.CUSTOMER_ID, SUM(PAYMENT.AMOUNT) AS SPENDING,
CASE WHEN SUM(PAYMENT.AMOUNT) > 150 THEN 'HIGH SPEND'
		WHEN SUM(PAYMENT.AMOUNT) BETWEEN 100 AND 150 THEN 'MIDDLE SPEND'
		WHEN SUM(PAYMENT.AMOUNT) < 100 THEN 'LOW SPEND'
		END AS SPENDING_CATEGORY
FROM CUSTOMER
JOIN PAYMENT ON CUSTOMER.customer_id = PAYMENT.customer_id
GROUP BY CUSTOMER.CUSTOMER_ID
ORDER BY CUSTOMER.CUSTOMER_ID DESC
-- OR --
SELECT PAYMENT.customer_id,
CASE WHEN SUM(amount) > 150 THEN 'High Spend'
WHEN SUM(amount) BETWEEN 100 AND 150 THEN 'Middle Spend'
WHEN SUM(amount) < 100 THEN 'Low Spend'
END AS spend_level
FROM payment
GROUP BY customer_id;

--6.	Which spend category had the highest count of customers?---
SELECT SPENDING_CATEGORY, COUNT(CUSTOMER_ID)
FROM (SELECT CUSTOMER.CUSTOMER_ID, SUM(PAYMENT.AMOUNT) AS SPENDING,
CASE WHEN SUM(PAYMENT.AMOUNT) > 150 THEN 'HIGH SPEND'
		WHEN SUM(PAYMENT.AMOUNT) BETWEEN 100 AND 150 THEN 'MIDDLE SPEND'
		WHEN SUM(PAYMENT.AMOUNT) < 100 THEN 'LOW SPEND'
		END AS SPENDING_CATEGORY
FROM CUSTOMER
JOIN PAYMENT ON CUSTOMER.customer_id = PAYMENT.customer_id
GROUP BY CUSTOMER.CUSTOMER_ID) AS SUB
GROUP BY SPENDING_CATEGORY

--- OR --

SELECT spend_level, COUNT(customer_id)
FROM(
	SELECT customer_id,
	CASE WHEN SUM(amount) > 150 THEN 'High Spend'
	WHEN SUM(amount) BETWEEN 100 AND 150 THEN 'Middle Spend'
	WHEN SUM(amount) < 100 THEN 'Low Spend'
	END AS spend_level
	FROM payment
	GROUP BY customer_id) sub
GROUP BY 1
ORDER BY 2 DESC;

----7.	Assign groups to customers based on the number of movies they've rented. High Count is above 30 movies, Middle Count is between 20 and 30 movies, Low Count is below 20 movies.---
SELECT CUSTOMER_ID, COUNT(RENTAL_ID) AS MOST_RENTED,
CASE WHEN COUNT(RENTAL_ID) > 30 THEN 'HIGH COUNT'
		WHEN COUNT(RENTAL_ID) BETWEEN 20 AND 30 THEN 'MIDDLE COUNT'
		WHEN COUNT(RENTAL_ID) < 20 THEN 'LOW COUNT'
		END AS RENTAGE_CATEGORY
FROM RENTAL
GROUP BY CUSTOMER_ID

---8.	Which movie count category had the highest count of customers?--
SELECT RENTAGE_CATEGORY, COUNT (CUSTOMER_ID)AS DEEP
FROM (SELECT CUSTOMER_ID, COUNT(RENTAL_ID) AS MOST_RENTED,
CASE WHEN COUNT(RENTAL_ID) > 30 THEN 'HIGH COUNT'
		WHEN COUNT(RENTAL_ID) BETWEEN 20 AND 30 THEN 'MIDDLE COUNT'
		WHEN COUNT(RENTAL_ID) < 20 THEN 'LOW COUNT'
		END AS RENTAGE_CATEGORY
FROM RENTAL
GROUP BY CUSTOMER_ID) AS SUB
GROUP BY RENTAGE_CATEGORY



--What is the monthly average number of rentals for each movie category?-
--First get each movie id and their categories
SELECT f.film_id, c.name category
FROM film_category f
JOIN category c ON f.category_id = c.category_id

--Then get the rental_id, rental date, the movies and their categories
SELECT r.rental_id, r.rental_date, i.film_id, c.name category
FROM rental r
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film_category f ON i.film_id = f.film_id
JOIN category c ON c.category_id = f.category_id;

--Then truncate the rental date to the month the movie was rented
SELECT r.rental_id, DATE_TRUNC('month',r.rental_date) AS month, i.film_id, c.name category
FROM rental r
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film_category f ON i.film_id = f.film_id
JOIN category c ON c.category_id = f.category_id;

--Then get the count for each category per month
SELECT DATE_TRUNC('month',r.rental_date) AS month, c.name category, COUNT(r.rental_id) AS no_of_rentals
FROM rental r
JOIN inventory i ON i.inventory_id = r.inventory_id
JOIN film_category f ON i.film_id = f.film_id
JOIN category c ON c.category_id = f.category_id
GROUP BY 1,2
ORDER BY 1,2;

--Now get the average monthly rentals for each movie category
SELECT category, AVG(no_of_rentals) AS avg_monthly_rentals
FROM (
	SELECT DATE_TRUNC('month',r.rental_date) AS month, c.name category, COUNT(r.rental_id) AS no_of_rentals
	FROM rental r
	JOIN inventory i ON i.inventory_id = r.inventory_id
	JOIN film_category f ON i.film_id = f.film_id
	JOIN category c ON c.category_id = f.category_id
	GROUP BY 1,2
	ORDER BY 1,2) sub
GROUP BY 1
ORDER BY 2;


---List of customers with their spend and movie count categories
SELECT c.customer_id, c.first_name, c.last_name,t1.spend_level,t2.movie_count
FROM customer c
JOIN (
		SELECT customer_id,
		CASE WHEN SUM(amount) > 150 THEN 'High Spend'
		WHEN SUM(amount) BETWEEN 100 AND 150 THEN 'Middle Spend'
		WHEN SUM(amount) < 100 THEN 'Low Spend'
		END AS spend_level
		FROM payment
		GROUP BY 1) t1 ON c.customer_id = t1.customer_id
JOIN (
		SELECT customer_id,
		CASE WHEN COUNT(rental_id) > 30 THEN 'High Count'
		WHEN COUNT(rental_id) BETWEEN 20 AND 30 THEN 'Middle Count'
		WHEN COUNT(rental_id) < 20 THEN 'Low Count'
		END AS movie_count
		FROM rental
		GROUP BY 1) t2 on c.customer_id = t2.customer_id
ORDER BY 1;

/*
12.	How much has each country contributed 
(in terms of percentage) to the total revenue generated for the company?
*/
SELECT x.country, SUM(p.amount) * 100/(SELECT SUM(amount) FROM payment) AS percentage_revenue
FROM country x
JOIN city y ON x.country_id = y.country_id
JOIN address z ON y.city_id = z.city_id
JOIN customer c ON z.address_id = c.address_id
JOIN payment p ON c.customer_id = p.customer_id
GROUP BY 1
ORDER BY 2 DESC;

---Most profitable category
SELECT x.name AS category, SUM(p.amount) AS total_revenue
FROM category x
JOIN film_category f ON x.category_id = f.category_id
JOIN inventory i ON f.film_id = i.film_id
JOIN rental r ON i.inventory_id = r.inventory_id
JOIN payment p on r.rental_id = p.rental_id
GROUP BY 1
ORDER BY 2 DESC;

--15.	Return the names of everyone associated with the DVD rental company.
SELECT first_name, last_name
FROM customer
UNION ALL
SELECT first_name, last_name
FROM actor
UNION ALL
SELECT first_name, last_name
FROM staff
ORDER BY 1,2;



