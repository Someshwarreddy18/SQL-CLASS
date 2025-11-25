-- -------------------SESSION 2------------------------------
-- ============================================================

-- 1. SELECT BASICS
-- SELECT is used to retrieve data from a table.

SELECT * FROM sakila.actor;  
-- Fetches all rows and columns from actor table.

SELECT DISTINCT first_name FROM sakila.actor;
-- DISTINCT removes duplicates.

-- ============================================================
-- 2. FILTERING WITH WHERE

SELECT * FROM sakila.film WHERE original_language_id IS NULL;
-- Shows films whose original language is unknown.

SELECT COUNT(*) FROM sakila.film;
-- COUNT(*) returns total number of rows.

SELECT DISTINCT title FROM sakila.film WHERE original_language_id IS NULL;
-- Fetches unique film titles whose language is null.

SELECT COUNT(DISTINCT(title)) FROM sakila.film;
-- Counts how many unique titles exist.

-- ============================================================
-- 3. COUNT vs DISTINCT COUNT

SELECT COUNT(first_name) FROM sakila.actor;
-- Counts all first names including duplicates.

SELECT COUNT(DISTINCT(first_name)) FROM sakila.actor;
-- Counts unique first names only.

-- ============================================================
-- 4. SELECT SPECIFIC COLUMNS

SELECT first_name, last_name FROM sakila.actor;

-- ============================================================
-- 5. LIMIT CLAUSE
-- LIMIT restricts number of rows returned.

SELECT first_name, last_name FROM sakila.actor LIMIT 5;

-- ============================================================
-- 6. FILTERING WITH CONDITIONS (WHERE)

SELECT DISTINCT(rating) FROM sakila.film;

SELECT * FROM sakila.film;

SELECT * FROM sakila.film 
WHERE rating = 'R' AND length >= 92;
-- Shows R-rated films with length >= 92 minutes.

SELECT * FROM sakila.film 
WHERE length >= 92;

-- ============================================================
-- 7. SORTING RESULTS
-- ORDER BY sorts output ASC (default) or DESC.

SELECT rental_rate FROM sakila.film;

SELECT rental_rate FROM sakila.film 
ORDER BY rental_rate DESC;

-- ============================================================
-- 8. AND / OR OPERATORS

SELECT * FROM sakila.film 
WHERE rating = 'PG' AND rental_duration = 5
ORDER BY rental_rate ASC;

SELECT * FROM sakila.film 
WHERE rating = 'PG' OR rental_duration = 5
ORDER BY rental_rate ASC;

-- ============================================================
-- 9. NOT OPERATOR

SELECT * FROM sakila.film 
WHERE NOT rental_duration NOT IN (6, 7, 3)
ORDER BY rental_rate ASC;

SELECT * FROM sakila.film 
WHERE NOT rental_duration = 6 
ORDER BY rental_rate ASC;

SELECT * FROM sakila.film 
WHERE rental_duration = 6 
AND (rating = 'G' OR rating = 'PG')
ORDER BY rental_rate ASC;

-- ============================================================
-- 10. LIKE OPERATOR (Pattern Matching)
-- % = any number of characters
-- _ = exactly one character

SELECT city FROM sakila.city WHERE city LIKE 'A%s';
-- City starts with A and ends with s

SELECT city FROM sakila.city WHERE city LIKE '_s___d%';
-- 1st char any, 2nd = s, last letter before % = d

-- ============================================================
-- 11. NULL HANDLING
-- IS NULL / IS NOT NULL is used to check null values.

SELECT * FROM sakila.rental;

SELECT rental_id, inventory_id, customer_id, return_date
FROM sakila.rental
WHERE return_date IS NULL;
-- Rentals never returned.

-- ============================================================
-- 12. BETWEEN (Range Filtering)

SELECT rental_id, inventory_id, customer_id, return_date
FROM sakila.rental
WHERE return_date BETWEEN '2005-05-26' AND '2005-05-30';

-- ============================================================
-- 13. GROUP BY + HAVING
-- GROUP BY groups rows
-- HAVING filters groups (WHERE cannot be used on aggregates)

SELECT customer_id, COUNT(*) AS count
FROM sakila.rental
GROUP BY customer_id
HAVING count <= 30
ORDER BY count DESC;

-- ============================================================
-- 14. ORDER OF SQL EXECUTION

-- SQL runs in this order:
-- 1. FROM (table)
-- 2. JOIN
-- 3. WHERE
-- 4. GROUP BY
-- 5. HAVING
-- 6. SELECT
-- 7. ORDER BY
-- 8. LIMIT

-- ============================================================
-- 15. WHERE vs HAVING
-- WHERE filters rows BEFORE grouping.
-- HAVING filters AFTER grouping.

SELECT * FROM sakila.rental 
WHERE return_date IS NULL;

SELECT * FROM sakila.rental 
WHERE customer_id = 33;

SELECT customer_id, SUM(amount) AS total_payment
FROM sakila.payment
GROUP BY customer_id
HAVING SUM(amount) > 100;
-- Cannot use WHERE here because SUM(amount) is aggregate.

-- END OF SESSION 2
