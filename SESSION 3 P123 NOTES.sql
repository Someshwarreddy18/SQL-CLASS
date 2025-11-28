-- ----------------SESSION 3 PART 1 ------------------------------------------
-- ---------------------------------------------------------------------------
-- STRING FUNCTIONS
-- String functions help us work with text values like names, titles, emails.

-- LPAD / RPAD
-- LPAD adds characters to the left side.
-- RPAD adds characters to the right side.
-- We use this to format text to a fixed length.
SELECT title, LPAD(RPAD(title,20,'*'),25,'*') AS padded_title
FROM sakila.film
LIMIT 5;

SELECT title, RPAD(title,20,'*') AS padded_right
FROM sakila.film
LIMIT 5;

-- SUBSTRING
-- Used to extract part of a string.
-- (text, start_position, length)
SELECT title, SUBSTRING(title,3,9) AS short_title
FROM sakila.film;

-- CONCAT
-- Used to join two or more strings together.
SELECT CONCAT(first_name,'@',last_name) AS full_name
FROM sakila.customer;

-- REVERSE
-- Reverse the characters in a string.
SELECT title, REVERSE(title) AS reversed_title
FROM sakila.film
LIMIT 5;

-- LENGTH
-- Returns the total number of characters in a string.
SELECT title, LENGTH(title) AS title_length
FROM sakila.film
WHERE LENGTH(title) = 8;

-- SUBSTRING + LOCATE
-- LOCATE finds the index of a character.
-- We use SUBSTRING + LOCATE to extract text after '@'.
SELECT email, SUBSTRING(email, LOCATE('@',email)+1) AS domain
FROM sakila.customer;

-- SUBSTRING_INDEX is another way to get domain
SELECT email, substring_index(email,'@',-1) AS domain
FROM sakila.customer;

-- UPPER / LOWER
-- Convert text to uppercase or lowercase.
SELECT title, UPPER(title), LOWER(title)
FROM sakila.film
WHERE UPPER(title) LIKE '%LOVELY%' OR UPPER(title) LIKE '%MAN%';

-- LEFT / RIGHT
-- LEFT(text,n) returns n characters from start.
-- RIGHT(text,n) returns n characters from end.
-- We use it to group or classify text.
SELECT LEFT(title,1), RIGHT(title,1), COUNT(*)
FROM sakila.film
GROUP BY LEFT(title,1), RIGHT(title,1)
ORDER BY COUNT(*) DESC;

-- CASE
-- CASE is used to create categories based on conditions.
SELECT last_name,
CASE 
    WHEN LEFT(last_name,1) BETWEEN 'A' AND 'M' THEN 'Group A-M'
    WHEN LEFT(last_name,1) BETWEEN 'N' AND 'Z' THEN 'Group N-Z'
    ELSE 'Other'
END AS group_label
FROM sakila.customer;

-- REPLACE
-- Replace all occurrences of one character with another.
SELECT title, REPLACE(title,'A','x') AS cleaned_title
FROM sakila.film;

-- REGEXP
-- Used to match patterns using regular expressions.

-- Last name with 3 consonants together
SELECT last_name
FROM sakila.customer
WHERE last_name REGEXP '[^aeiouAEIOU]{3}';

-- Film title ending with a vowel
SELECT title
FROM sakila.film
WHERE title REGEXP '[aeiouAEIOU]$';

-- ---------------------------------------------------------------------
-- ---------------------SESSION 3 PART 2 ------------------------------
-- ----------------------------------------------------------------------

-- MATH FUNCTIONS, AGGREGATES & DATE FUNCTIONS
-- These functions help us calculate numbers, summaries and work with dates.

-- POWER or ^
-- POWER(x,y) = x raised to y
-- Used to calculate exponential values
SELECT title, rental_rate, rental_rate ^ 3 AS cube_rate
FROM sakila.film;

-- CAST
-- Converts one datatype to another
-- Example: decimal to integer
SELECT amount, CAST(amount AS SIGNED) AS amount_int
FROM sakila.payment;

-- AGGREGATE FUNCTIONS
-- COUNT() = number of rows
-- SUM()   = total of values
-- AVG()   = average value
-- GROUP BY is required to group the rows

SELECT customer_id,
COUNT(payment_id) AS total_payments,
SUM(amount) AS total_amount,
AVG(amount) AS avg_amount
FROM sakila.payment
GROUP BY customer_id;

-- RAND()
-- Generates a random number between 0 and 1
-- FLOOR() makes it whole number
SELECT customer_id, FLOOR(RAND()*100) AS random_score
FROM sakila.customer
LIMIT 5;

-- MOD()
-- Gives remainder when dividing numbers
SELECT film_id, length, MOD(length,60) AS leftover_minutes
FROM sakila.film;

-- CEIL / FLOOR
-- CEIL = round up
-- FLOOR = round down
SELECT rental_rate, CEIL(rental_rate), FLOOR(rental_rate)
FROM sakila.film;

-- ROUND()
-- Round value to given decimal points
SELECT rental_rate, ROUND(replacement_cost/rental_rate,1) AS cost_ratio
FROM sakila.film;

-- DATE FUNCTIONS
-- These functions help calculate days, months, years, etc.

-- DATEDIFF
-- Shows difference in days between two dates
SELECT rental_id, return_date, rental_date,
DATEDIFF(return_date,rental_date) AS days_rented
FROM sakila.rental
WHERE return_date IS NOT NULL;

-- MONTH & MONTHNAME
SELECT last_update, MONTH(last_update) AS month_no, MONTHNAME(last_update) AS month_name
FROM sakila.film;

-- YEAR
SELECT rental_date, YEAR(rental_date) AS rental_year
FROM sakila.rental;

-- GROUP BY DATE
-- Group payments based on date only (removes time part)
SELECT DATE(payment_date) AS pay_date, SUM(amount)
FROM sakila.payment
GROUP BY DATE(payment_date);

-- LAST 24 HOURS DATA
-- NOW() gives current date & time
SELECT customer_id, amount, payment_date
FROM sakila.payment
WHERE payment_date >= NOW() - INTERVAL 1 DAY;

-- LAST 10 DAYS BASED ON LATEST PAYMENT
SELECT customer_id, amount, payment_date
FROM sakila.payment
WHERE payment_date >= (
    SELECT MAX(payment_date) - INTERVAL 10 DAY FROM sakila.payment
);

-- CURRENT DATE & TIME FUNCTIONS
SELECT NOW() AS full_timestamp,
CURDATE() AS only_date,
CURRENT_TIME AS only_time;

-- --------------------------------------------------------------------------------------------------------
-- ---------------------SESSION 3 PART 3 THEORY ---------------------------------------------------
-- --------------------------------------------------------------------------------------------------------
-- SUBQUERIES THEORY
-- Subqueries are queries written inside another query.
-- They help us filter, compare or calculate values dynamically.

-- BASIC SUBQUERY USING IN
-- Here we get all customers who have the same address_id as customer 2.
-- The inner query runs first and returns the address_id.
SELECT first_name, last_name
FROM sakila.customer
WHERE address_id IN (
    SELECT address_id
    FROM sakila.customer
    WHERE customer_id = 2
);

-- SUBQUERY WITH GROUP BY AND HAVING
-- We find all actors who acted in more than 10 films.
-- HAVING works after grouping.
SELECT actor_id, first_name, last_name
FROM sakila.actor
WHERE actor_id IN (
    SELECT actor_id
    FROM sakila.film_actor
    GROUP BY actor_id
    HAVING COUNT(film_id) > 10
);

-- SUBQUERY INSIDE SELECT (SCALAR SUBQUERY)
-- Scalar subquery returns a single value.
-- Here, for every actor, we calculate total films they acted in.
SELECT actor_id, first_name, last_name,
(
    SELECT COUNT(*) 
    FROM sakila.film_actor 
    WHERE film_actor.actor_id = actor.actor_id
) AS film_count
FROM sakila.actor;

-- DERIVED TABLE SUBQUERY
-- A derived table is a subquery that acts like a temporary table.
-- It must have an alias.
SELECT a.actor_id, a.first_name, a.last_name, fa.film_count
FROM sakila.actor a
JOIN (
    SELECT actor_id, COUNT(film_id) AS film_count
    FROM sakila.film_actor
    GROUP BY actor_id
) fa ON a.actor_id = fa.actor_id;

-- CORRELATED SUBQUERY
-- Subquery depends on the outer query row.
-- For every film, count how many actors acted in it.
SELECT title,
(
    SELECT COUNT(*) 
    FROM sakila.film_actor fa 
    WHERE fa.film_id = f.film_id
) AS actor_count
FROM sakila.film f;

-- CUSTOMER PAYMENTS GREATER THAN HIS OWN AVERAGE
-- Here p1 depends on p2 inside subquery.
-- For each customer, find payments above their personal average.
SELECT payment_id, customer_id, amount, payment_date
FROM sakila.payment p1
WHERE amount > (
    SELECT AVG(amount)
    FROM sakila.payment p2
    WHERE p2.customer_id = p1.customer_id
);

