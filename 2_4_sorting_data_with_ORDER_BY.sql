-- Select all columns from the 'products' table and sort the results by 'price' in ascending order (lowest to highest)
SELECT * 
FROM products 
ORDER BY price;

-- Select all columns from the 'customer' table and sort the results alphabetically by 'customer_name' (A to Z)
SELECT * 
FROM customer 
ORDER BY customer_name;

-- Select all columns from the 'customer' table and sort the results by 'customer_name' in descending order (Z to A)
SELECT * 
FROM customer 
ORDER BY customer_name DESC;

-- Select all columns from the 'products' table and sort by 'price' first (ascending),
-- and if two products have the same price, sort them alphabetically by 'name'
SELECT * 
FROM products 
ORDER BY price, name;

-- Corrected version: Select products where price is NOT greater than 100 (i.e., price is less than or equal to 100)
-- Then sort the results by 'price' in ascending order
SELECT * 
FROM products 
WHERE price <= 100 
ORDER BY price;


/* Key Concepts for Beginners: 
1. ORDER BY Basics
- ORDER BY column_name sorts results in ascending order by default (A to Z, 0 to 9).
- Add DESC to sort in descending order (Z to A, 9 to 0).
- You can sort by multiple columns to break ties.

2. Avoid SELECT * in production
- Use SELECT column1, column2 to make the query faster and more readable.
- For learning and testing, * is okay.

3. Syntax Tip
- Logical expressions like price > 100 can be inverted using NOT or better with clear alternatives:
example: 
WHERE NOT (price > 100)   -- Less readable
WHERE price <= 100        -- More readable and preferred

4. Aliasing for readability (Optional for beginners):

SELECT name AS product_name, price AS product_price 
FROM products 
ORDER BY product_price;
*/

-- Show only the 3 most expensive products using ORDER BY with DESC and LIMIT
SELECT * 
FROM products 
ORDER BY price DESC 
LIMIT 3;

-- Sort customers by the number of characters in their name (shortest to longest)
SELECT * 
FROM customers 
ORDER BY LENGTH(customer_name);

-- 💡 Tip: You can use SQL functions like LENGTH() inside ORDER BY.

-- Sort products by price but show NULL prices last
SELECT * 
FROM products 
ORDER BY price ASC NULLS FIRST;

-- 💡 Tip: NULLS FIRST or NULLS LAST can be useful when you want control over how missing values appear in sorting.

-- Example 9: Custom Sort Order Using CASE
-- Sort products putting 'Electronics' first, then 'Clothing', then others
SELECT * 
FROM products 
ORDER BY 
  CASE 
    WHEN category = 'Electronics' THEN 1
    WHEN category = 'Clothing' THEN 2
    ELSE 3
  END;
-- 💡 Tip: ORDER BY CASE is great when you want a custom, non-alphabetical sort order.

-- Example 10: Sort by Multiple Columns with Different Directions
-- Sort products by category (A to Z), and within each category by price (high to low)
SELECT * 
FROM products 
ORDER BY category_id ASC, price DESC;
-- 💡 Tip: Each column in ORDER BY can have its own ASC or DESC.

/*
| Feature              | Example                       | Notes                          |
| -------------------- | ----------------------------- | ------------------------------ |
| Basic sort           | `ORDER BY price`              | Ascending by default           |
| Descending sort      | `ORDER BY price DESC`         | Highest first                  |
| Multiple columns     | `ORDER BY price, name`        | Tie-breaker sorting            |
| Function in ORDER BY | `ORDER BY LENGTH(name)`       | Sort by calculated value       |
| NULL handling        | `ORDER BY price NULLS LAST`   | Control sort of missing values |
| Custom order         | `ORDER BY CASE ... END`       | Manual sort order              |
| Limit results        | `ORDER BY price DESC LIMIT 5` | Top-N results                  |

	*/