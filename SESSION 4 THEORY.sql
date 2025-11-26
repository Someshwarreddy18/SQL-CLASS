-- ---------------------SESSION 4 – ADVANCED SQL QUERY OPTIMIZATION
-- =================================================================================================
-- https://www.youtube.com/watch?v=SsobEdpSzI0

USE sakila;

-- ================================================================================================
-- 1. AVOID SELECT * 
-- SELECT * fetches every column which:
-- • Increases network load
-- • Prevents index optimization
-- • Slows down joins
-- Always select ONLY required columns for best performance.

-- Example:
SELECT first_name, last_name FROM customer;

-- ================================================================================================
-- 2. USE WHERE BEFORE GROUP BY + HAVING 
-- WHERE filters rows BEFORE grouping → efficient
-- HAVING filters AFTER grouping → slower
-- Best practice: ALWAYS filter as early as possible.

-- Example:
SELECT store_id, COUNT(*) AS total_customers
FROM sakila.customer
WHERE active = 1               -- early filtering
GROUP BY store_id
HAVING COUNT(*) > 200;         -- filter aggregated result

-- ================================================================================================
-- 3. USE JOINS NOT SUBQUERIES 
-- Subqueries:
-- • Harder for MySQL to optimize
-- • Often cause temporary tables
-- • Higher execution time
-- JOINs:
-- • Faster
-- • Use indexes correctly
-- • Cleaner and more readable

-- Inefficient subquery:
SELECT first_name
FROM customer
WHERE store_id IN (SELECT store_id FROM store WHERE address_id = 1);

-- Efficient JOIN:
SELECT c.first_name
FROM customer c
JOIN store s ON c.store_id = s.store_id
WHERE s.address_id = 1;

-- ================================================================================================
-- 4. AVOID FUNCTIONS ON INDEXED COLUMNS (THEORY)
-- If you apply a function on an indexed column:
-- • MySQL cannot use the index
-- • Full table scan happens → slow
-- Use ranges instead.

-- BAD (index is ignored):
EXPLAIN SELECT * FROM rental WHERE YEAR(rental_date) = 2005;

-- GOOD (index is used):
EXPLAIN SELECT * 
FROM rental 
WHERE rental_date BETWEEN '2005-01-01' AND '2005-12-31';

-- ================================================================================================
-- 5. USE LIMIT FOR PERFORMANCE 
-- LIMIT helps avoid loading unnecessary rows into memory.

SELECT *
FROM film
ORDER BY film_id
LIMIT 10;

-- ================================================================================================
-- 6. USE CTEs FOR READABILITY 
-- CTE = Common Table Expression
-- Helps break complex queries into small readable parts.
-- MySQL processes the CTE first then uses result as virtual table.

WITH high_paying_customers AS (
    SELECT customer_id, SUM(amount) AS total_paid
    FROM payment
    GROUP BY customer_id
    HAVING SUM(amount) > 100
)
SELECT c.first_name, c.last_name, h.total_paid
FROM customer c
JOIN high_paying_customers h 
    ON c.customer_id = h.customer_id;

-- ================================================================================================
-- 7. USE EXPLAIN TO ANALYZE QUERY PERFORMANCE (THEORY)
-- EXPLAIN shows:
-- • Whether indexes are used
-- • Join strategy
-- • Estimated rows scanned
-- • Type of scan (ALL, INDEX, RANGE)

EXPLAIN SELECT * FROM customer WHERE store_id = 1;

-- ================================================================================================
-- 8. DATABASE MAINTENANCE COMMANDS
-- ANALYZE TABLE:
-- • Updates table statistics for query optimizer

-- OPTIMIZE TABLE:
-- • Rebuilds table
-- • Reduces fragmentation
-- • Speeds up reads/writes

ANALYZE TABLE customer;
OPTIMIZE TABLE rental;

-- ================================================================================================
-- 9. AVOID LARGE OFFSET PAGINATION
-- Big OFFSET values are slow because MySQL scans and discards #offset rows.
-- Prefer "seek pagination" using indexed columns.

-- BAD:
SELECT * FROM sakila.payment LIMIT 1000, 10;

-- GOOD:
SELECT * 
FROM payment 
WHERE payment_id > 1000
LIMIT 10;

-- ================================================================================================
-- END OF SESSION 4
