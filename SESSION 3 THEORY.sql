-------------------------- SESSION 3 
-- =============================================================
-- MODULE: STRING FUNCTIONS, MATH FUNCTIONS, DATE FUNCTIONS, CASTING
-- =============================================================
-- 1. STRING FUNCTIONS THEORY
-- String functions allow you to manipulate text values.
-- Used for cleaning, formatting, extracting, grouping, reporting.

-- LPAD(text, length, pad_char)
-- Adds characters to the LEFT until total length is reached.

-- RPAD(text, length, pad_char)
-- Adds characters to the RIGHT.

SELECT title, LPAD(RPAD(title, 20, '*'), 25, '*') AS padded_title
FROM sakila.film
LIMIT 5;

SELECT title, RPAD(title, 20, '*') AS padded_right
FROM sakila.film
LIMIT 5;

-- -------------------------------------------------------------
-- SUBSTRING(text, start, length)
-- Extracts part of a string.
-- start = position to begin
-- length = number of characters to extract

SELECT title, SUBSTRING(title, 3, 9) AS short_title
FROM sakila.film;

-- -------------------------------------------------------------
-- CONCAT(a, b, c...)
-- Joins multiple strings.

SELECT CONCAT(first_name, '@', last_name) AS email_style
FROM sakila.customer;

-- -------------------------------------------------------------
-- REVERSE(text)
-- Reverses characters in a string.

SELECT title, REVERSE(title) AS reversed
FROM sakila.film
LIMIT 5;

-- -------------------------------------------------------------
-- LENGTH(text)
-- Returns number of characters in string.
-- Useful for filters and validations.

SELECT title, LENGTH(title) AS title_length
FROM sakila.film
WHERE LENGTH(title) = 8;

-- -------------------------------------------------------------
-- LOCATE(substring, text)
-- Finds position of substring inside text.

-- EXTRACT DOMAIN OF EMAIL
SELECT email,
       SUBSTRING(email, LOCATE('@', email) + 1) AS domain
FROM sakila.customer;

-- -------------------------------------------------------------
-- SUBSTRING_INDEX(text, delimiter, count)
-- Extracts portion before or after delimiter.
-- Negative count gives from the end.

SELECT SUBSTRING_INDEX(email, '@', -1) AS domain
FROM sakila.customer;

-- -------------------------------------------------------------
-- UPPER() and LOWER()
-- Converts to upper/lower case.
-- Useful for case insensitive searches.

SELECT title, UPPER(title), LOWER(title)
FROM sakila.film
WHERE UPPER(title) LIKE '%LOVE%' OR UPPER(title) LIKE '%MAN%';

-- -------------------------------------------------------------
-- LEFT(text, n), RIGHT(text, n)
-- Extracts leftmost or rightmost characters.

SELECT LEFT(title, 1) AS first_letter,
       RIGHT(title, 1) AS last_letter,
       COUNT(*) AS film_count
FROM sakila.film
GROUP BY LEFT(title,1), RIGHT(title,1)
ORDER BY film_count DESC;

-- -------------------------------------------------------------
-- CASE STATEMENT THEORY
-- CASE is used to apply conditional logic inside SQL.
-- Similar to IF-ELSE in programming.

SELECT last_name,
       CASE 
           WHEN LEFT(last_name,1) BETWEEN 'A' AND 'M' THEN 'Group A-M'
           WHEN LEFT(last_name,1) BETWEEN 'N' AND 'Z' THEN 'Group N-Z'
           ELSE 'Other'
       END AS name_group
FROM sakila.customer;

-- -------------------------------------------------------------
-- REPLACE(text, old, new)
-- Replaces occurrences of substring.

SELECT title, REPLACE(title, 'A', 'X') AS replaced_title
FROM sakila.film;

-- -------------------------------------------------------------
-- REGEXP THEORY
-- REGEXP allows PATTERN matching using regular expressions.
-- Examples:
-- '[AEIOUaeiou]$' -> ends with vowel
-- '[^aeiou]{3}' -> does NOT contain 3 vowels in a row

SELECT LOWER(title)
FROM sakila.film
WHERE title REGEXP '[aeiouAEIOU]$';

-- =============================================================
-- 2. MATH FUNCTIONS THEORY
-- Math functions help with calculations, analysis, and reporting.

-- -------------------------------------------------------------
-- POWER(x, y) or x ^ y
-- Returns x raised to the power y (x^y).

SELECT film_id, rental_duration, POWER(rental_duration, 2) AS squared
FROM sakila.film
LIMIT 5;

-- -------------------------------------------------------------
-- MOD(a, b)
-- Remainder after division.
-- Useful for time conversions or patterns.

SELECT film_id, length, MOD(length, 60) AS extra_minutes
FROM sakila.film;

-- -------------------------------------------------------------
-- CEIL(x) / FLOOR(x)
-- CEIL: rounds up to nearest whole number.
-- FLOOR: rounds down.

SELECT rental_rate, CEIL(rental_rate), FLOOR(rental_rate)
FROM sakila.film;

-- -------------------------------------------------------------
-- ROUND(x, decimal_places)
-- Rounds a number to given decimals.

SELECT rental_rate, 
       ROUND(replacement_cost / rental_rate, 0),
       ROUND(replacement_cost / rental_rate, 1) AS ratio
FROM sakila.film;

-- -------------------------------------------------------------
-- RAND()
-- Generates random number between 0 and 1.
-- Often used for assigning random scores or sampling.

SELECT customer_id, FLOOR(RAND() * 100) AS random_score
FROM sakila.customer
LIMIT 5;

-- -------------------------------------------------------------
-- CAST()
-- Converts one datatype into another.
-- Example: DECIMAL to CHAR, CHAR to INT

SELECT amount, CAST(amount AS SIGNED) AS amount_integer
FROM sakila.payment;

-- =============================================================
-- 3. DATE AND TIME FUNCTIONS THEORY
-- Date functions are used for scheduling, reporting, analytics.

-- -------------------------------------------------------------
-- DATEDIFF(date1, date2)
-- Returns difference between dates in days.

SELECT rental_id, return_date, rental_date,
       DATEDIFF(return_date, rental_date) AS days_rented
FROM sakila.rental
WHERE return_date IS NOT NULL;

-- -------------------------------------------------------------
-- MONTH(date), MONTHNAME(date)
-- Extract month number or month name.

SELECT last_update, MONTH(last_update), MONTHNAME(last_update)
FROM sakila.film;

-- -------------------------------------------------------------
-- YEAR(date)
SELECT rental_date, YEAR(rental_date)
FROM sakila.rental;

-- -------------------------------------------------------------
-- DATE() extracts date part only

SELECT payment_date, DATE(payment_date) AS pay_day
FROM sakila.payment
GROUP BY DATE(payment_date);

-- -------------------------------------------------------------
-- NOW(), CURDATE(), CURRENT_TIME
-- NOW(): full timestamp
-- CURDATE(): date only
-- CURRENT_TIME(): time only

SELECT NOW(), CURDATE(), CURRENT_TIME;

-- -------------------------------------------------------------
-- INTERVAL
-- Used for date arithmetic (add or subtract time periods)

SELECT customer_id, amount, payment_date
FROM sakila.payment
WHERE payment_date >= NOW() - INTERVAL 1 DAY;

-- =============================================================
-- 4. CASTING AND TYPE CONVERSION THEORY

ALTER TABLE sakila.payment
ADD COLUMN amount_str VARCHAR(20);

UPDATE sakila.payment
SET amount_str = CAST(amount AS CHAR);

SELECT amount, amount_str, 
       amount + 10 AS numeric_add,
       amount_str + 10 AS string_add
FROM sakila.payment
LIMIT 5;

SHOW COLUMNS FROM sakila.payment;

SELECT CAST('2017-08-25' AS DATETIME);

-- END OF SESSION 3 FULL THEORY FILE
