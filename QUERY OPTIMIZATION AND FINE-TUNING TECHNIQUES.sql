-- SESSION 5
-- QUERY OPTIMIZATION AND FINE-TUNING TECHNIQUES

-- 1. AVOID SELECT *
-- Always select only necessary columns to improve performance.
SELECT first_name, last_name
FROM customer;

-------------------------------------------------------------

-- 2. USE WHERE BEFORE GROUP BY / HAVING
-- WHERE reduces rows early → faster grouping.
SELECT store_id, COUNT(*) AS total_customers
FROM sakila.customer
WHERE active = 1
GROUP BY store_id
HAVING COUNT(*) > 200;

-------------------------------------------------------------

-- 3. USE JOIN INSTEAD OF SUBQUERY WHEN POSSIBLE

-- Subquery (slower)
SELECT first_name
FROM customer
WHERE store_id IN (
    SELECT store_id FROM store WHERE address_id = 1
);

-- JOIN (faster)
SELECT c.first_name
FROM customer c
JOIN store s ON c.store_id = s.store_id
WHERE s.address_id = 1;

-------------------------------------------------------------

-- 4. AVOID FUNCTIONS ON INDEXED COLUMNS
-- Using YEAR() prevents index usage

EXPLAIN SELECT * FROM rental
WHERE YEAR(rental_date) = 2005;

-- Better: use range filter
EXPLAIN SELECT * FROM rental
WHERE rental_date BETWEEN '2005-01-01' AND '2005-12-31';

-------------------------------------------------------------

-- 5. USE LIMIT FOR FASTER FETCH
SELECT *
FROM film
ORDER BY film_id
LIMIT 10;

-------------------------------------------------------------

-- 6. USE CTE FOR CLEANER LOGIC
WITH high_paying_customers AS (
  SELECT customer_id, SUM(amount) AS total_paid
  FROM payment
  GROUP BY customer_id
  HAVING SUM(amount) > 100
)
SELECT c.first_name, c.last_name, h.total_paid
FROM customer c
JOIN high_paying_customers h ON c.customer_id = h.customer_id;

-------------------------------------------------------------

-- 7. USE EXPLAIN TO ANALYZE QUERY PERFORMANCE
EXPLAIN SELECT * FROM customer WHERE store_id = 1;

-------------------------------------------------------------

-- 8. MAINTENANCE COMMANDS
-- These help update index statistics and optimize tables.
ANALYZE TABLE customer;
OPTIMIZE TABLE rental;

-------------------------------------------------------------

-- 9. AVOID LARGE OFFSET PAGINATION
-- Slow (skips many rows)
SELECT *
FROM payment
LIMIT 1000, 10;

-- Fast (uses index)
SELECT *
FROM payment
WHERE payment_id > 1000
LIMIT 10;
