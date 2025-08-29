/*
| Operator          | Meaning                             | Example                             | Description                       |
| ----------------- | ----------------------------------- | ----------------------------------- | --------------------------------- |
| `AND`             | Both conditions must be true        | `price > 100 AND category_id = 2`   | Only rows where **both** are true |
| `OR`              | At least one condition must be true | `price > 100 OR category_id = 2`    | Rows where **either** is true     |
| `NOT`             | Reverses the condition              | `NOT price > 100` or `price <= 100` | Opposite of the condition         |
| `=`               | Equal to                            | `category_id = 2`                   | Exact match                       |
| `!=` or `<>`      | Not equal to                        | `category_id != 2`                  | Any value except 2                |
| `>` `<` `>=` `<=` | Comparison operators                | `price > 100`                       | Greater than, less than, etc.     |
| `BETWEEN`         | Range check                         | `price BETWEEN 50 AND 100`          | Inclusive lower and upper limits  |
| `IN`              | List check                          | `category_id IN (1, 2)`             | Matches any in the list           |
| `LIKE`            | Pattern matching                    | `name LIKE 'S%'`                    | Names that start with S           |

*/

-- 🔹 This query finds all products where:
-- 1. The price is greater than 100
-- 2. AND the category is 2 (Clothing)
-- BOTH conditions must be true
SELECT * 
FROM products 
WHERE price > 75 AND category_id = 1;

-- 🔹 This query finds all products where:
-- EITHER the price is greater than 100
-- OR the category is 2 (Clothing)
-- If either one is true, the row is included
-- Also sorts the results by product_id
SELECT *
FROM products
WHERE price > 75 OR category_id = 2
ORDER BY product_id;

-- 🔸 Use NOT to exclude results
-- Find products that are NOT in category 2
SELECT *
FROM products
WHERE NOT category_id = 2;

-- Same as above, using != (not equal)
SELECT * 
FROM products 
WHERE category_id != 2;

--🔸 Use BETWEEN for range filtering
-- Find products with prices between $50 and $100 (inclusive)
SELECT *
FROM products
WHERE price BETWEEN 50 AND 100;

--🔸 Use IN to match multiple values
-- Find products that belong to category 1, 2, or 3
SELECT *
FROM products
WHERE category_id in (1, 2, 3);

-- Use LIKE for pattern matching
-- Find customers whose names start with 'A'
SELECT *
FROM customers
WHERE customer_name LIKE 'B%'

-- Find customers whose emails end with 'example.com'
SELECT * 
FROM customers 
WHERE email LIKE '%example.com';
/* Tip:
% = wildcard for any number of characters
_ = wildcard for a single character
*/

-- Find products where category is 1 (Electronics) and either:
-- price is above 100 OR the supplier is 'SupplierA'
SELECT *
FROM products
WHERE category_id = 1 
  AND (price > 70 OR supplier = 'Supplier A');

--🔸 Null-safe query
-- Find products where price is NOT NULL
SELECT * 
FROM products 
WHERE price IS NOT NULL;

-- Find products where supplier is NULL
SELECT * 
FROM products 
WHERE supplier IS NULL;

/*
🧠 Try These Practice Challenges

1.Find all orders with a rating higher than 4.0 and quantity greater than 2.

2.Find all customers not from 'Cityville' or 'Townsville'.

3.List all products where price is less than 50 or category is 3.

4.Find customers whose phone number is missing (IS NULL).

5.List orders where total amount is between 50 and 200 and the product belongs to category 1.
*/