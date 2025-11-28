-- ------------SESSION 4-------------------------

-- ADVANCED SQL CONCEPTS
-- CTE, RECURSIVE CTE, SUBQUERIES, TEMP TABLES, VIEWS

---------------------------------------------------------------
-- 1. SUBQUERIES INSIDE HAVING
-- Find customers whose total spent is greater than average customer spending

SELECT 
    c.customer_id,
    c.first_name,
    c.last_name,
    SUM(p.amount) AS total_spent
FROM sakila.customer AS c
JOIN sakila.payment AS p 
    ON p.customer_id = c.customer_id
GROUP BY 
    c.customer_id, c.first_name, c.last_name
HAVING 
    total_spent > (
        SELECT AVG(customer_total)
        FROM (
            SELECT SUM(p2.amount) AS customer_total
            FROM sakila.payment AS p2
            GROUP BY p2.customer_id
        ) AS t
    );

---------------------------------------------------------------
-- 2. SAME LOGIC USING CTE (CLEANER & FASTER)
-- CTE stores total spent per customer once, then reused

WITH customer_totals AS (
    SELECT 
        customer_id,
        SUM(amount) AS total_spent
    FROM sakila.payment
    GROUP BY customer_id
)
SELECT 
    ct.customer_id,
    c.first_name,
    c.last_name,
    ct.total_spent
FROM customer_totals AS ct
JOIN sakila.customer AS c 
    ON c.customer_id = ct.customer_id
WHERE ct.total_spent > (
    SELECT AVG(total_spent) 
    FROM customer_totals
);

---------------------------------------------------------------
-- 3. INTRO TO CTE
-- Temporary result set, reused in same query.
-- More readable than nested subqueries.

SELECT customer_id, total_payments
FROM (
    SELECT customer_id, COUNT(*) AS total_payments
    FROM sakila.payment
    GROUP BY customer_id
) AS sub
WHERE total_payments > 5;

-- Same using CTE (cleaner)
WITH payment_counts AS (
    SELECT customer_id, COUNT(*) AS total_payments
    FROM sakila.payment
    GROUP BY customer_id
)
SELECT customer_id, total_payments
FROM payment_counts
WHERE total_payments > 5;

---------------------------------------------------------------
-- 4. CTE JOIN WITH CUSTOMER TABLE
-- Attach customer details with payment counts

WITH payment_counts AS (
    SELECT customer_id, COUNT(*) AS total_payments
    FROM sakila.payment
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, c.last_name, p.total_payments
FROM sakila.customer c
JOIN payment_counts p ON c.customer_id = p.customer_id
WHERE p.total_payments > 5;

---------------------------------------------------------------
-- 5. MULTIPLE CTEs IN ONE QUERY
-- total payments + latest payment date

WITH total_payments AS (
    SELECT customer_id, SUM(amount) AS total_amount
    FROM sakila.payment
    GROUP BY customer_id
),
latest_payment AS (
    SELECT customer_id, MAX(payment_date) AS last_payment_date
    FROM sakila.payment
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, c.last_name,
       tp.total_amount,
       lp.last_payment_date
FROM sakila.customer c
LEFT JOIN total_payments tp ON c.customer_id = tp.customer_id
LEFT JOIN latest_payment lp ON c.customer_id = lp.customer_id;

---------------------------------------------------------------
-- 6. RECURSIVE CTE
-- A CTE that calls itself until a condition is met

WITH RECURSIVE numbers AS (
  SELECT 1 AS n       -- start
  UNION ALL
  SELECT n + 1        -- generate next number
  FROM numbers
  WHERE n < 20        -- stop at 20
) 
SELECT * FROM numbers;

---------------------------------------------------------------
-- 7. RECURSIVE CTE TO GENERATE LAST 10 DAYS
-- Useful for date ranges even if no data exists that day

WITH RECURSIVE dates AS (
  SELECT DATE(MAX(rental_date)) - INTERVAL 9 DAY AS rental_day
  FROM sakila.rental

  UNION ALL

  SELECT rental_day + INTERVAL 1 DAY
  FROM dates
  WHERE rental_day + INTERVAL 1 DAY <= (SELECT MAX(rental_date) FROM sakila.rental)
)
SELECT d.rental_day, COUNT(r.rental_id) AS rentals
FROM dates d
LEFT JOIN sakila.rental r 
  ON DATE(r.rental_date) = d.rental_day
GROUP BY d.rental_day;

---------------------------------------------------------------
-- 8. BASIC DATE CHECK
SELECT DATE(rental_date), COUNT(*)
FROM sakila.rental 
WHERE DATE(rental_date) = '2006-02-14'
GROUP BY DATE(rental_date);

---------------------------------------------------------------
-- 9. TEMPORARY TABLES
-- Exists only for current session
-- Good for storing intermediate results

DROP TEMPORARY TABLE IF EXISTS sakila.top_categories;

CREATE TEMPORARY TABLE sakila.top_categories AS
SELECT c.name AS category_name, c.category_id, COUNT(*) AS rental_count
FROM sakila.rental r
JOIN sakila.inventory i ON r.inventory_id = i.inventory_id
JOIN sakila.film f ON f.film_id = i.film_id
JOIN sakila.film_category fc ON f.film_id = fc.film_id
JOIN sakila.category c ON c.category_id = fc.category_id
GROUP BY c.name, c.category_id
ORDER BY rental_count DESC
LIMIT 5;

-- Using the temporary table
SELECT * 
FROM sakila.top_categories tc 
JOIN sakila.film_category fc ON fc.category_id = tc.category_id;

SELECT tc.category_name, tc.category_id 
FROM sakila.top_categories tc
JOIN sakila.category c ON c.category_id = tc.category_id;

---------------------------------------------------------------
-- 10. VIEWS
-- Virtual table created from SELECT query
-- Always up to date, not stored physically

-- Create view for latest rental per customer
DROP VIEW IF EXISTS sakila.recent_rentals;

CREATE OR REPLACE VIEW sakila.recent_rentals AS
SELECT r.customer_id, MAX(r.rental_date) AS last_rental
FROM sakila.rental r
GROUP BY r.customer_id;

SELECT * FROM sakila.recent_rentals;

-- Join view with customer info
SELECT c.first_name, c.last_name, rr.last_rental
FROM sakila.customer c
JOIN sakila.recent_rentals rr 
  ON c.customer_id = rr.customer_id;

---------------------------------------------------------------
-- PUBLIC VIEW (HIDE SENSITIVE DATA)
CREATE OR REPLACE VIEW sakila.customer_public_view AS
SELECT customer_id, first_name, last_name, email
FROM sakila.customer;

SELECT * FROM sakila.customer_public_view;
