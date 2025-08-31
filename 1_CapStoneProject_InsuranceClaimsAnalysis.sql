-- Task 1: Database Schema Creation
-- Define tables: Customers, Policies, Claims, PolicyTypes.
-- Include fields such as CustomerID, PolicyID, ClaimID, PolicyTypeID, ClaimAmount, ClaimDate, PolicyStartDate, PolicyEndDate, etc.

-- 1. Customers table stores all client information
CREATE TABLE Customers (
    CustomerID SERIAL PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DateOfBirth DATE,
    Gender CHAR(1), -- M or F
    Address VARCHAR(100),
    City VARCHAR(50),
    State VARCHAR(50),
    ZipCode VARCHAR(10)
);

-- 2. PolicyTypes table defines types of policies
CREATE TABLE PolicyTypes (
    PolicyTypeID SERIAL PRIMARY KEY,
    PolicyTypeName VARCHAR(50),
    Description TEXT
);

-- 3. Policies table stores which customer owns which policy and details
CREATE TABLE Policies (
    PolicyID SERIAL PRIMARY KEY,
    CustomerID INT REFERENCES Customers(CustomerID),
    PolicyTypeID INT REFERENCES PolicyTypes(PolicyTypeID),
    PolicyStartDate DATE,
    PolicyEndDate DATE,
    Premium DECIMAL(10,2) -- Cost of policy
);

-- 4. Claims table stores insurance claims against policies
CREATE TABLE Claims (
    ClaimID SERIAL PRIMARY KEY,
    PolicyID INT REFERENCES Policies(PolicyID),
    ClaimDate DATE,
    ClaimAmount DECIMAL(10,2),
    ClaimDescription TEXT,
    ClaimStatus VARCHAR(50) -- Approved, Denied, Pending etc.
);



-- Task 2: Data Population
-- Insert realistic sample data into each table, ensuring a variety of scenarios are represented, 
-- such as different policy types, claim amounts, and customer profiles.

INSERT INTO PolicyTypes (PolicyTypeName, Description) VALUES
('Auto', 'Covers vehicles including accidents and theft'),
('Home', 'Covers residential property damages'),
('Life', 'Provides payout on death of policyholder'),
('Health', 'Covers medical expenses'),
('Travel', 'Covers losses while traveling'),
('Pet', 'Covers veterinary bills');

INSERT INTO Customers (FirstName, LastName, DateOfBirth, Gender, Address, City, State, ZipCode) VALUES
('John', 'Doe', '1980-04-12', 'M', '123 Elm St', 'Springfield', 'IL', '62704'),
('Jane', 'Smith', '1975-09-23', 'F', '456 Maple Ave', 'Greenville', 'TX', '75402'),
('Emily', 'Johnson', '1990-01-17', 'F', '789 Oak Dr', 'Phoenix', 'AZ', '85001'),
('Michael', 'Brown', '1985-07-30', 'M', '321 Pine St', 'Riverside', 'CA', '92501'),
('Sarah', 'Williams', '1995-11-22', 'F', '654 Walnut Ave', 'Austin', 'TX', '73301'),
('David', 'Miller', '1970-03-10', 'M', '111 Cedar Rd', 'Columbus', 'OH', '43004');


INSERT INTO Policies (CustomerID, PolicyTypeID, PolicyStartDate, PolicyEndDate, Premium) VALUES
(1, 1, '2021-01-01', '2022-01-01', 120.00),
(2, 2, '2021-02-01', '2022-02-01', 150.00),
(1, 3, '2021-03-01', '2024-03-01', 300.00),
(3, 4, '2021-04-01', '2022-04-01', 200.00),
(4, 1, '2021-05-01', '2022-05-01', 100.00),
(5, 5, '2021-06-01', '2021-12-01', 80.00),
(6, 6, '2021-07-01', '2022-07-01', 75.00),
(2, 4, '2022-01-01', '2023-01-01', 220.00),
(3, 3, '2021-01-01', '2026-01-01', 320.00),
(5, 2, '2021-08-01', '2022-08-01', 180.00);

INSERT INTO Claims (PolicyID, ClaimDate, ClaimAmount, ClaimDescription, ClaimStatus) VALUES
(1, '2021-06-15', 500.00, 'Car accident', 'Approved'),
(2, '2021-07-20', 1000.00, 'House fire', 'Pending'),
(3, '2021-08-05', 20000.00, 'Life insurance claim', 'Approved'),
(4, '2021-09-10', 150.00, 'Doctor visit', 'Denied'),
(5, '2021-10-22', 300.00, 'Car theft', 'Approved'),
(6, '2021-11-15', 400.00, 'Lost luggage', 'Approved'),
(7, '2022-02-01', 250.00, 'Vet surgery', 'Denied'),
(8, '2022-03-10', 600.00, 'Hospital bill', 'Approved'),
(9, '2022-05-12', 18000.00, 'Life claim payout', 'Approved'),
(10, '2022-06-22', 700.00, 'House flood', 'Pending');


-- Task 3: Analytical Queries
-- 1.Write a query to calculate the total number of claims per policy type.
-- Use analytical functions to determine the monthly claim frequency and average claim amount.
-- Count how many claims were made per policy type
SELECT
    pt.PolicyTypeName,
    COUNT(c.ClaimID) AS TotalClaims
FROM
    Claims c
JOIN Policies p ON c.PolicyID = p.PolicyID
JOIN PolicyTypes pt ON p.PolicyTypeID = pt.PolicyTypeID
GROUP BY
    pt.PolicyTypeName
ORDER BY
    TotalClaims DESC;


--- Query 2: Monthly Claim Frequency and Average Claim Amount
-- Breakdown of claims per month and average claim size
SELECT
    DATE_TRUNC('month', ClaimDate) AS ClaimMonth,
    COUNT(*) AS ClaimFrequency,
    AVG(ClaimAmount) AS AverageClaimAmount
FROM
    Claims
GROUP BY
    ClaimMonth
ORDER BY
    ClaimMonth;

--3.3 Customers with Most Claims
-- Who are the top claimers?
SELECT
    c.CustomerID,
    c.FirstName || ' ' || c.LastName AS CustomerName,
    COUNT(cl.ClaimID) AS ClaimCount
FROM Customers c
JOIN Policies p ON c.CustomerID = p.CustomerID
JOIN Claims cl ON p.PolicyID = cl.PolicyID
GROUP BY c.CustomerID, c.FirstName, c.LastName
ORDER BY ClaimCount DESC;

--3.4 Average Premium per Policy Type
-- Insight into premium cost by type
SELECT
    pt.PolicyTypeName,
    ROUND(AVG(p.Premium), 2) AS AveragePremium
FROM Policies p
JOIN PolicyTypes pt ON p.PolicyTypeID = pt.PolicyTypeID
GROUP BY pt.PolicyTypeName
ORDER BY AveragePremium DESC;





-- Task 4: 4. Optimization with 
	-- Discuss the creation of indexes on any columns used frequently in WHERE clauses or as join keys to improve performance.
-- Create indexes for better filtering and joins
CREATE INDEX idx_claims_claimdate ON Claims(ClaimDate);
CREATE INDEX idx_policies_customer ON Policies(CustomerID);
CREATE INDEX idx_policies_type ON Policies(PolicyTypeID);
--💡 Tips: Use indexes on columns used in WHERE, JOINs, and ORDER BY. Avoid over-indexing (use EXPLAIN ANALYZE to test).



--Task 5: Security - Roles and Permissions
	-- Create roles: ClaimsAnalyst and ClaimsManager.
	-- ‘ClaimsAnalyst’ role should have read-only access to claims and policies data.
	-- ‘ClaimsManager’ role should have full access to claims data and the ability to update policy information.
	
-- Create roles
CREATE ROLE ClaimsAnalyst LOGIN PASSWORD 'password1';
CREATE ROLE ClaimsManager LOGIN PASSWORD 'password2';

-- ClaimsAnalyst gets read-only access
GRANT SELECT ON Claims, Policies, PolicyTypes TO ClaimsAnalyst;

-- ClaimsManager gets full access
GRANT SELECT, INSERT, UPDATE, DELETE ON Claims, Policies, PolicyTypes TO ClaimsManager;

--Task 6: Advanced SQL Analytics
--6.1 Rank Claims by Amount (All Time)
SELECT
    ClaimID,
    ClaimAmount,
    RANK() OVER (ORDER BY ClaimAmount DESC) AS ClaimRank
FROM Claims;

--6.2 Running Total of Claims for Each Policy
SELECT
    PolicyID,
    ClaimDate,
    ClaimAmount,
    SUM(ClaimAmount) OVER (PARTITION BY PolicyID ORDER BY ClaimDate) AS RunningTotal
FROM Claims;

--6.3 Monthly Claim Trends for Line Chart
SELECT
    DATE_TRUNC('month', ClaimDate) AS Month,
    COUNT(*) AS ClaimCount
FROM Claims
GROUP BY Month
ORDER BY Month;

/*
*/

