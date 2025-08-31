-- Views
/*
✅ What is a SQL View?

A view is like a virtual table based on a SQL query.
It does not store data itself.
It stores a saved query that you can use like a table.
When you query a view, SQL runs the underlying query in real-time.

🧠 Why Use Views?
| Purpose         | Benefit                                           |
| --------------- | ------------------------------------------------- |
| Reusability     | Save complex queries and reuse them easily        |
| Simplification  | Hide complex joins and aggregations               |
| Security        | Restrict access to sensitive columns              |
| Maintainability | Update logic in one place instead of many queries |

🛠️ Syntax of a View
CREATE VIEW view_name AS
SELECT column1, column2, ...
FROM table_name
[WHERE condition]
[GROUP BY ...]
[JOIN ...];

Note: 🧼 Think of it like creating a saved query you can SELECT from like a normal table.


*/
-- ✅ Example: Create View from orders: Create a view to show total number of orders and total spend per customer
-- Create a view to show total number of orders and total spend per customer
CREATE VIEW customer_order_summary AS
SELECT 
  customer_id,
  COUNT(order_id) AS total_orders,       -- Total number of orders per customer
  SUM(total_amount) AS total_spent       -- Total money spent by each customer
FROM orders
GROUP BY customer_id;
--✅ Querying the View
-- Now you can use this view just like a table
SELECT * FROM customer_order_summary;

-- Find summary for customer with ID 1
SELECT * FROM customer_order_summary WHERE customer_id = 1;

--🔍 Example 2: View for Product Sales Summary
-- Create a view to show product-wise sales info
CREATE VIEW product_sales_summary AS
SELECT 
  p.product_id,
  p.name AS product_name,
  COUNT(o.order_id) AS total_orders,
  SUM(o.total_quantity) AS total_quantity_sold,
  SUM(o.total_amount) AS total_sales
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.name;

-- View top 5 best-selling products
SELECT * FROM product_sales_summary
ORDER BY total_quantity_sold DESC
LIMIT 5;

--🧑‍💼 Example 3: View Combining Customer & Order Info
-- View showing customer name, city, and total spending
CREATE VIEW customer_spending AS
SELECT 
  c.customer_id,
  c.customer_name,
  c.city,
  SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name, c.city;

-- Customers who spent more than $200
SELECT * FROM customer_spending WHERE total_spent > 200;

--🧽 Updating or Dropping Views
-- Delete a view if you no longer need it
DROP VIEW customer_order_summary;

-- Replace or update a view
CREATE OR REPLACE VIEW customer_order_summary AS
SELECT 
  customer_id,
  COUNT(order_id) AS total_orders,
  SUM(total_amount) AS total_spent,
  AVG(total_amount) AS avg_spent_per_order
FROM orders
GROUP BY customer_id;

/*📝 Notes and Tips for Views
| Tip # | Description                                                                          |
| ----- | ------------------------------------------------------------------------------------ |
| 💡 1  | Views do **not** store data—just the SQL logic. Data comes from base tables.         |
| 💡 2  | If base tables change (rows added/updated), views reflect the changes automatically. |
| 💡 3  | Views can be **joined, filtered, and ordered** just like real tables.                |
| 💡 4  | Use `CREATE OR REPLACE VIEW` if you want to update a view’s logic.                   |
| 💡 5  | You **can’t create indexes** on regular views (use materialized views for that).     |

🔄 BONUS: Materialized View vs View
| Feature      | View                 | Materialized View                    |
| ------------ | -------------------- | ------------------------------------ |
| Data storage | Virtual (no data)    | Physically stored                    |
| Performance  | Always fresh, slower | Faster, may be stale                 |
| Use case     | Real-time data       | Heavy or slow queries                |
| Refresh      | Not needed           | Must use `REFRESH MATERIALIZED VIEW` |


✅ What Is a Materialized View?

A Materialized View is like a cached version of a regular view. Unlike a normal view, which runs the query every time, a materialized view stores the result of the query physically on disk.

🔁 Think of it as: “Precomputed results saved for fast access.”

🧠 Key Features:
| Feature                | Materialized View                               |
| ---------------------- | ----------------------------------------------- |
| **Stores Data?**       | ✅ Yes (physically stored)                       |
| **Always Up-to-date?** | ❌ No (you must refresh manually or on schedule) |
| **Faster Access?**     | ✅ Yes (especially for large aggregations)       |
| **Use Cases**          | Reporting dashboards, heavy joins, summaries    |

🛠️ Syntax:
-- Creating a materialized view
CREATE MATERIALIZED VIEW view_name AS
SELECT ...
FROM ...
[WHERE ...]
[GROUP BY ...];

-- Refreshing the materialized view
REFRESH MATERIALIZED VIEW view_name;

*/

--📘 Example 1: Customer Spending Summary
-- Create a materialized view to store total spending by each customer
CREATE MATERIALIZED VIEW customer_spending_mv AS
SELECT 
  c.customer_id,
  c.customer_name,
  SUM(o.total_amount) AS total_spent,
  COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

-- Query it like a regular table
SELECT * FROM customer_spending_mv WHERE total_spent > 200;

-- Refresh it when new orders/customers are added
REFRESH MATERIALIZED VIEW customer_spending_mv;

--📘 Example 2: Product Sales Summary
-- Store total quantity sold per product
CREATE MATERIALIZED VIEW product_sales_mv AS
SELECT 
  p.product_id,
  p.name AS product_name,
  SUM(o.total_quantity) AS total_quantity_sold,
  SUM(o.total_amount) AS total_sales
FROM products p
JOIN orders o ON p.product_id = o.product_id
GROUP BY p.product_id, p.name;

-- Query for top-selling products
SELECT * FROM product_sales_mv ORDER BY total_quantity_sold DESC LIMIT 5;

-- Refresh to get latest sales data
REFRESH MATERIALIZED VIEW product_sales_mv;

/* ✅ Tips & Notes for Materialized Views
| Tip # | Description                                                                                     |
| ----- | ----------------------------------------------------------------------------------------------- |
| 💾    | Materialized views **store** data and thus use disk space.                                      |
| ⚠️    | They **do not auto-update**. You must use `REFRESH MATERIALIZED VIEW`.                          |
| 🔄    | You can schedule refreshes with **cron jobs or triggers** (e.g., in PostgreSQL or a scheduler). |
| 📊    | Great for **complex queries or reports** used frequently.                                       |
| 🚀    | Faster than views when querying large data with aggregates.                                     |
| 🔐    | Can help **secure and simplify** access to complex data for BI/reporting teams.                 |

*/

--❌ Dropping a Materialized View
DROP MATERIALIZED VIEW IF EXISTS customer_spending_mv;

--BONUS: Refresh Types (PostgreSQL Specific)
-- Refresh with locking (default)
REFRESH MATERIALIZED VIEW product_sales_mv;

-- Refresh without locking (concurrent), requires unique index
REFRESH MATERIALIZED VIEW CONCURRENTLY product_sales_mv;

--Note: ⚠️ CONCURRENTLY requires a UNIQUE INDEX on the materialized view.





/*
✅ What is a Stored Procedure?

A Stored Procedure is a saved block of SQL code that you can execute (call) whenever you want.
It can contain multiple SQL statements.
It can accept input parameters.
It can perform actions like inserting, updating, deleting, or complex business logic.
It helps organize and reuse code inside the database.
Usually written in PL/pgSQL (for PostgreSQL) or other procedural languages.

🧠 Why Use Stored Procedures?
| Purpose              | Benefit                                    |
| -------------------- | ------------------------------------------ |
| Reusability          | Write logic once, reuse anytime            |
| Simplify Client Code | Move complex SQL logic to the database     |
| Security             | Restrict direct table access, control data |
| Performance          | Execute multiple SQL statements as a batch |

--🛠️ Syntax of Stored Procedures in PostgreSQL:
CREATE PROCEDURE procedure_name(parameter1 datatype, parameter2 datatype, ...)
LANGUAGE plpgsql
AS
$$
BEGIN
  -- SQL statements here
END;
$$;

- CREATE PROCEDURE defines a new procedure.
- LANGUAGE plpgsql specifies procedural language.
- BEGIN ... END; wraps the procedural logic.
- Use CALL procedure_name(arguments); to run the procedure.

*/

--✅ Example Explained: Add Category
-- Create procedure to add a new category to the categories table
CREATE PROCEDURE add_category(cat_id INT, cat_name VARCHAR)
LANGUAGE plpgsql
AS
$$
BEGIN
  -- Insert the provided category id and name into categories table
  INSERT INTO categories VALUES (cat_id, cat_name);
END;
$$;

-- Call procedure to add category with id=6 and name='Fashion'
CALL add_category(20, 'Fashion');

-- Check if new category is added
SELECT * FROM categories;

DROP PROCEDURE add_category; --Drop the procedure if no longer needed

--Example 2: Update Product Price
-- Procedure to update price of a product by product_id
CREATE PROCEDURE update_product_price(p_id INT, new_price DECIMAL)
LANGUAGE plpgsql
AS
$$
BEGIN
  UPDATE products
  SET price = new_price
  WHERE product_id = p_id;
END;
$$;

-- Call to update price of product with id 3 to 99.99
CALL update_product_price(3, 99.99);

--Example 3: Delete Customer by ID
-- Procedure to delete a customer by customer_id
CREATE PROCEDURE delete_customer(cust_id INT)
LANGUAGE plpgsql
AS
$$
BEGIN
  DELETE FROM customer
  WHERE customer_id = cust_id;
END;
$$;

-- Call to delete customer with ID 4
CALL delete_customer(4);

--Example 4: Insert New Order with multiple inputs
CREATE PROCEDURE add_order(cust_id INT, prod_id INT, qty INT, amt DECIMAL, rating DECIMAL, ord_ts TIMESTAMP, del_ts TIMESTAMP)
LANGUAGE plpgsql
AS
$$
BEGIN
  INSERT INTO orders (customer_id, product_id, total_quantity, total_amount, order_rating, order_timestamp, delivery_timestamp)
  VALUES (cust_id, prod_id, qty, amt, rating, ord_ts, del_ts);
END;
$$;

CALL add_order(2, 1, 10, 999.99, 4.8, '2024-08-30 12:00:00', '2024-09-02 15:00:00');

/*📝 Notes and Tips
| Tip # | Description                                                                          |
| ----- | ------------------------------------------------------------------------------------ |
| 🔁    | Procedures are reusable chunks of SQL logic; good for modular code.                  |
| 🧰    | You can include conditional logic (`IF`, `LOOP`, `CASE`) inside procedures.          |
| ⚠️    | Procedures **do not return data** directly; use **functions** for returning results. |
| 🧮    | Use `CALL` to execute stored procedures.                                             |
| 🔄    | You can use `IN`, `OUT`, and `INOUT` parameters for input and output values.         |
| 🧹    | Keep procedures simple and focused for maintainability.                              |

Summary:
Stored Procedures help automate repetitive or complex database tasks.
They take input parameters to customize behavior.
Use Them to insert, update, delete, or even complex transactions.
Unlike views, they perform actions instead of just presenting data.
*/