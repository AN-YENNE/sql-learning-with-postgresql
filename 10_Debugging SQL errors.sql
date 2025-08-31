/*
🛠️ SQL Debugging Topics Covered

✅ Common SQL Mistakes & Errors

✅ Understanding SQL Syntax Errors

✅ Logical Errors in SQL Queries

✅ Debugging NULL Values

✅ Tips, Best Practices & Debugging Workflow
*/

--✅ 1. Common SQL Mistakes and Errors: Here are frequent mistakes beginners (and even experienced devs!) make in SQL:
-- 🔸 Missing Commas in SELECT or INSERT
-- ❌ Missing comma after column
SELECT name price FROM products;
-- Error: syntax error near "price"

-- ✅ Fix:
SELECT name, price FROM products;

--🔸 Wrong or Missing Quotes Around Strings
-- ❌ Unquoted string literal
SELECT * FROM customers WHERE city = New York;

-- ✅ Fix (use single quotes for strings)
SELECT * FROM customers WHERE city = 'New York';

--🔸 Using Wrong Case or Column Names
-- ❌ Column name typo or wrong case
SELECT CustomerName FROM customer;

-- ✅ Fix: correct column name is `customer_name`
SELECT customer_name FROM customers;

--🔸 Forgetting WHERE Clause in UPDATE or DELETE
-- ❌ Dangerous: updates all rows!
UPDATE products SET price = 0;

-- ✅ Fix: update specific row
UPDATE products SET price = 0 WHERE product_id = 5;

--🔸 Using = Instead of IN for Multiple Values
-- ❌ Invalid for multiple values
SELECT * FROM products WHERE category_id = (1, 2, 3);

-- ✅ Fix:
SELECT * FROM products WHERE category_id IN (1, 2, 3);

--✅ 2. Understanding SQL Syntax Errors
-- SQL syntax errors are often self-explanatory. Here’s how to troubleshoot them:
SELECT * FROM products WHERE price > ;
-- ERROR: syntax error at end of input

--🧠 Fix Strategy: Look for missing values, commas, or semicolons. Always read the line number and message provided in the error.
SELECT * FROM products WHERE price > 100; -- corrected version

SELECT FROM customer; -- ERROR: syntax error at or near "FROM"
SELECT * FROM customer; --correct

--✅ 3. Logical Errors in SQL (Query Returns Wrong Data): These don’t throw errors — but your results are wrong!
--🔸 Wrong Join Condition	
-- ❌ Cross join (no ON condition)
SELECT * FROM customer c JOIN orders o;
-- ✅ Fix:
SELECT * FROM customer c JOIN orders o ON c.customer_id = o.customer_id;

--🔸 Incorrect AND/OR Usage
-- ❌ This returns too many rows
SELECT * FROM products WHERE price > 100 OR category_id = 2;
-- ✅ Fix: use parentheses to control logic
SELECT * FROM products WHERE price > 100 AND category_id = 2;

--🔸 GROUP BY Missing Important Columns
-- ❌ Using aggregate without grouping all non-aggregates
SELECT city, email, COUNT(*) FROM customer GROUP BY city;
-- ERROR: column "email" must appear in the GROUP BY clause or be used in an aggregate function

-- ✅ Fix:
SELECT city, email, COUNT(*) FROM customer GROUP BY city, email;

-- ✅ 4. Debugging NULL Values: NULLs can silently break your logic. Here’s how to handle them.
--🔸 Problem: NULLs in Comparisons
SELECT * FROM products WHERE price > 100; -- This ignores products where price IS NULL
-- 🧠 Tip: NULL is not equal to anything, not even another NULL.

SELECT * FROM products WHERE price IS NULL;
SELECT * FROM products WHERE price IS NOT NULL;

--🔸 Use COALESCE() to Handle NULLs
-- Show 'Unknown Supplier' if Supplier is NULL
SELECT name, COALESCE(supplier, 'Unknown Supplier') AS supplier_name
FROM products;

--🔸 Sorting NULLs
SELECT * FROM products ORDER BY price ASC; -- NULLs appear first by default in ASC order

-- ✅ Put NULLs at the end:
SELECT * FROM products ORDER BY price ASC NULLS LAST;

/*🧰 Debugging Tips & Best Practices
| ✅ Practice                           | 💡 Explanation                                        |
| ------------------------------------ | ----------------------------------------------------- |
| Use `LIMIT`                          | Test with a few rows first                            |
| Add `WHERE 1=1`                      | Then layer additional filters one by one              |
| Use `EXPLAIN`                        | To understand query performance and plan              |
| Use aliases                          | To keep queries readable (`c`, `o`, `p` for joins)    |
| Use formatting                       | Keep clauses on new lines (SELECT, FROM, WHERE)       |
| Always test `NULL` logic             | Especially in joins and filters                       |
| Use `pgAdmin`, DBeaver, or SQL tools | They highlight errors and offer intellisense          |
| Test incrementally                   | Start with simple SELECTs before JOINs and aggregates |

🔁 Bonus: Common Mistakes Recap Cheat Sheet
| Mistake                     | Fix                                |
| --------------------------- | ---------------------------------- |
| Missing comma               | `SELECT col1, col2`                |
| No WHERE in UPDATE/DELETE   | Always use `WHERE`                 |
| Wrong string quotes         | Use single quotes `'string'`       |
| NULL comparison             | Use `IS NULL`, not `= NULL`        |
| Incorrect logic with AND/OR | Use parentheses                    |
| Unexpected empty results    | Check for NULLs or JOIN conditions |

✅ Summary
Syntax errors: Easy to fix with attention to detail.
Logical errors: Harder, as SQL runs but returns wrong results.
NULLs: Always need explicit handling.
Use debugging functions like COALESCE, EXPLAIN, and LIMIT.
Start small and build complex queries incrementally.
*/