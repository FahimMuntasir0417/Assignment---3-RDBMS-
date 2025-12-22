# Vehicle Rental System Database

## Project Overview

This project is a Vehicle Rental System database designed to manage users, vehicles, and bookings.
It supports real-world rental operations such as booking vehicles, tracking availability, and calculating rental costs.

---

## 🔗 Project Resources

📊 **ERD Diagram**  
👉 [Click here to view the ERD](https://lucid.app/lucidchart/e889c745-f110-441d-a342-59c05c8807da/edit?viewport_loc=-3819%2C-959%2C1865%2C1087%2C0_0&invitationId=inv_6fa4a1a7-9c18-43d9-a4a7-1c18d680726d)

🎥 **Viva Presentation Video**  
👉 [Watch the Viva Video](https://your-viva-video-link-here)

---

## Database Design

The database consists of three main tables:

- Users
- Vehicles
- Bookings

The relationships include:

- One-to-Many between Users and Bookings
- One-to-Many between Vehicles and Bookings
- Each booking links exactly one user and one vehicle

## Status Fields

The system uses status fields to track current states:

- booking_status in Bookings (pending, confirmed, completed, cancelled)
- availability_status in Vehicles (available, rented, maintenance)

## SQL Queries

All required SQL queries (JOIN, WHERE, EXISTS) are provided in the `queries.sql` file.
