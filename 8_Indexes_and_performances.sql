--Creating and managing Indexes, performances
/*✅ What is an Index?

An Index is a special data structure that helps speed up data retrieval (queries).

Think of it like an index in a book: Instead of scanning the whole book page by page, you quickly find the page number from the index.

Indexes improve SELECT query performance, especially with large tables.

However, indexes add some overhead during INSERT/UPDATE/DELETE because they also need to be updated.

🛠️ Syntax for Creating Indexes:
-- Create a simple index on a column
CREATE INDEX index_name ON table_name(column_name);

-- Create a unique index (no duplicate values allowed)
CREATE UNIQUE INDEX unique_index_name ON table_name(column_name);

-- Create an index on multiple columns (composite index)
CREATE INDEX index_name ON table_name(column1, column2);

*/
-- Create an index on the 'email' column of the 'customer' table
CREATE INDEX idx_customer_email ON customers(email);

-- Index on 'category_id' column in 'products' table to speed up category filtering
CREATE INDEX idx_prod_cat ON products(category_id);

-- Unique index on 'name' column in 'products' to enforce unique product names
CREATE UNIQUE INDEX idx_prod_name ON products(name);

-- Composite index on 'customer_id' and 'order_timestamp' in 'orders' table to speed up queries filtering by customer and sorting by time
CREATE INDEX idx_cust_order ON orders(customer_id, order_timestamp);
/*
📈 Why Use Composite Index?

When queries filter or sort by multiple columns, composite indexes help.

E.g., searching orders for a customer and sorting by timestamp benefits from the (customer_id, order_timestamp) index.
*/


/*🔍 Analyzing Query Performance
Use EXPLAIN and EXPLAIN ANALYZE to see how the database plans to execute your queries and how long they take.
*/
-- Show the query plan without running the query
EXPLAIN SELECT * FROM orders WHERE order_id = 1;

-- Run the query and show execution stats (actual runtime, cost)
EXPLAIN ANALYZE SELECT * FROM orders WHERE order_id = 1;
/*What to look for in EXPLAIN output:

Index Scan: Good! It means the query used the index.
Seq Scan: Not efficient for large tables; it means full table scan.
Cost: Lower cost = faster query.*/

-- View index usage stats for the 'orders' table
SELECT * FROM pg_stat_user_indexes WHERE relname = 'orders';

explain  select * from orders where order_id=1

select * from orders where customer_id =1  order by order_timestamp desc
create index idx_cust on orders(customer_id, order_timestamp)

/*
*/
select * from orders where customer_id =1  order by order_timestamp desc limit 2

-- Query orders of customer 1 sorted by order time descending (uses idx_cust_order index)
SELECT * FROM orders WHERE customer_id = 1 ORDER BY order_timestamp DESC;

-- Create the index that will speed up above query
CREATE INDEX idx_cust ON orders(customer_id, order_timestamp);

-- Limit results to top 2 recent orders of customer 1
SELECT * FROM orders WHERE customer_id = 1 ORDER BY order_timestamp DESC LIMIT 2;

/*📝 Notes and Tips on Indexes and Performance:
| Tip # | Description                                                                                                  |
| ----- | ------------------------------------------------------------------------------------------------------------ |
| ⚠️    | **Too many indexes** can slow down write operations (INSERT/UPDATE/DELETE) because indexes also get updated. |
| 🏆    | Indexes are most useful on **columns used in WHERE, JOIN, ORDER BY, or GROUP BY** clauses.                   |
| 🔍    | Use **EXPLAIN** to understand if your queries use indexes effectively.                                       |
| 🏗️   | Creating **composite indexes** for multi-column searches can dramatically improve speed.                     |
| 🔄    | Regularly check and maintain your indexes; unused indexes waste space.                                       |
| 🧹    | Drop unnecessary or unused indexes to optimize performance and storage.                                      |
| 🕵️   | Unique indexes also enforce **data integrity** by preventing duplicates.                                     |

🚀 Performance Best Practices

Index primary key columns (often done automatically).

Create indexes on foreign key columns to speed up joins.

Use partial indexes (index only rows that match a condition) for selective indexing.

Use covering indexes (include columns in index to avoid fetching from table).

Regularly analyze and vacuum your database to keep stats updated.

🔥 Bonus: Partial Index Example:
-- Create an index only on orders where total_amount > 100 (saves space)
CREATE INDEX idx_orders_high_amount ON orders(total_amount) WHERE total_amount > 100;


Summary

Indexes = speed up data retrieval.
Use indexes on columns in WHERE, JOIN, ORDER BY clauses.
Use EXPLAIN / EXPLAIN ANALYZE to check if queries use indexes.
Composite indexes help with multi-column queries.
Be mindful of write operation overhead and storage space.
*/
