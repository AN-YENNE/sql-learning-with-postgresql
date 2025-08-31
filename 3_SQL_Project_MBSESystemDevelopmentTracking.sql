/*MBSE System Development Tracking SQL Project:
In this MBSE project, we are managing:

System models and their versions

Components used in systems

Requirements linked to models

Test cases for validating requirements

Validation results from test execution
*/

--Task 1: Database Schema Design
--System models table
CREATE TABLE SystemModels (
    ModelID SERIAL PRIMARY KEY,
    ModelName VARCHAR(100),
    Domain VARCHAR(50),  -- e.g., Powertrain, Safety, Infotainment
    Version VARCHAR(20),
    CreatedDate DATE
);

--Components table
CREATE TABLE Components (
    ComponentID SERIAL PRIMARY KEY,
    ComponentName VARCHAR(100),
    Type VARCHAR(50),  -- e.g., Sensor, Actuator, Software Module
    Vendor VARCHAR(100)
);

--ModelComponents Table (many-to-many)
CREATE TABLE ModelComponents (
    ModelID INT REFERENCES SystemModels(ModelID),
    ComponentID INT REFERENCES Components(ComponentID),
    PRIMARY KEY (ModelID, ComponentID)
);

--Requirements Table
CREATE TABLE Requirements (
    RequirementID SERIAL PRIMARY KEY,
    ModelID INT REFERENCES SystemModels(ModelID),
    Description TEXT,
    Priority VARCHAR(10),  -- High, Medium, Low
    RequirementType VARCHAR(50) -- Functional, Non-functional, Safety
);

--TestCases Table
CREATE TABLE TestCases (
    TestCaseID SERIAL PRIMARY KEY,
    RequirementID INT REFERENCES Requirements(RequirementID),
    TestName VARCHAR(100),
    Description TEXT,
    CreatedBy VARCHAR(50)
);

--ValidationResults Table
CREATE TABLE ValidationResults (
    ResultID SERIAL PRIMARY KEY,
    TestCaseID INT REFERENCES TestCases(TestCaseID),
    ExecutedOn DATE,
    Tester VARCHAR(50),
    ResultStatus VARCHAR(20),  -- Passed, Failed, Blocked
    Notes TEXT
);

--Task 2: Sample Data Population
--Add system models
INSERT INTO SystemModels (ModelName, Domain, Version, CreatedDate) VALUES
('Cruise Control System', 'Powertrain', 'v1.0', '2023-01-10'),
('Collision Avoidance', 'Safety', 'v2.1', '2023-03-15'),
('Infotainment UI', 'Infotainment', 'v1.2', '2023-02-01');

--Add components
INSERT INTO Components (ComponentName, Type, Vendor) VALUES
('Speed Sensor', 'Sensor', 'Bosch'),
('Brake Actuator', 'Actuator', 'Continental'),
('Touchscreen UI Module', 'Software Module', 'Harman'),
('Camera Sensor', 'Sensor', 'Valeo');

--Map Components to Models
INSERT INTO ModelComponents (ModelID, ComponentID) VALUES
(1, 1),  -- Cruise Control uses Speed Sensor
(1, 2),  -- Cruise Control uses Brake Actuator
(2, 4),  -- Collision Avoidance uses Camera Sensor
(3, 3);  -- Infotainment uses UI module

--Add Requirements
INSERT INTO Requirements (ModelID, Description, Priority, RequirementType) VALUES
(1, 'Maintain vehicle speed within +/-2 km/h', 'High', 'Functional'),
(1, 'System deactivates on brake', 'High', 'Safety'),
(2, 'Detect vehicle within 50m and trigger warning', 'High', 'Functional'),
(3, 'Display touchscreen UI within 3 seconds of boot', 'Medium', 'Performance');

--Add test cases
INSERT INTO TestCases (RequirementID, TestName, Description, CreatedBy) VALUES
(1, 'Speed Stability Test', 'Check speed deviation during cruise', 'Deepak'),
(2, 'Brake Cancel Test', 'Verify system disengages when brake is pressed', 'Anita'),
(3, 'Obstacle Detection Test', 'Ensure obstacle is detected at 50m', 'Ravi'),
(4, 'UI Boot Time Test', 'Measure UI response time after boot', 'Sara');

--Add validation results
INSERT INTO ValidationResults (TestCaseID, ExecutedOn, Tester, ResultStatus, Notes) VALUES
(1, '2023-04-01', 'Amit', 'Passed', 'Within allowed tolerance'),
(2, '2023-04-02', 'Anita', 'Passed', 'Brake press disables system'),
(3, '2023-04-05', 'Ravi', 'Failed', 'Late detection'),
(4, '2023-04-06', 'Sara', 'Passed', 'Boot time was 2.5s');

--Task 3: Analytical Queries
--3.1 Total Number of Components per Model
SELECT m.ModelName, COUNT(mc.ComponentID) AS ComponentCount
FROM SystemModels m
JOIN ModelComponents mc ON m.ModelID = mc.ModelID
GROUP BY m.ModelName;

--3.2Test Case Pass Rate by Model
SELECT
    m.ModelName,
    COUNT(*) FILTER (WHERE vr.ResultStatus = 'Passed') * 100.0 / COUNT(*) AS PassRate
FROM ValidationResults vr
JOIN TestCases tc ON vr.TestCaseID = tc.TestCaseID
JOIN Requirements r ON tc.RequirementID = r.RequirementID
JOIN SystemModels m ON r.ModelID = m.ModelID
GROUP BY m.ModelName;

--3.3 Count of Requirements by Type and Priority
SELECT RequirementType, Priority, COUNT(*) AS Count
FROM Requirements
GROUP BY RequirementType, Priority
ORDER BY RequirementType, Priority;

--3.4 Test Case Execution Log
SELECT
    tc.TestName,
    vr.ExecutedOn,
    vr.Tester,
    vr.ResultStatus
FROM ValidationResults vr
JOIN TestCases tc ON vr.TestCaseID = tc.TestCaseID
ORDER BY vr.ExecutedOn DESC;

--Task 4: Optimization & Indexes
-- Indexes for join performance
CREATE INDEX idx_req_model ON Requirements(ModelID);
CREATE INDEX idx_tc_req ON TestCases(RequirementID);
CREATE INDEX idx_vr_tc ON ValidationResults(TestCaseID);

--Task 5: Roles & Permissions
-- Roles
CREATE ROLE system_tester LOGIN PASSWORD 'test123';
CREATE ROLE model_architect LOGIN PASSWORD 'arch123';

-- Permissions
GRANT SELECT ON ALL TABLES IN SCHEMA public TO system_tester;
GRANT SELECT, INSERT, UPDATE, DELETE ON SystemModels, Requirements TO model_architect;


--Task 6 Advanced: Analytical Function Example
-- Running total of test cases executed per tester
SELECT
    Tester,
    ExecutedOn,
    COUNT(*) OVER (PARTITION BY Tester ORDER BY ExecutedOn) AS RunningTestCount
FROM ValidationResults;

