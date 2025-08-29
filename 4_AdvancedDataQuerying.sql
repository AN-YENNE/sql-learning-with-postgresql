--✅ 4.2: INNER JOIN – Only Matching Records from Both Tables
/* 🔹 Basic Syntax:
SELECT columns
FROM table1
INNER JOIN table2
  ON table1.key = table2.key;
*/

-- Join orders and products to get product name, description, and total order amount
SELECT p.name, p.description, o.total_amount
FROM orders o
INNER JOIN products p ON p.product_id = o.product_id;

-- Join orders and customers to get customer name and how much they spent
SELECT c.customer_name, o.total_amount
FROM orders o
JOIN customer c ON c.customer_id = o.customer_id;
--Note: 🔸 INNER JOIN returns only rows that exist in both tables with matching keys.

--✅ 4.3: LEFT JOIN & RIGHT JOIN – Keep All Rows from One Side
-- 🔹 LEFT JOIN = All from Left Table + Matches from Right
-- Show all customers, and their orders if they exist
SELECT c.customer_name, o.total_amount
FROM customer c
LEFT JOIN orders o ON c.customer_id = o.customer_id;
-- 🔸 Useful for finding customers who have not placed orders (their order values will be NULL).

--🔹 LEFT JOIN with Products:
-- Show all orders, and product details if available
SELECT p.name, o.total_quantity
FROM orders o
LEFT JOIN products p ON p.product_id = o.product_id;

--🔹 RIGHT JOIN = All from Right Table + Matches from Left
SELECT c.customer_name, o.total_amount
FROM customers c
RIGHT JOIN orders o
ON c.customer_id = o.customer_id;

--✅ 4.4: FULL OUTER JOIN – All Records from Both Tables
-- Show all customers and all orders, even if they don’t match
SELECT c.customer_name, o.total_quantity
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;


-- Show full combination of customers, orders, and products, even when data is missing
SELECT c.customer_name, p.name, o.total_quantity
FROM customer c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id
FULL OUTER JOIN products p ON p.product_id = o.product_id;
-- Note: 🔸 Use FULL OUTER JOIN when you want to see everything, including unmatched data on both sides.


select customer_name, name, total_quantity from customer c full outer join orders o on c.customer_id = o.customer_id full outer join
products p on p.product_id = o.product_id ;

--✅ 4.5: UNION – Combine Rows from Multiple Queries
/*
Syntax:
SELECT column1 FROM table1
UNION
SELECT column1 FROM table2;

Removes duplicates by default.
Note: Use UNION ALL to include duplicates.
*/
-- Combine customer names and supplier names into one list
SELECT customer_name AS name FROM customer
UNION
SELECT supplier AS name FROM products WHERE supplier IS NOT NULL;

--4.6 CASE – Conditional Logic in SQL
-- Label products based on their price range
SELECT name, description, price,
  CASE
    WHEN price < 100 THEN 'Cheap'
    WHEN price >= 100 AND price < 500 THEN 'Affordable'
    ELSE 'Expensive'
  END AS ProductType
FROM products;
-- Note: 🔸 CASE works like an IF-ELSE block inside a query.

--✅ 4.7: GROUP BY – Grouping Similar Rows for Aggregation
/* Syntax:
SELECT column, AGG_FUNC(column)
FROM table
GROUP BY column;
*/
-- Group only by city to count customers in each city
SELECT city, COUNT(customer_id)
FROM customers
GROUP BY city;

--4.8 Common aggregation functions: SUM, MAX, MIN, STDDEV, avg, COUNT etc
-- Count total rows in customer table
SELECT COUNT(customer_id) AS Total_Row_Count FROM customer;

-- Count all rows (including NULLs)
SELECT COUNT(*) AS Total_Row_Count FROM customer;

-- Count distinct customer IDs
SELECT COUNT(DISTINCT customer_id) AS Unique_Customers FROM customer;

-- Sum of all order amounts
SELECT SUM(total_amount) FROM orders;

-- Max, Min, Average, Stddev of order amounts
SELECT MAX(total_amount) FROM orders;
SELECT MIN(total_amount) FROM orders;
SELECT AVG(total_amount) FROM orders;
SELECT STDDEV(total_amount) FROM orders;

--✅ 4.9: GROUP BY with HAVING – Filter After Grouping
/*🔹 Syntax:
SELECT column, COUNT(*) FROM table
GROUP BY column
HAVING COUNT(*) > n;
*/
-- Show cities that have more than 100 customers
SELECT city, COUNT(*) 
FROM customers 
GROUP BY city 
HAVING COUNT(*) > 100;

-- Show categories that have more than 1 product associated with them
SELECT 
  c.name,               -- Select the category name
  c.category_id,        -- Select the category ID
  COUNT(p.product_id)   -- Count how many products belong to each category

FROM 
  categories c          -- From the 'categories' table, alias it as 'c' for shorter references

JOIN 
  products p            -- Join with the 'products' table, alias as 'p'
  ON c.category_id = p.category_id  -- Join condition: match category IDs in both tables

GROUP BY 
  c.category_id,        -- Group results by category ID
  c.name                -- Group results by category name (needed because it appears in SELECT)

HAVING 
  COUNT(p.product_id) > 1  -- Only include categories where the count of products is greater than 1


