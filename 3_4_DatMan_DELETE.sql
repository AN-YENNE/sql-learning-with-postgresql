/*
✅ SQL Commands for Deleting Data and Tables
1. DELETE — Remove rows (records) from a table
DELETE FROM table_name
WHERE condition;


Deletes specific rows that match the condition.

Use WHERE to specify which rows to delete; without WHERE, all rows will be deleted (dangerous!).

Data structure and table remain intact after deleting rows.

2. TRUNCATE — Remove all rows quickly
TRUNCATE TABLE table_name;


Removes all rows from the table.

Faster and uses fewer resources than DELETE without a WHERE.

Does not fire DELETE triggers.

Table structure remains intact and ready for new data.

Cannot be used with WHERE clause.

3. DROP TABLE — Remove the entire table and its data permanently
DROP TABLE table_name;


Deletes the entire table structure and data.

After this, the table no longer exists in the database.

Use with caution!*/

-- 🔹 Delete product(s) where product_id = 7
-- This removes only the row(s) matching the condition
DELETE FROM products
WHERE product_id = 7;

-- 🔹 Delete all rows from the table "FruitJuice" in the public schema
-- Note: No WHERE clause means all rows get deleted but table remains
DELETE FROM public."FruitJuice";

-- 🔹 Remove all rows from the table "FruitJuice" faster than DELETE
-- This empties the table completely but keeps the table structure
TRUNCATE public."FruitJuice";

-- 🔹 Permanently remove the entire table "FruitJuice" and its data
-- The table no longer exists after this command
DROP TABLE public."FruitJuice";

--🔸 Delete customers from a specific city
-- Delete customers who live in 'Gotham City'
DELETE FROM customers
WHERE city = 'Matrix';

--🔸 Delete all orders older than a certain date
-- Delete orders before January 1, 2023
DELETE FROM orders
WHERE order_timestamp < '2023-01-01';


--🔸 Truncate a table (reset it)
-- Quickly remove all rows from 'orders' table (use with caution!)
TRUNCATE TABLE orders;

-- Drop a table you no longer need
-- Remove the 'categories' table permanently
DROP TABLE categories;

/*
⚠️ Important Safety Tips

Always backup important data before deleting or dropping tables.

Use DELETE with WHERE to avoid accidental deletion of all data.

TRUNCATE is faster but cannot be rolled back in some databases.

DROP TABLE completely removes the table and cannot be undone.*/
