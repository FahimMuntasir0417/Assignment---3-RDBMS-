CREATE DATABASE vehicle_rental_system;

CREATE TABLE users (
    user_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(20),
    role VARCHAR(20) NOT NULL CHECK (role IN ('Admin', 'Customer')),
    password VARCHAR(255) NOT NULL
);

CREATE TABLE vehicles (
    vehicle_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type VARCHAR(20) NOT NULL CHECK (type IN ('car', 'bike', 'truck')),
    model VARCHAR(50) NOT NULL,
    registration_number VARCHAR(50) UNIQUE NOT NULL,
    rental_price_per_day DECIMAL(10,2) NOT NULL CHECK (rental_price_per_day >= 0),
    availability_status VARCHAR(30) NOT NULL
      CHECK (availability_status IN ('available', 'rented', 'maintenance'))
);

CREATE TABLE bookings (
    booking_id SERIAL PRIMARY KEY,
    user_id INT NOT NULL REFERENCES users(user_id),
    vehicle_id INT NOT NULL REFERENCES vehicles(vehicle_id),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    booking_status VARCHAR(30) NOT NULL
      CHECK (booking_status IN ('pending', 'confirmed', 'completed', 'cancelled')),
    total_cost DECIMAL(10,2) NOT NULL CHECK (total_cost >= 0),

    CHECK (end_date >= start_date)
);

INSERT INTO users (user_id, name, email, phone, role, password) VALUES
(1, 'Alice',   'alice@example.com',   '1234567890', 'Customer', 'alice123'),
(2, 'Bob',     'bob@example.com',     '0987654321', 'Admin',    'bob123'),
(3, 'Charlie', 'charlie@example.com', '1122334455', 'Customer', 'charlie123'),
(4, 'Diana',   'diana@example.com',   '2233445566', 'Customer', 'diana123'),
(5, 'Ethan',   'ethan@example.com',   '3344556677', 'Customer', 'ethan123');

INSERT INTO vehicles (vehicle_id, name, type, model, registration_number, rental_price_per_day, availability_status) VALUES
(1,  'Toyota Corolla', 'car',   '2022', 'ABC-123',  50,  'available'),
(2,  'Honda Civic',    'car',   '2021', 'DEF-456',  60,  'rented'),
(3,  'Yamaha R15',     'bike',  '2023', 'GHI-789',  30,  'available'),
(4,  'Ford F-150',     'truck', '2020', 'JKL-012', 100,  'maintenance'),
(5,  'Tesla Model 3',  'car',   '2023', 'TES-333', 120,  'available'),
(6,  'Suzuki Gixxer',  'bike',  '2022', 'SUZ-777',  35,  'available'),
(7,  'Isuzu D-Max',    'truck', '2021', 'ISU-888', 110,  'rented'),
(8,  'Nissan Sunny',   'car',   '2020', 'NIS-222',  45,  'available'),
(9,  'KTM Duke 200',   'bike',  '2021', 'KTM-200',  40,  'maintenance'),
(10, 'Toyota Hilux',   'truck', '2022', 'HIL-555', 115,  'available');


INSERT INTO bookings (booking_id, user_id, vehicle_id, start_date, end_date, booking_status, total_cost) VALUES
(1,  1, 2,  '2023-10-01', '2023-10-05', 'completed', 240),
(2,  1, 2,  '2023-11-01', '2023-11-03', 'completed', 120),
(3,  3, 2,  '2023-12-01', '2023-12-02', 'confirmed',  60),
(4,  1, 1,  '2023-12-10', '2023-12-12', 'pending',   100),
(5,  4, 3,  '2024-01-05', '2024-01-07', 'completed',  90),
(6,  5, 5,  '2024-01-10', '2024-01-12', 'confirmed', 360),
(7,  3, 8,  '2024-02-01', '2024-02-03', 'completed', 135),
(8,  4, 6,  '2024-02-10', '2024-02-10', 'completed',  35),
(9,  5, 10, '2024-03-01', '2024-03-04', 'pending',   460),
(10, 1, 7,  '2024-03-10', '2024-03-12', 'cancelled', 330);


-- Query 1: JOIN
-- Retrieve booking information along with:

-- Customer name
-- Vehicle name
-- Concepts used: INNER JOIN


SELECT
  b.booking_id,
  u.name AS customer_name,
  v.name AS vehicle_name,
  b.start_date,
  b.end_date,
  b.booking_status AS status
FROM bookings b
INNER JOIN users u ON u.user_id = b.user_id
INNER JOIN vehicles v ON v.vehicle_id = b.vehicle_id
ORDER BY b.booking_id;


-- Query 2: EXISTS
-- Find all vehicles that have never been booked.

-- Concepts used: NOT EXISTS

SELECT
  v.vehicle_id,
  v.name,
  v.type,
  v.model,
  v.registration_number,
  v.rental_price_per_day AS rental_price,
  v.availability_status AS status
FROM vehicles v
WHERE NOT EXISTS (
  SELECT 1
  FROM bookings b
  WHERE b.vehicle_id = v.vehicle_id
)
ORDER BY v.vehicle_id;


-- Query 3: WHERE
-- Retrieve all available vehicles of a specific type (e.g. cars).

-- Concepts used: SELECT, WHERE

SELECT
  v.vehicle_id,
  v.name,
  v.type,
  v.model,
  v.registration_number,
  v.rental_price_per_day AS rental_price,
  v.availability_status AS status
FROM vehicles v
WHERE v.availability_status = 'available'
  AND v.type = 'car'
ORDER BY v.vehicle_id;


-- Query 4: GROUP BY and HAVING
-- Find the total number of bookings for each vehicle and display only those vehicles that have more than 2 bookings.

-- Concepts used: GROUP BY, HAVING, COUNT

SELECT
  v.name AS vehicle_name,
  COUNT(b.booking_id) AS total_bookings
FROM vehicles v
JOIN bookings b ON b.vehicle_id = v.vehicle_id
GROUP BY v.name
HAVING COUNT(b.booking_id) > 2
ORDER BY total_bookings DESC;
