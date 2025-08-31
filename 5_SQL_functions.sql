--5.2: ✅ Mathematical Functions
-- These functions work with numeric values to help with calculations, rounding, and precision.
-- Returns the absolute (positive) value
SELECT abs(-2.6);  -- Output: 2.6

-- Rounds up to the nearest whole number
SELECT ceil(2.7);  -- Output: 3

-- Rounds down to the nearest whole number
SELECT floor(2.7);  -- Output: 2

-- Rounds a number to 2 decimal places
SELECT round(2.3456, 2);  -- Output: 2.35

-- Returns square root of 4.0, rounded to 0 decimal places
SELECT round(sqrt(4.0), 0);  -- Output: 2

SELECT round(15.67891, 3);    -- Output: 15.679
SELECT power(2, 3);           -- Output: 8 (2^3)
SELECT mod(10, 3);            -- Output: 1 (remainder)

--5.3📆 Date and Time Functions
-- Work with the system's current date/time and manipulate date/time values.
-- Returns today's date
SELECT current_date;

-- Extracts specific parts from the current date
SELECT extract(DAY FROM current_date);     -- Day part (1–31)
SELECT extract(MONTH FROM current_date);   -- Month part (1–12)
SELECT extract(YEAR FROM current_date);    -- Year part

-- Alternate way using date_part()
SELECT date_part('day', current_date);
SELECT date_part('month', current_date);
SELECT date_part('year', current_date);

-- Truncates date to beginning of the month (e.g., 2025-08-01)
SELECT date_trunc('month', current_date);

-- Truncates to start of the year (e.g., 2025-01-01)
SELECT date_trunc('year', current_date);

-- Returns the interval (difference) between today and a given date
SELECT age(timestamp '2024-01-01');

-- Difference between two dates (end - start)
SELECT age(timestamp '2024-01-01', timestamp '2024-01-31');

-- Converts a string to a date
SELECT to_date('01/01/2024', 'DD/MM/YYYY');

-- Formats current date as string
SELECT to_char(current_date, 'DD-MM-YYYY'); -- Output: '31-08-2025' (or today)
/*
📅 More Tips:
1.age() returns the result as an interval (years, months, days).
2.Use to_char() to format date output in readable formats.
3.Use to_date() to convert string to date format.*/

--5.4: ⏰ Time Functions: Retrieve and manipulate time and timestamp values.
SELECT current_time;         -- Current time only
SELECT current_timestamp;    -- Current date and time
SELECT localtime;            -- Same as current_time
SELECT localtimestamp;       -- Same as current_timestamp

--Extracting Time Parts from Order Timestamps:
SELECT extract(hour FROM order_timestamp) FROM orders;
SELECT extract(minute FROM order_timestamp) FROM orders;
SELECT extract(second FROM order_timestamp) FROM orders;

--Working with Time Differences
-- Truncates time to beginning of the day
SELECT date_trunc('day', order_timestamp) FROM orders;

-- Age since the order was placed
SELECT age(order_timestamp) FROM orders;

-- How long it took to deliver the order
SELECT age(delivery_timestamp, order_timestamp) FROM orders;

-- Show current time in New York timezone
SELECT current_timestamp AT TIME ZONE 'America/New_York';


--🔤 String Functions: Concatenation and Trimming
-- Concatenation (joining strings)
-- Concatenate city and address with '----' in between
SELECT city || '----' || address FROM customers;

-- Using CONCAT function (ignores NULLs)
SELECT concat(city, address) FROM customers;

-- CONCAT_WS adds separator (e.g., '--') and handles NULLs
SELECT concat_ws('--', city, address) FROM customers;

--Trimming (removing unwanted characters)
-- Removes spaces from both ends
SELECT trim('    helllo     ');  -- Output: 'helllo'

-- Removes specific character (X) from both ends
SELECT trim('X' FROM 'XXXHelloXXX');  -- Output: 'Hello'

-- Removes spaces from left side
SELECT ltrim('   hello   ');  -- Output: 'hello   '

-- Removes spaces from right side
SELECT rtrim('   hello   ');  -- Output: '    hello'

-- Removes spaces from both ends (like trim)
SELECT btrim('   hello   ');  -- Output: 'hello'


-- 🔠 String Functions: Case Change and Substrings
--Changing Case:
SELECT upper(customer_name) FROM customers;   -- ALL CAPS
SELECT lower(customer_name) FROM customers;   -- all lowercase
SELECT initcap(customer_name) FROM customers; -- Capitalizes each word

--Substring and Position:
-- Get part of string: 'Hello'
SELECT substring('Hello from Recher' FROM 1 FOR 5);

-- Get word 'from'
SELECT substring('Hello from Recher' FROM 7 FOR 5);

-- First 5 letters
SELECT left('Hello from Recher', 5);  -- Output: Hello

-- Last 6 letters
SELECT right('Hello from Recher', 6); -- Output: Recher

-- Find position of a word (returns index or 0 if not found)
SELECT position('Alice' IN 'Hello from Recher');  -- Output: 0 (not found)

-- Get length of string
SELECT length('Hello from Recher');  -- Output: 17

/*
| Function Type                        | Useful For                                 |
| ------------------------------------ | ------------------------------------------ |
| `abs()`, `round()`, `sqrt()`         | Numeric calculations                       |
| `current_date`, `extract()`, `age()` | Working with dates                         |
| `concat()`, `trim()`, `substring()`  | String cleaning and formatting             |
| `to_date()`, `to_char()`             | Converting and formatting dates            |
| `position()`                         | Finding if a string/word exists in another |
*/

--Additional: 📌 Common Math Functions with Examples:
SELECT abs(-10);              -- Output: 10 (Absolute value)

SELECT ceil(3.2);             -- Output: 4 (Next highest integer)

SELECT floor(3.8);            -- Output: 3 (Next lowest integer)

SELECT round(3.4567, 2);      -- Output: 3.46 (Round to 2 decimal places)

SELECT sqrt(16);              -- Output: 4 (Square root)

SELECT power(2, 4);           -- Output: 16 (2 raised to the power 4)

SELECT mod(11, 4);            -- Output: 3 (Remainder of 11 ÷ 4)

SELECT pi();                  -- Output: 3.1415926535

SELECT random();              -- Output: random number between 0 and 1

SELECT sign(-25);            -- Output: -1 (returns sign of number: -1, 0, 1)


SELECT date_part('dow', current_date);     -- Day of week (0=Sunday)

SELECT date_trunc('month', current_date);   -- Start of the month
SELECT date_trunc('year', current_date);    -- Start of the year
SELECT date_trunc('day', current_timestamp);-- Start of the day

-- Convert string to date
SELECT to_date('31/08/2025', 'DD/MM/YYYY');

-- Format date to string
SELECT to_char(current_date, 'YYYY-MM-DD');      -- Output: '2025-08-31'
SELECT to_char(current_timestamp, 'HH24:MI:SS'); -- Output: '14:50:30'


SELECT current_date - DATE '2025-01-01' AS days_passed; -- Output: number of days


SELECT COUNT(*) FROM customer;                       -- Total rows
SELECT COUNT(DISTINCT city) FROM customer;           -- Unique cities
SELECT SUM(total_amount) FROM orders;                -- Total sales
SELECT AVG(total_amount) FROM orders;                -- Average sale
SELECT MAX(price) FROM products;                     -- Highest price
SELECT MIN(price) FROM products;                     -- Lowest price
SELECT STDDEV(total_amount) FROM orders;             -- Standard deviation

/* 🧠 Tips for Working with Functions:
| Tip # | Description                                                           |   |                                    |
| ----- | --------------------------------------------------------------------- | - | ---------------------------------- |
| 1️⃣   | Use `AS alias_name` to name output columns clearly                    |   |                                    |
| 2️⃣   | Always check if your fields have `NULL` values before using functions |   |                                    |
| 3️⃣   | Use `ROUND()` when working with financial data to control decimals    |   |                                    |
| 4️⃣   | Use \`                                                                |   | `or`concat()\` for joining strings |
| 5️⃣   | `date_part()` and `extract()` are interchangeable for date pieces     |   |                                    |
| 6️⃣   | Use `to_char()` to format timestamps for reporting or UI              |   |                                    |

*/

-- Show customer name, city, and how many days ago their last order was placed
SELECT 
  c.customer_name,
  c.city,
  age(current_date, MAX(o.order_timestamp)) AS days_since_last_order
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id;

