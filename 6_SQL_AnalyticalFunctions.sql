/*SQL analytical functions—also called window functions—which are super powerful for analyzing trends, rankings, and running totals without aggregating entire groups like GROUP BY does.

🔍 1. What Are Analytical (Window) Functions?

Window functions perform calculations across a set of rows related to the current row, without collapsing the data like a GROUP BY clause.

They are written using the OVER() clause and often use:

PARTITION BY → Splits data into groups (like GROUP BY)

ORDER BY → Defines row order within each partition

Optionally: ROWS BETWEEN → For moving/running totals

✅ 2. Syntax Pattern (Very Important)
<function_name>() OVER (
    PARTITION BY <column_to_group_rows>
    ORDER BY <column_to_define_order>
    [ROWS BETWEEN x PRECEDING AND y FOLLOWING] -- Optional for window frame
)

*/
--🥇 3. RANK(): Ranking Rows With Gaps
SELECT customer_id,
  RANK() OVER (PARTITION BY customer_id ORDER BY total_amount DESC) AS order_rank,
  total_amount
FROM orders;
/*📘 Explanation:
Groups (PARTITION BY) orders by customer
Ranks orders by amount, highest first
If two orders tie, they get the same rank, and the next rank is skipped

📌 Example:
If a customer has 3 orders with amounts: 200, 150, 150
Ranks would be: 1, 2, 2 → next rank would be 4 (rank 3 skipped)*/

--🏅 4. DENSE_RANK(): Ranking Rows Without Gaps
SELECT customer_id,
  DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY total_amount DESC) AS order_rank,
  total_amount
FROM orders;
/*📘 Explanation:
Works like RANK() but doesn't skip ranks
Ties share a rank, but the next rank is just next number

📌 Example:
With amounts 200, 150, 150
Ranks: 1, 2, 2 → next rank is 3 (no skipping)
*/

--🔢 5. ROW_NUMBER(): Unique Sequence Number
SELECT order_id, customer_id, order_timestamp,
  ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY order_timestamp ASC) AS order_seq_num
FROM orders;


--⏪ 6. LAG(): Look at Previous Row's Value
SELECT customer_id, order_id, order_timestamp,
  LAG(order_timestamp, 1) OVER (PARTITION BY customer_id ORDER BY order_timestamp) AS prev_order
FROM orders;
/*📘 Explanation:
Returns the timestamp of the previous order
If no previous row, returns NULL*/

--⏩ 7. LEAD(): Look at Next Row’s Value
SELECT customer_id, order_id, order_timestamp,
  LEAD(order_timestamp, 1) OVER (PARTITION BY customer_id ORDER BY order_timestamp) AS next_order
FROM orders;
/*📘 Explanation:
Returns timestamp of the next order
Useful for calculating time between current and next order*/

--💰 8. SUM() OVER(): Running Total
SELECT customer_id, order_id, total_amount, order_timestamp,
  SUM(total_amount) OVER(PARTITION BY customer_id ORDER BY order_timestamp) AS running_total
FROM orders;
/*📘 Explanation:
Calculates a running total for each customer's orders in order
Each row shows cumulative amount up to that order*/

--📦 9. Another Example: Running Quantity by Product: Tracks how many units of a product have been sold over time
SELECT product_id, order_timestamp, total_quantity,
  SUM(total_quantity) OVER(PARTITION BY product_id ORDER BY order_timestamp) AS running_qty
FROM orders;


--📉 10. Moving Average: ROWS BETWEEN
SELECT order_id, customer_id, order_timestamp, total_amount,
  AVG(total_amount) OVER (
    PARTITION BY customer_id ORDER BY order_timestamp
    ROWS BETWEEN 1 PRECEDING AND CURRENT ROW
  ) AS mvg_avg
FROM orders;
/*📘 Explanation:
Calculates a moving average of total_amount
Includes: Current row and Previous row only (1 PRECEDING)
Smooths trends, helpful for analytics*/

--11: 🧠 Show the first order placed by each customer
SELECT * FROM (
  SELECT *, 
         ROW_NUMBER() OVER(PARTITION BY customer_id ORDER BY order_timestamp) AS row_num
  FROM orders
) t
WHERE row_num = 1;

--12 calculate time between orders
SELECT customer_id, order_id, order_timestamp,
       LAG(order_timestamp) OVER (PARTITION BY customer_id ORDER BY order_timestamp) AS prev_order,
       order_timestamp - LAG(order_timestamp) OVER (PARTITION BY customer_id ORDER BY order_timestamp) AS time_between
FROM orders;

--13: 📈 Cumulative sum of quantity for each product
SELECT product_id, order_timestamp, total_quantity,
  SUM(total_quantity) OVER(PARTITION BY product_id ORDER BY order_timestamp ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS cumulative_qty
FROM orders;


/*📝 Tips & Notes for Analytical Functions
| Concept                    | Notes                                                           |
| -------------------------- | --------------------------------------------------------------- |
| `PARTITION BY`             | Like `GROUP BY`, it groups rows for function evaluation         |
| `ORDER BY`                 | Defines row order **within** each partition                     |
| `ROWS BETWEEN`             | Controls the size of the window frame (for moving average etc.) |
| `LAG()` / `LEAD()`         | Useful for time-based comparisons                               |
| `ROW_NUMBER()`             | Always unique per partition; great for "first order", "top N"   |
| `RANK()` vs `DENSE_RANK()` | RANK leaves gaps on ties; DENSE\_RANK does not                  |
| `OVER()` with no partition | Applies function over all rows                                  |
*/