
-- 🔹 This command adds a new row to the 'Products' table
-- We're specifying values for the following columns:
-- name, price, description, tags, category_id, and Supplier

INSERT INTO Products (
    name,                 -- Name of the product
    price,                -- Price in decimal format (e.g., 100.00)
    description,          -- Short description of the product
    tags,                 -- Comma-separated keywords (can help in searching/filtering)
    category_id,          -- Refers to the category from 'Categories' table (foreign key)
    Supplier              -- Name of the supplier
)
VALUES (
    'Ipad',               -- Product name
    100,                  -- Product price
    'High-performance ipad for professionals', -- Description
    'electronics, portable, tech',              -- Tags
    1,                    -- Category ID 1 corresponds to 'Electronics'
    'SupplierA'           -- Supplier name
);

/*🔁 Reminder of Table Relationships

Products.category_id ➝ references Categories.category_id

Orders.customer_id ➝ references Customer.customer_id

Orders.product_id ➝ references Products.product_id

These foreign keys ensure referential integrity, meaning a product must belong to an existing category, and orders must be linked to real customers and products
*/

--🔸 1. Insert New Category
INSERT INTO categories (name)
VALUES ('Gaming');

--🔸 2. Insert Products (multiple rows at once)
-- Insert multiple products into the 'Products' table
INSERT INTO Products (name, price, description, tags, category_id, Supplier)
VALUES
  ('Gaming Console', 299.99, 'Next-gen console with 4K gaming', 'gaming, electronics, console', 1, 'SupplierX'),
  ('Air Fryer', 89.00, 'Healthy cooking with less oil', 'kitchen, home, cooking', 3, 'SupplierY'),
  ('Soccer Ball', 25.50, 'Official size and weight soccer ball', 'sports, outdoor, ball', 6, 'SupplierZ'),
  ('Lipstick Set', 35.00, 'Matte finish, long-lasting lipsticks', 'beauty, makeup, fashion', 7, 'SupplierB'),
  ('SQL Handbook', 19.99, 'Pocket reference for SQL queries', 'books, learning, tech', 4, 'SupplierH');

--🔸 3. Insert Customers (varied data for testing)
-- Insert multiple customers with different cities, emails, and phone numbers
INSERT INTO customers (customer_name, email, phone_number, address, city)
VALUES
  ('Lara Croft', 'lara@example.com', '222-333-4444', '12 Tomb Rd', 'Adventure City'),
  ('Neo Matrix', 'neo@example.com', NULL, '404 Reality St', 'Matrix'),
  ('Tony Stark', 'tony@starkindustries.com', '555-IRON-MAN', NULL, 'Malibu'),
  ('Bruce Wayne', 'bruce@wayneenterprises.com', '777-BATMAN', '100 Gotham St', 'Gotham City'),
  ('Diana Prince', 'diana@example.com', NULL, NULL, NULL);

--🔸 4. Insert Orders (join customers + products logically)
-- Insert orders linking to customer_id and product_id
INSERT INTO Orders (
  customer_id, product_id, total_quantity, total_amount,
  order_rating, length, width, order_timestamp, deliver_timestamp
)
VALUES
  -- Lara ordered 1 Air Fryer
  (11, 2, 1, 89.00, 4.8, 1.8, 1.5, '2024-01-15 10:00:00', '2024-01-17 12:00:00'),

  -- Tony ordered 2 Gaming Consoles
  (13, 1, 2, 599.98, 4.9, 2.5, 2.0, '2024-02-01 15:30:00', '2024-02-03 09:00:00'),

  -- Neo ordered SQL Handbook (digital - zero size)
  (12, 5, 1, 19.99, NULL, NULL, NULL, '2024-03-10 13:00:00', NULL),

  -- Bruce ordered a Lipstick Set (for charity drive?)
  (14, 4, 3, 105.00, 4.3, 2.0, 1.7, '2024-04-05 08:00:00', '2024-04-07 10:00:00');

/*
🧠 Learning Tips
1.Always match your inserted values to the column order and data types.
2.Use NULL for missing/unknown values (don’t use 'NULL' as a string).
3.Insert diverse data (e.g., some NULLs, different categories, prices) to make your learning more effective.
4.Use RETURNING *; (in PostgreSQL) after INSERT to instantly see what was added: like below example*/
INSERT INTO categories (name) VALUES ('Photography') RETURNING *;



/*
Great question! If you've made a spelling mistake in a column name, you'll need to use the ALTER TABLE ... RENAME COLUMN command to fix it.*/
ALTER TABLE orders
RENAME COLUMN deliver_timestamp TO delivery_timestamp;