-- 👋 Welcome! This script creates and populates a basic e-commerce-like database.
-- It includes categories, products, customers, and orders.

-- 🧠 Single-line comments use --
-- 🧠 Multi-line comments use /* ... */

-- 📦 Create the CATEGORIES table
-- Each product will belong to one category (e.g., Electronics, Clothing)
CREATE TABLE categories (
    category_id SERIAL PRIMARY KEY, -- auto-incrementing unique ID for each category
    name VARCHAR(100)               -- name of the category
);

-- 🛍️ Create the PRODUCTS table
-- Stores details about items available for sale
CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,           -- auto-incrementing unique product ID
    name VARCHAR(100),                       -- name of the product
    price DECIMAL(10,2),                     -- product price (up to 99999999.99)
    description VARCHAR(255),                -- short description of the product
    category_id INT,                         -- foreign key linking to the categories table
    FOREIGN KEY (category_id) REFERENCES categories(category_id),
    supplier VARCHAR(100)                    -- name of the supplier (optional)
);

-- 🧍 Create the CUSTOMER table
-- Holds personal information about each customer
CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,      -- unique ID for each customer
    customer_name VARCHAR(50) NOT NULL,  -- name of the customer
    email VARCHAR(50) NOT NULL,          -- customer email
    phone_number VARCHAR(20),            -- optional phone number
    address VARCHAR(255),                -- street address
    city VARCHAR(255)                    -- city of residence
);

-- 🧾 Create the ORDERS table
-- Represents a customer's purchase of a product
CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,         -- unique order ID
    customer_id INT,                     -- who placed the order
    product_id INT,                      -- which product was ordered
    total_quantity INT,                  -- number of items ordered
    total_amount DECIMAL(10,2),          -- total price of the order
    order_rating DECIMAL(3,2),           -- customer rating (e.g. 4.5)
    length DECIMAL(5,2),                 -- dimensions of the item (for shipping)
    width DECIMAL(5,2),
    order_timestamp TIMESTAMP,          -- when the order was placed
    deliver_timestamp TIMESTAMP,        -- when the order was delivered
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
);

-- ✅ Insert some example categories
INSERT INTO categories (name)
VALUES 
    ('Electronics'), 
    ('Clothing'), 
    ('Home and Kitchen Items');

-- ✅ Insert sample products
INSERT INTO products (name, price, description, tags, category_id, supplier)
VALUES
    ('Laptop', NULL, 'High-performance laptop for professionals', 'electronics, portable, tech', 1, 'SupplierA'),
    ('Headphones', 129.99, 'Over-ear wireless headphones', 'electronics, audio, accessories',1, 'SupplierB'),
    ('Backpack', 49.99, 'Stylish and durable backpack for everyday use', 'fashion, accessories, travel',2, NULL),
    ('Coffee Maker', NULL, 'Automatic drip coffee maker with programmable timer', 'home, kitchen, appliances',3, NULL),
    ('Fitness Tracker', 79.99, 'Water-resistant fitness tracker with heart rate monitor','electronics, fitness, wearables', 1, NULL);

-- ✅ Insert some customers
INSERT INTO customers (customer_name, email, phone_number, address, city) 
VALUES
    ('Alice Johnson', 'alice@example.com', '123-456-7890', '123 Main St', 'Cityville'),
    ('Bob Smith', 'bob@example.com', '987-654-3210', '456 Oak Ave', 'Townsville'),
    ('Charlie Brown', 'charlie@example.com', '555-123-4567', '789 Pine Ln', 'New York'),
    ('David White', 'david@example.com', '222-333-4444', '567 Maple Dr', 'NYC'),
    ('Eva Black', 'eva@example.com', '999-888-7777', '890 Cedar Rd', 'Big Apple'),
    ('Frank Green', 'frank@example.com', '111-222-3333', '123 Elm St', 'Gotham City');

-- ✅ Insert some orders
INSERT INTO orders (
    customer_id, product_id, total_quantity, total_amount, 
    order_rating, length, width, order_timestamp, deliver_timestamp
)
VALUES
    (1, 1, 5, 120.50, 4.5, 2.3, 1.8, '2023-01-15 10:30:00', '2023-01-16 15:45:00'),
    (2, 2, 3, 75.25, 3.8, 1.5, 1.2, '2023-02-03 14:20:00', '2023-02-05 11:10:00'),
    (3, 3, 7, 210.75, 4.2, 2.8, 2.0, '2023-03-12 08:45:00', '2023-03-14 09:30:00'),
    (1, 4, 2, 50.00, 4.0, 1.8, 1.5, '2023-04-05 12:15:00', '2023-04-07 18:20:00');

-- 🔍 Run queries to display all data from each table
-- Display all categories
SELECT * FROM categories;

-- Display all products
SELECT * FROM products;

-- Display all customers
SELECT * FROM customers;

-- Display all orders
	SELECT * FROM orders;
