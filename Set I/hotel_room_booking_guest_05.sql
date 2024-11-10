-- . The following tables form part of a database held in a relational DBMS:
-- Hotel (HotelNo, Name, City) HotelNo is the primary key
-- Room (RoomNo, HotelNo, Type, Price)
-- Booking (HotelNo, GuestNo, DateFrom, DateTo, RoomNo)
-- Guest (GuestNo, GuestName, GuestAddress)
-- Solve following queries by SQL
-- 1. List full details of all hotels.
-- 2. How many hotels are there?
-- 3. List the price and type of all rooms at the Grosvenor Hotel.
-- 4. List the number of rooms in each hotel
-- 5. List all guests currently staying at the Grosvenor Hotel.
-- 6. List all double or family rooms with a price below £40.00 per night, in ascending order of
-- price.
-- 7. How many different guests have made bookings for August?
-- 8. What is the total income from bookings for the Grosvenor Hotel today?
-- 9. What is the most commonly booked room type for each hotel in London?
-- 10. Update the price of all rooms by 5%.

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
(1, 1001, '2024-08-01', '2024-08-05', 102),
(1, 1002, '2024-08-10', '2024-08-15', 103),
(2, 1003, '2024-08-05', '2024-08-10', 201),
(3, 1004, '2024-08-12', '2024-08-18', 301),
(5, 1005, '2024-08-15', '2024-08-20', 501);



-- 1. List full details of all hotels.
Select * from hotel;

-- 2. How many hotels are there?
SELECT COUNT(*) AS TotalHotels FROM Hotel;

-- 3. List the price and type of all rooms at the Grosvenor Hotel.
SELECT Type, Price 
FROM Room r
JOIN Hotel h ON r.HotelNo = h.HotelNo
WHERE h.Name = 'Grosvenor Hotel';

-- 4. List the number of rooms in each hotel
SELECT h.Name, COUNT(r.RoomNo) AS NumberOfRooms
FROM Hotel h
JOIN Room r ON h.HotelNo = r.HotelNo
GROUP BY h.Name;

-- 5. List all guests currently staying at the Grosvenor Hotel.
SELECT g.GuestName, g.GuestAddress 
FROM Guest g
JOIN Booking b ON g.GuestNo = b.GuestNo
JOIN Hotel h ON b.HotelNo = h.HotelNo
WHERE h.Name = 'Grosvenor Hotel' AND CURDATE() BETWEEN b.DateFrom AND b.DateTo;


-- 6. List all double or family rooms with a price below £40.00 per night, in ascending order of
-- price.
SELECT RoomNo, HotelNo, Type, Price 
FROM Room
WHERE (Type = 'Double' OR Type = 'Family') AND Price < 40.00
ORDER BY Price ASC;


-- 7. How many different guests have made bookings for August?
SELECT COUNT(DISTINCT GuestNo) AS GuestsInAugust
FROM Booking
WHERE MONTH(DateFrom) = 8;


-- 8. What is the total income from bookings for the Grosvenor Hotel today?
SELECT SUM(r.Price) AS TotalIncomeToday
FROM Booking b
JOIN Room r ON b.RoomNo = r.RoomNo AND b.HotelNo = r.HotelNo
JOIN Hotel h ON b.HotelNo = h.HotelNo
WHERE h.Name = 'Grosvenor Hotel' AND CURDATE() BETWEEN b.DateFrom AND b.DateTo;


-- 9. What is the most commonly booked room type for each hotel in London?
SELECT h.Name, r.Type, COUNT(*) AS BookingCount
FROM Booking b
JOIN Room r ON b.RoomNo = r.RoomNo AND b.HotelNo = r.HotelNo
JOIN Hotel h ON b.HotelNo = h.HotelNo
WHERE h.City = 'London'
GROUP BY h.Name, r.Type
ORDER BY h.Name, BookingCount DESC;


-- 10. Update the price of all rooms by 5%.
UPDATE Room SET Price = Price * 1.05;
