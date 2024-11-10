-- The following tables form part of a database held in a relational DBMS:
-- Hotel (HotelNo, Name, City) HotelNo is primary key
-- Room (RoomNo, HotelNo, Type, Price)
-- Booking (HotelNo, GuestNo, DateFrom, DateTo, RoomNo)
-- Guest (GuestNo, GuestName, GuestAddress) GuestNo is primary key
-- Solve following queries by SQL
-- 1. What is the total revenue per night from all double rooms?
-- 2. List the details of all rooms at the Grosvenor Hotel, including the name of
-- the guest staying in the room, if the room is occupied.
-- 3. What is the average number of bookings for each hotel in April?
-- 4. Create index on one of the field and show is performance in query.
-- 5. List full details of all hotels.
-- 6. List full details of all hotels in London.
-- 7. Update the price of all rooms by 5%.
-- 8. List the number of rooms in each hotel in London.
-- 9. List all double or family rooms with a price below £40.00 per night, in
-- ascending order of price.

create database HotelDB_04;
use HotelDB_04;

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
(1005, 'Charlie Brown', '654 Elm St, Chicago');

-- Insert into Booking Table
INSERT INTO Booking (HotelNo, GuestNo, DateFrom, DateTo, RoomNo) VALUES
(1, 1001, '2024-04-01', '2024-04-05', 102),
(1, 1002, '2024-04-10', '2024-04-15', 103),
(2, 1003, '2024-04-05', '2024-04-10', 201),
(3, 1004, '2024-04-12', '2024-04-18', 301),
(5, 1005, '2024-04-15', '2024-04-20', 501);

-- 1. What is the total revenue per night from all double rooms?
SELECT SUM(Price) AS TotalRevenue FROM Room WHERE Type = 'Double';

-- 2. List the details of all rooms at the Grosvenor Hotel, including the name of
-- the guest staying in the room, if the room is occupied.
SELECT r.RoomNo, r.Type, r.Price, g.GuestName, g.GuestAddress
FROM Room r
JOIN Hotel h ON r.HotelNo = h.HotelNo
LEFT JOIN Booking b ON r.RoomNo = b.RoomNo AND r.HotelNo = b.HotelNo
LEFT JOIN Guest g ON b.GuestNo = g.GuestNo
WHERE h.Name = 'Grosvenor Hotel';


-- 3. What is the average number of bookings for each hotel in April?
SELECT b.HotelNo, COUNT(b.GuestNo) / 30 AS AvgBookingsInApril
FROM Booking b
WHERE MONTH(b.DateFrom) = 4
GROUP BY b.HotelNo;

-- 4. Create index on one of the field and show is performance in query.
CREATE INDEX idx_hotelno_room ON Room (HotelNo);
-- Query to check performance:
EXPLAIN SELECT * FROM Room WHERE HotelNo = 1;

-- 5. List full details of all hotels.
SELECT * FROM Hotel;

-- 6. List full details of all hotels in London.
SELECT * FROM Hotel where City = "London";

-- 7. Update the price of all rooms by 5%.
UPDATE Room SET Price = Price * 1.05;

-- 8. List the number of rooms in each hotel in London.
SELECT h.Name, COUNT(r.RoomNo) AS NumberOfRooms
FROM Hotel h
JOIN Room r ON h.HotelNo = r.HotelNo
WHERE h.City = 'London'
GROUP BY h.Name;


-- 9. List all double or family rooms with a price below £40.00 per night, in
-- ascending order of price.
SELECT RoomNo, HotelNo, Type, Price
FROM Room
WHERE (Type = 'Double' OR Type = 'Family') AND Price < 40
ORDER BY Price ASC;
