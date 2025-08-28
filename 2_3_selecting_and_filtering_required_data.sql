-- Select the 'name' and 'price' columns from the 'products' table
SELECT name, price
FROM products;

-- Select all columns from the 'orders' table where the total amount is greater than 100
SELECT *
FROM orders
WHERE total_amount > 100;

-- Select all columns from the 'customer' table where the customer_name starts with the letter 'A'
SELECT *
FROM customers
WHERE customer_name LIKE 'A%';

/* Some Points to note
1. Use uppercase for SQL keywords (SELECT, FROM, WHERE) — helps readability.

2. Avoid SELECT *** in production scripts because it's better to specify columns explicitly for clarity and performance, but since this is beginner-friendly and you might want all columns, it's okay here.

3. Table names — usually plural form is more common, but depends on your schema.
*/

SELECt category_id
FROM categories
WHERE name = 'Clothing'