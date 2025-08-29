/* ✅ UPDATE Statement: Syntax & Basics

UPDATE table_name
SET column1 = value1, column2 = value2, ...
WHERE condition;

🔒 Important:
Always include a WHERE clause unless you want to update all rows in the table (which can be dangerous).

You can update one or multiple columns at once.

You can include expressions like price = price * 1.1 for calculations.
*/

-- 🔹 This query updates the 'price' of the product with product_id = 7 to 500
UPDATE products
SET price = 500
WHERE product_id = 7;

-- 🔹 This query updates two columns at once:
-- 1. Sets the price to 700
-- 2. Changes the category to category_id = 2 (e.g., Clothing)
-- for the product with product_id = 7
UPDATE products
SET price = 700,
    category_id = 2
WHERE product_id = 7;

-- Update the city of customer with ID = 3 to 'New York City'
UPDATE customers
SET city = 'New York City'
WHERE customer_id = 3;

-- Fix spelling in product description where product_id = 4
UPDATE products
SET description = 'Automatic drip coffee maker with timer'
WHERE product_id = 4;

-- Reduce prices by 10% for all products in the 'Electronics' category (category_id = 1)
UPDATE products
SET price = price * 0.9
WHERE category_id = 1;

-- 🔸 4. Set NULL Supplier Values to a Default Name
-- Replace NULL supplier values with 'Unknown Supplier'
UPDATE products
SET supplier = 'Unknown Supplier'
WHERE supplier IS NULL;

-- Set order_rating to 4.0 for orders with NULL ratings and total_amount > 100
UPDATE orders
SET order_rating = 4.0
WHERE order_rating IS NULL AND total_amount > 100;

-- Move all products from category_id = 3 (Home and Kitchen) to category_id = 5 (Toys)
UPDATE products
SET category_id = 5
WHERE category_id = 3;
