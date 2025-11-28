-- RELATIONSHIPS AND TYPES OF JOINS

-- A relationship defines how two tables are connected using keys.

-- 1:1 RELATIONSHIP
-- One row in table A matches exactly one row in table B.
-- Example: users table and user_profiles table.

-- INNER JOIN (only matching rows)
SELECT u.user_id, u.user_name, p.profile_status
FROM joins.users u
INNER JOIN joins.user_profiles p ON u.user_id = p.user_id;

-- LEFT JOIN (all users, profile only if available)
SELECT u.user_id, u.user_name, p.profile_status
FROM joins.users u
LEFT JOIN joins.user_profiles p ON u.user_id = p.user_id;

-- RIGHT JOIN (all profiles, users only if matched)
SELECT u.user_id, u.user_name, p.profile_status
FROM joins.users u
RIGHT JOIN joins.user_profiles p ON u.user_id = p.user_id;

-------------------------------------------------------------

-- 1:MANY RELATIONSHIP
-- One user can have many orders.
-- Example: users → orders

SELECT u.user_id, u.user_name, o.order_id, o.order_status
FROM joins.users u
LEFT JOIN joins.orders o ON u.user_id = o.user_id;

-------------------------------------------------------------

-- MANY:1 RELATIONSHIP
-- Many orders belong to one user.

SELECT o.order_id, o.order_status, u.user_name
FROM joins.orders o
JOIN joins.users u ON o.user_id = u.user_id;

-------------------------------------------------------------

-- MANY:MANY RELATIONSHIP
-- Users can add many friends and can be added by many.
-- Achieved using a bridge table (friendships)

SELECT u.user_name AS user, f.user_name AS friend
FROM joins.friendships fs
JOIN joins.users u ON fs.user_id = u.user_id
JOIN joins.users f ON fs.friend_id = f.user_id;

-------------------------------------------------------------

-- INNER JOIN
-- Returns rows only when matching in both tables
SELECT u.user_name, o.order_id
FROM joins.users u
INNER JOIN joins.orders o ON u.user_id = o.user_id;

-- LEFT JOIN
-- Returns all users even if no orders exist
SELECT u.user_name, o.order_id
FROM joins.users u
LEFT JOIN joins.orders o ON u.user_id = o.user_id;

-- Find unmatched rows using LEFT JOIN
SELECT u.user_name, o.order_id
FROM joins.users u
LEFT JOIN joins.orders o ON u.user_id = o.user_id
WHERE o.user_id IS NULL;

-- RIGHT JOIN
-- Returns all orders even if a user is missing
SELECT u.user_name, o.order_id
FROM joins.users u
RIGHT JOIN joins.orders o ON u.user_id = o.user_id;

-------------------------------------------------------------

-- FULL OUTER JOIN substitute in MySQL using UNION
SELECT u.user_name, o.order_id
FROM joins.users u
LEFT JOIN joins.orders o ON u.user_id = o.user_id
UNION
SELECT u.user_name, o.order_id
FROM joins.users u
RIGHT JOIN joins.orders o ON u.user_id = o.user_id;

-------------------------------------------------------------

-- CROSS JOIN
-- Every user paired with every order
SELECT u.user_name, o.order_id
FROM joins.users u
CROSS JOIN joins.orders o;

-------------------------------------------------------------

-- SELF JOIN
-- Table joined with itself
SELECT u.user_name AS user, f.user_name AS friend
FROM joins.users u
JOIN joins.friendships fs ON u.user_id = fs.user_id
JOIN joins.users f ON fs.friend_id = f.user_id;

-------------------------------------------------------------

-- DISTINCT with JOIN example
SELECT DISTINCT c.customer_id, c.first_name, r.*
FROM sakila.customer c
JOIN sakila.rental r ON c.customer_id = r.customer_id;

-------------------------------------------------------------

-- AGE CALCULATION EXAMPLE
SELECT
  @dob   := DATE('1998-04-18') AS dob,
  @today := CURDATE() AS today,
  @yrs   := TIMESTAMPDIFF(YEAR, @dob, @today) AS yrs,
  @mons  := TIMESTAMPDIFF(MONTH, DATE_ADD(@dob, INTERVAL @yrs YEAR), @today) AS mons,
  CONCAT(@yrs, ' years, ', @mons, ' months, ',
         DATEDIFF(@today, DATE_ADD(DATE_ADD(@dob, INTERVAL @yrs YEAR), INTERVAL @mons MONTH)),
         ' days') AS age_ymd;
