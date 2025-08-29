-- Categories — Add more category diversity
INSERT INTO Categories (name) VALUES 
  ('Books'),
  ('Toys'),
  ('Sports'),
  ('Beauty'),
  ('Automotive');

-- Products — More variation for learning
INSERT INTO Products (name, price, description, tags, category_id, Supplier)
VALUES
  ('Bluetooth Speaker', 59.99, 'Portable Bluetooth speaker with rich bass', 'electronics, audio, wireless', 1, 'SupplierC'),
  ('T-Shirt', 19.99, 'Cotton round-neck t-shirt', 'clothing, casual, fashion', 2, 'SupplierD'),
  ('Blender', 89.99, 'High-speed blender for smoothies', 'home, kitchen, appliances', 3, 'SupplierE'),
  ('Yoga Mat', 25.00, 'Non-slip yoga mat for workouts', 'fitness, sports, mat', 6, 'SupplierF'),
  ('Toy Car', 14.99, 'Remote-controlled toy car for kids', 'toys, kids, remote', 5, 'SupplierG'),
  ('Book: SQL Basics', 29.50, 'Beginner-friendly guide to SQL', 'books, learning, SQL', 4, 'SupplierH'),
  ('Makeup Kit', NULL, 'All-in-one professional makeup kit', 'beauty, cosmetics, kit', 7, NULL),
  ('Car Vacuum', 45.99, 'Compact vacuum cleaner for cars', 'automotive, cleaning, tools', 8, 'SupplierI'),
  ('Gaming Mouse', 39.99, 'Ergonomic mouse for gaming', 'electronics, accessories, gaming', 1, 'SupplierA'),
  ('Smartwatch', NULL, 'Feature-rich smartwatch with GPS', 'electronics, wearable, fitness', 1, 'SupplierA');


-- Customer — More variety in names, locations, and missing data
INSERT INTO customers (customer_name, email, phone_number, address, city)
VALUES
  ('Grace Hopper', 'grace@example.com', NULL, '321 Algorithm Blvd', 'Silicon Valley'),
  ('Hank Pym', 'hank@example.com', '666-777-8888', NULL, 'Quantum Town'),
  ('Irene Adler', 'irene@example.com', '444-555-6666', '456 Sherlock Rd', NULL),
  ('John Doe', 'john@example.com', NULL, NULL, NULL),
  ('Kelly Blue', 'kelly@example.com', '777-666-5555', '890 Sky St', 'Cloud City');

--Orders — Include low, high, null, zero values & time variety
INSERT INTO orders (customer_id, product_id, total_quantity, total_amount, order_rating, length, width, order_timestamp, deliver_timestamp)
VALUES
  (4, 5, 0, 0.00, NULL, 1.2, 0.8, '2023-05-01 09:00:00', NULL),  -- zero quantity, no delivery yet
  (5, 6, 10, 295.00, 4.9, 3.5, 2.5, '2023-05-15 16:45:00', '2023-05-17 10:00:00'), -- high amount
  (6, 7, 1, NULL, NULL, NULL, NULL, '2023-06-01 11:30:00', NULL), -- NULL values to test IS NULL
  (7, 8, 4, 100.00, 3.5, 2.0, 1.5, '2023-06-12 13:10:00', '2023-06-14 09:20:00'),
  (8, 9, 2, 79.98, 5.0, 1.7, 1.3, '2023-07-01 17:50:00', '2023-07-02 10:00:00'),
  (9, 10, 3, NULL, NULL, NULL, NULL, '2023-07-10 08:00:00', NULL), -- NULL price, NULL delivery
  (10, 1, 1, 950.00, 4.0, 3.0, 2.0, '2023-08-01 12:00:00', '2023-08-03 14:30:00');

-- Find all orders with missing delivery timestamps
SELECT * FROM orders WHERE deliver_timestamp IS NULL;


