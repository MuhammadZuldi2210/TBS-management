# 📊 TBS Management

A full-stack management application built with **Flutter**, **Node.js**, **Express.js**, and **MongoDB**.

TBS Management is designed to manage users, resellers, administrators, transactions, coin balances, module subscriptions, and notifications in one integrated system.

---

## 🚀 Overview

TBS Management consists of two main components:

* 📱 **Mobile Application** — built with Flutter
* ⚙️ **Backend API** — built with Node.js and Express.js

The system implements role-based access control to provide different permissions and management capabilities for each user level.

### 👥 User Roles

| Role            | Description                                                                  |
| --------------- | ---------------------------------------------------------------------------- |
| **Super Admin** | Manages administrators, resellers, users, transactions, and system-wide data |
| **Admin**       | Manages resellers and users under their responsibility                       |
| **Reseller**    | Manages users under their account                                            |
| **User**        | Uses the assigned module and application features                            |

---

## ✨ Key Features

### 👥 User Management

* Create and manage administrators
* Create and manage resellers
* Create and manage users
* User search and pagination
* User status management
* Password management

### 💰 Coin Management

* View coin balance
* Request coin purchases
* Coin top-up management
* Coin transactions between management levels

### 📦 Module Management

* Module subscription
* Module extension
* Subscription duration management
* Active and expired user status

### 💳 Transaction Management

* Module extension transactions
* Coin purchase transactions
* Coin top-up transactions
* Pending, approved, and rejected transaction status
* Transaction history

### 🔔 Notification System

* User notifications
* Unread notification count
* Mark notification as read
* Mark all notifications as read
* Delete notifications

### 📊 Dashboard

* User statistics
* Admin statistics
* Reseller statistics
* Active and expired users
* Transaction statistics
* Revenue statistics

### 🔐 Security

* JWT authentication
* Role-based access control
* Password hashing with bcryptjs
* Secure credential storage
* API rate limiting
* HTTP security headers

---

## 🛠️ Tech Stack

### 📱 Mobile Application

<p>
  <img src="https://cdn.simpleicons.org/flutter/02569B" width="40" height="40" alt="Flutter">
  &nbsp;
  <img src="https://cdn.simpleicons.org/dart/0175C2" width="40" height="40" alt="Dart">
</p>

* **Flutter**
* **Dart**
* Provider
* Dio
* Flutter Secure Storage
* Shared Preferences
* Google Fonts
* Flutter SVG
* Cached Network Image

### ⚙️ Backend

<p>
  <img src="https://cdn.simpleicons.org/node.js/339933" width="40" height="40" alt="Node.js">
  &nbsp;
  <img src="https://cdn.simpleicons.org/express/FFFFFF" width="40" height="40" alt="Express.js">
  &nbsp;
  <img src="https://cdn.simpleicons.org/mongodb/47A248" width="40" height="40" alt="MongoDB">
</p>

* **Node.js**
* **Express.js**
* **MongoDB**
* Mongoose
* JSON Web Token (JWT)
* bcryptjs
* Helmet
* CORS
* Express Rate Limit
* Compression
* Morgan
* node-cron

---

## 📂 Project Structure

```text
TBS-management/
│
├── module_mobile/
│   ├── android/
│   ├── assets/
│   ├── ios/
│   ├── lib/
│   ├── test/
│   ├── web/
│   └── pubspec.yaml
│
├── module backend/
│   ├── src/
│   ├── server.js
│   ├── package.json
│   └── package-lock.json
│
├── .gitignore
└── README.md
```

---

## 📸 Screenshots

Screenshots of the TBS Management mobile application will be added here.

> Screenshots coming soon.

---

## 📦 Demo APK

An Android demo APK will be provided here for portfolio demonstration.

> Demo APK coming soon.

---

## 🔧 Installation

### 📱 Mobile Application

Navigate to the Flutter application:

```bash
cd module_mobile
```

Install dependencies:

```bash
flutter pub get
```

Run the application:

```bash
flutter run
```

### ⚙️ Backend

Navigate to the backend:

```bash
cd "module backend"
```

Install dependencies:

```bash
npm install
```

Start the server:

```bash
npm start
```

For development:

```bash
npm run dev
```

---

## 🔗 Project Modules

### 📱 Mobile Application

The Flutter mobile application is located in:

```text
module_mobile/
```

### ⚙️ Backend API

The Node.js and Express.js backend is located in:

```text
module backend/
```

---

## 👨‍💻 Developer

**Muhammad Zuldi**

Flutter & Backend Developer

<p>
  <a href="https://github.com/MuhammadZuldi2210">
    <img src="https://img.shields.io/badge/GitHub-MuhammadZuldi2210-181717?style=for-the-badge&logo=github&logoColor=white">
  </a>
  <a href="https://wa.me/6281285100984">
    <img src="https://img.shields.io/badge/WhatsApp-Contact%20Me-25D366?style=for-the-badge&logo=whatsapp&logoColor=white">
  </a>
  <a href="mailto:zuldiputratanjung2210@gmail.com">
    <img src="https://img.shields.io/badge/Email-Contact%20Me-D14836?style=for-the-badge&logo=gmail&logoColor=white">
  </a>
</p>

---

## 📌 Project Status

**Completed**

TBS Management was developed as a complete management system consisting of a Flutter mobile application and a Node.js backend API.
