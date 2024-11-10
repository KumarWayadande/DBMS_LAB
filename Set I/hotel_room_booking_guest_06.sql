-- The following tables form part of a database held in a relational DBMS:
-- Hotel (HotelNo, Name, City)
-- Room (RoomNo, HotelNo, Type, Price)
-- Booking (HotelNo, GuestNo, DateFrom, DateTo, RoomNo)
-- Guest (GuestNo, GuestName, GuestAddress)
-- Solve following queries by SQL
-- 1. List full details of all hotels.
-- 2. List full details of all hotels in London.
-- 3. List all guests currently staying at the Grosvenor Hotel.
-- 4. List the names and addresses of all guests in London, alphabetically ordered by name.
-- 5. List the bookings for which no date_to has been specified.
-- 6. How many hotels are there?
-- 7. List the rooms that are currently unoccupied at the Grosvenor Hotel.
-- 8. What is the lost income from unoccupied rooms at each hotel today?
-- 9. Create index on one of the field and show is performance in query.
-- 10. Create one view on above database and query it.

create database HotelDB_06;
use HotelDB_06

-- Create Hotel Table
CREATE TABLE Hotel (
    HotelNo INT PRIMARY KEY,
    Name VARCHAR(100),
    City VARCHAR(50)
);

-- Create Room Table
CREATE TABLE Room (
    RoomNo INT,
    HotelNo INT,
    Type VARCHAR(50),
    Price DECIMAL(10, 2),
    PRIMARY KEY (RoomNo, HotelNo),
    FOREIGN KEY (HotelNo) REFERENCES Hotel(HotelNo)
);

-- Create Guest Table
CREATE TABLE Guest (
    GuestNo INT PRIMARY KEY,
    GuestName VARCHAR(100),
    GuestAddress VARCHAR(255)
);

-- Create Booking Table
CREATE TABLE Booking (
    HotelNo INT,
    GuestNo INT,
    DateFrom DATE,
    DateTo DATE,
    RoomNo INT,
    PRIMARY KEY (HotelNo, GuestNo, DateFrom),
    FOREIGN KEY (HotelNo) REFERENCES Hotel(HotelNo),
    FOREIGN KEY (GuestNo) REFERENCES Guest(GuestNo),
    FOREIGN KEY (RoomNo) REFERENCES Room(RoomNo)
);


-- Insert into Hotel Table
INSERT INTO Hotel (HotelNo, Name, City) VALUES
(1, 'Grosvenor Hotel', 'London'),
(2, 'Hilton', 'New York'),
(3, 'Sheraton', 'San Francisco'),
(4, 'Marriott', 'Los Angeles'),
(5, 'Holiday Inn', 'London');

-- Insert into Room Table
INSERT INTO Room (RoomNo, HotelNo, Type, Price) VALUES
(101, 1, 'Single', 80.00),
(102, 1, 'Double', 100.00),
(103, 1, 'Family', 150.00),
(201, 2, 'Double', 120.00),
(202, 2, 'Suite', 250.00),
(301, 3, 'Single', 90.00),
(302, 3, 'Double', 110.00),
(401, 4, 'Suite', 300.00),
(402, 4, 'Double', 200.00),
(501, 5, 'Double', 95.00),
(502, 5, 'Family', 160.00);

-- Insert into Guest Table
INSERT INTO Guest (GuestNo, GuestName, GuestAddress) VALUES
(1001, 'John Doe', '123 Main St, London'),
(1002, 'Alice Smith', '456 Oak St, New York'),
(1003, 'Bob Johnson', '789 Pine St, San Francisco'),
(1004, 'Eve Davis', '321 Maple Ave, Los Angeles'),
(1005, 'Charlie Brown', '654 Elm St, London');

-- Insert into Booking Table
INSERT INTO Booking (HotelNo, GuestNo, DateFrom, DateTo, RoomNo) VALUES
(1, 1001, '2024-11-01', '2024-11-05', 102),
(1, 1002, '2024-11-10', '2024-11-15', 103),
(2, 1003, '2024-11-05', '2024-11-10', 201),
(3, 1004, '2024-11-12', '2024-11-18', 301),
(5, 1005, '2024-11-15', '2024-11-20', 501),
(1, 1002, '2024-11-10', NULL, 103);  -- Ongoing booking with no date_to



-- 1. List full details of all hotels.
SELECT *  FROM Hotel;

-- 2. List full details of all hotels in London.
SELECT * FROM Hotel WHERE City = 'London';

-- 3. List all guests currently staying at the Grosvenor Hotel.
SELECT g.GuestName, g.GuestAddress 
FROM Guest g
JOIN Booking b ON g.GuestNo = b.GuestNo
JOIN Hotel h ON b.HotelNo = h.HotelNo
WHERE h.Name = 'Grosvenor Hotel' 
AND CURDATE() BETWEEN b.DateFrom AND IFNULL(b.DateTo, CURDATE());

-- 4. List the names and addresses of all guests in London, alphabetically ordered by name.
SELECT g.GuestName, g.GuestAddress 
FROM Guest g
JOIN Booking b ON g.GuestNo = b.GuestNo
JOIN Hotel h ON b.HotelNo = h.HotelNo
WHERE h.City = 'London'
ORDER BY g.GuestName ASC;


-- 5. List the bookings for which no date_to has been specified.
SELECT * 
FROM Booking 
WHERE DateTo IS NULL;


-- 6. How many hotels are there?
SELECT COUNT(*) AS TotalHotels 
FROM Hotel;


-- 7. List the rooms that are currently unoccupied at the Grosvenor Hotel.
SELECT r.RoomNo, r.Type, r.Price
FROM Room r
JOIN Hotel h ON r.HotelNo = h.HotelNo
LEFT JOIN Booking b ON r.RoomNo = b.RoomNo AND r.HotelNo = b.HotelNo 
    AND CURDATE() BETWEEN b.DateFrom AND IFNULL(b.DateTo, CURDATE())
WHERE h.Name = 'Grosvenor Hotel' 
AND b.RoomNo IS NULL;  -- Rooms with no booking for today


-- 8. What is the lost income from unoccupied rooms at each hotel today?
SELECT h.Name, SUM(r.Price) AS LostIncome
FROM Room r
JOIN Hotel h ON r.HotelNo = h.HotelNo
LEFT JOIN Booking b ON r.RoomNo = b.RoomNo AND r.HotelNo = b.HotelNo 
    AND CURDATE() BETWEEN b.DateFrom AND IFNULL(b.DateTo, CURDATE())
WHERE b.RoomNo IS NULL  -- Unoccupied rooms
GROUP BY h.Name;


-- 9. Create index on one of the field and show is performance in query.
CREATE INDEX idx_booking_hotelno ON Booking (HotelNo);
-- Query to check performance:
EXPLAIN SELECT * FROM Booking WHERE HotelNo = 1;

-- 10. Create one view on above database and query it.
-- Create the view
CREATE VIEW GuestBookings AS
SELECT g.GuestName, h.Name AS HotelName, r.RoomNo, r.Type, b.DateFrom, b.DateTo
FROM Guest g
JOIN Booking b ON g.GuestNo = b.GuestNo
JOIN Hotel h ON b.HotelNo = h.HotelNo
JOIN Room r ON b.RoomNo = r.RoomNo;
-- Query the view
SELECT * FROM GuestBookings;
