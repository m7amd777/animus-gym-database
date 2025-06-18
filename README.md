# Animus Gym Database Management System

## 📌 Overview

This project implements a robust and normalized MySQL database system for **Animus Gym**, designed to streamline operations such as client management, coach assignments, session scheduling, and room bookings. Built using **phpMyAdmin** and **MySQL**, the database eliminates manual tracking and enhances organizational efficiency.

## 🎯 Motivation

Animus Gym originally operated without a centralized system, leading to:
- Missed payments due to untracked memberships.
- Scheduling conflicts from manual room and session booking.
- Difficulty assigning coaches and monitoring client progress.

This project offers a scalable solution to these challenges using SQL and relational database design principles.

---

## 🧱 Features

- ✅ **Client & Coach Management**
- ✅ **Room Booking with Double Booking Prevention**
- ✅ **Training Session Scheduling**
- ✅ **Package Subscription Tracking**
- ✅ **Trigger-based Business Logic Automation**
- ✅ **Predefined Views for Analytics**

---

## 🗃️ Entity Descriptions

| Entity     | Description                                      |
|------------|--------------------------------------------------|
| **Client** | Gym member enrolled in a package.                |
| **Coach**  | Gym instructor or trainer. Supports hierarchy.   |
| **Room**   | Rooms used for private sessions or classes.      |
| **Package**| Membership plans (duration, price, sessions).    |
| **Session**| Training sessions tied to a coach and room.      |
| **Room Booking** | Bookings of rooms by clients.              |
| **Coach Specialization** | Multi-valued attributes support.   |
| **Training Session** | Ternary relationship linking session, coach, and client. |

---

## 🧠 Database Design

### 🔄 Relationships
- A coach can manage multiple other coaches.
- Clients can be trained by and assigned to coaches.
- Clients can book rooms and attend training sessions.
- Packages can be purchased by many clients.

### 📐 ER Diagram
Due to ERD limitations, ternary relationships were split for representation.

### ✅ Normalization
All tables are normalized up to **3NF**. Transitive dependencies (e.g., `Package Name → Price`) were eliminated via additional relations.

---

## 🛠️ Development Stack

- **MySQL**
- **phpMyAdmin**
- **ERDPlus** (for ER diagrams)
