CREATE DATABASE IF NOT EXISTS uber_database
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE uber_database;

DROP TABLE IF EXISTS trip_details;
DROP TABLE IF EXISTS trips;
DROP TABLE IF EXISTS assembly;
DROP TABLE IF EXISTS duration;
DROP TABLE IF EXISTS payment;

CREATE TABLE assembly (
    ID INT PRIMARY KEY,
    Assembly VARCHAR(255) NOT NULL
);

CREATE TABLE duration (
    id INT PRIMARY KEY,
    duration VARCHAR(50) NOT NULL
);

CREATE TABLE payment (
    id INT PRIMARY KEY,
    method VARCHAR(50) NOT NULL
);

CREATE TABLE trip_details (
    tripid INT PRIMARY KEY,
    loc_from INT,
    searches INT,
    searches_got_estimate INT,
    searches_for_quotes INT,
    searches_got_quotes INT,
    customer_not_cancelled INT,
    driver_not_cancelled INT,
    otp_entered INT,
    end_ride INT
);

CREATE TABLE trips (
    tripid INT PRIMARY KEY,
    faremethod INT,
    fare INT,
    loc_from INT,
    loc_to INT,
    driverid INT,
    custid INT,
    distance INT,
    duration INT
);

LOAD DATA LOCAL INFILE 'C:/Users/arije/Downloads/PowerBI-20260626T224600Z-3-001/PowerBI/Uber-Data-Analysis-SQL-AND-POWER-BI-main/assembly.csv'
INTO TABLE assembly
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(ID, Assembly);

LOAD DATA LOCAL INFILE 'C:/Users/arije/Downloads/PowerBI-20260626T224600Z-3-001/PowerBI/Uber-Data-Analysis-SQL-AND-POWER-BI-main/duration.csv'
INTO TABLE duration
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, duration);

LOAD DATA LOCAL INFILE 'C:/Users/arije/Downloads/PowerBI-20260626T224600Z-3-001/PowerBI/Uber-Data-Analysis-SQL-AND-POWER-BI-main/payment.csv'
INTO TABLE payment
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(id, method);

LOAD DATA LOCAL INFILE 'C:/Users/arije/Downloads/PowerBI-20260626T224600Z-3-001/PowerBI/Uber-Data-Analysis-SQL-AND-POWER-BI-main/trip_details.csv'
INTO TABLE trip_details
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(tripid, loc_from, searches, searches_got_estimate, searches_for_quotes, searches_got_quotes, customer_not_cancelled, driver_not_cancelled, otp_entered, end_ride);

LOAD DATA LOCAL INFILE 'C:/Users/arije/Downloads/PowerBI-20260626T224600Z-3-001/PowerBI/Uber-Data-Analysis-SQL-AND-POWER-BI-main/trips.csv'
INTO TABLE trips
CHARACTER SET utf8mb4
FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(tripid, faremethod, fare, loc_from, loc_to, driverid, custid, distance, duration);

SELECT 'assembly' AS table_name, COUNT(*) AS row_count FROM assembly
UNION ALL SELECT 'duration', COUNT(*) FROM duration
UNION ALL SELECT 'payment', COUNT(*) FROM payment
UNION ALL SELECT 'trip_details', COUNT(*) FROM trip_details
UNION ALL SELECT 'trips', COUNT(*) FROM trips;
