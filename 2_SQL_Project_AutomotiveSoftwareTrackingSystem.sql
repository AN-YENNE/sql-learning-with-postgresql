/*Automotive Embedded Software Tracking System (SQL Project):This project models:
ECU software versions, Vehicle configurations, Software deployments, System tests and test results
*/
--Task 1: Database Schema Creation:
-- Vehicle Table
CREATE TABLE Vehicles (
    VehicleID SERIAL PRIMARY KEY,
    VIN VARCHAR(20) UNIQUE NOT NULL,  -- Vehicle Identification Number
    Model VARCHAR(50),
    Variant VARCHAR(50),
    ManufacturingDate DATE
);

--ECUs table
CREATE TABLE ECUs (
    ECU_ID SERIAL PRIMARY KEY,
    ECU_Name VARCHAR(50),
    Supplier VARCHAR(100),
    HardwareVersion VARCHAR(20)
);

--SoftwareVersions Table
CREATE TABLE SoftwareVersions (
    SoftwareID SERIAL PRIMARY KEY,
    ECU_ID INT REFERENCES ECUs(ECU_ID),
    VersionCode VARCHAR(50), -- e.g. SW1.0.0
    ReleaseDate DATE,
    ChangeLog TEXT
);

--Deployments table
CREATE TABLE Deployments (
    DeploymentID SERIAL PRIMARY KEY,
    VehicleID INT REFERENCES Vehicles(VehicleID),
    SoftwareID INT REFERENCES SoftwareVersions(SoftwareID),
    DeploymentDate DATE,
    DeploymentStatus VARCHAR(20) -- e.g., Successful, Failed, InProgress
);

--SystemTests Table
CREATE TABLE SystemTests (
    TestID SERIAL PRIMARY KEY,
    TestName VARCHAR(100),
    TestDescription TEXT,
    ECU_ID INT REFERENCES ECUs(ECU_ID)
);

--TestResults Table
CREATE TABLE TestResults (
    ResultID SERIAL PRIMARY KEY,
    TestID INT REFERENCES SystemTests(TestID),
    SoftwareID INT REFERENCES SoftwareVersions(SoftwareID),
    TestDate DATE,
    ResultStatus VARCHAR(20), -- Passed, Failed, Warning
    Notes TEXT
);

--Task 2: Sample Data Population
--Insert Vehicle Data
INSERT INTO Vehicles (VIN, Model, Variant, ManufacturingDate) VALUES
('VIN001A123456', 'ModelX', 'Electric', '2023-01-15'),
('VIN002B654321', 'ModelY', 'Hybrid', '2023-03-22'),
('VIN003C789456', 'ModelZ', 'Diesel', '2022-12-01');

--Insert ECUs Data
INSERT INTO ECUs (ECU_Name, Supplier, HardwareVersion) VALUES
('Powertrain ECU', 'Bosch', 'HW1.2'),
('Infotainment ECU', 'Continental', 'HW2.1'),
('ADAS ECU', 'Nvidia', 'HW3.0');

--Insert software versions data
INSERT INTO SoftwareVersions (ECU_ID, VersionCode, ReleaseDate, ChangeLog) VALUES
(1, 'SW1.0.0', '2023-01-10', 'Initial release'),
(1, 'SW1.1.0', '2023-02-20', 'Improved fuel mapping'),
(2, 'SW2.0.0', '2023-01-15', 'New UI for infotainment'),
(3, 'SW3.0.0', '2023-03-01', 'Lane assist improvement');

--Insert Deployments
INSERT INTO Deployments (VehicleID, SoftwareID, DeploymentDate, DeploymentStatus) VALUES
(1, 1, '2023-01-20', 'Successful'),
(1, 3, '2023-01-25', 'Successful'),
(2, 2, '2023-03-01', 'Successful'),
(2, 4, '2023-03-05', 'Failed'),
(3, 1, '2023-02-01', 'InProgress');

--Insert System Tests
INSERT INTO SystemTests (TestName, TestDescription, ECU_ID) VALUES
('Cold Start Test', 'Tests ECU performance during cold engine start', 1),
('Touchscreen UI Test', 'UI responsiveness test', 2),
('Lane Assist Calibration', 'Checks ADAS alignment and accuracy', 3);

--Insert Test Results
INSERT INTO TestResults (TestID, SoftwareID, TestDate, ResultStatus, Notes) VALUES
(1, 1, '2023-01-18', 'Passed', 'Normal behavior observed'),
(2, 3, '2023-01-26', 'Failed', 'Lag detected in touchscreen'),
(3, 4, '2023-03-06', 'Passed', 'System calibrated successfully'),
(1, 2, '2023-03-02', 'Passed', 'Performance improved');

--Task 3: Analysis Queries
--3.1 Which vehicles have had failed deployments?
SELECT v.VIN, s.VersionCode, d.DeploymentStatus
FROM Deployments d
JOIN Vehicles v ON d.VehicleID = v.VehicleID
JOIN SoftwareVersions s ON d.SoftwareID = s.SoftwareID
WHERE d.DeploymentStatus = 'Failed';

--3.2 Count of Software Versions per ECU
SELECT e.ECU_Name, COUNT(s.SoftwareID) AS VersionCount
FROM SoftwareVersions s
JOIN ECUs e ON s.ECU_ID = e.ECU_ID
GROUP BY e.ECU_Name;

--3.3 Average Time Between Software Release and Deployment
SELECT 
    s.VersionCode,
    ROUND(AVG(d.DeploymentDate - s.ReleaseDate)) AS AvgDeploymentDelayDays
FROM Deployments d
JOIN SoftwareVersions s ON d.SoftwareID = s.SoftwareID
GROUP BY s.VersionCode;


--3.4 Test Pass Rate by ECU
SELECT
    e.ECU_Name,
    COUNT(*) FILTER (WHERE tr.ResultStatus = 'Passed') * 100.0 / COUNT(*) AS PassRate
FROM TestResults tr
JOIN SystemTests t ON tr.TestID = t.TestID
JOIN ECUs e ON t.ECU_ID = e.ECU_ID
GROUP BY e.ECU_Name;

--Task 4: Optimization
-- Add indexes on foreign keys and dates for performance
CREATE INDEX idx_deployments_vehicle ON Deployments(VehicleID);
CREATE INDEX idx_software_ecu ON SoftwareVersions(ECU_ID);
CREATE INDEX idx_testresults_software ON TestResults(SoftwareID);

--Task 5: Roles & Permissions (Security)
-- Create roles
CREATE ROLE EmbeddedTester LOGIN PASSWORD 'test@123';
CREATE ROLE DeploymentManager LOGIN PASSWORD 'deploy@123';

-- Permissions
GRANT SELECT ON ALL TABLES IN SCHEMA public TO EmbeddedTester;
GRANT SELECT, INSERT, UPDATE, DELETE ON Deployments TO DeploymentManager;

--Task 6: Analytical Functions
-- Running total of deployments per vehicle
SELECT
    VehicleID,
    DeploymentDate,
    COUNT(*) OVER (PARTITION BY VehicleID ORDER BY DeploymentDate) AS DeploymentSequence
FROM Deployments;

-- Rank software versions by deployment count
SELECT
    s.VersionCode,
    COUNT(d.DeploymentID) AS Deployments,
    RANK() OVER (ORDER BY COUNT(d.DeploymentID) DESC) AS PopularityRank
FROM Deployments d
JOIN SoftwareVersions s ON d.SoftwareID = s.SoftwareID
GROUP BY s.VersionCode;

