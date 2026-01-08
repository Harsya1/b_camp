# BCamp

**BCamp** is a Flutter-based mobile application designed to facilitate the search and booking of *camp* (dormitory) for Brilliant English Course students in Pare, Kediri. This application was developed using **Flutter framework** and **Dart programming language**.

## Main Features

- **Dashboard Calendar**
 View room availability and bookings via an interactive calendar interface.

- **Booking Management**
 Complete booking system allowing users to search, book, and manage camp reservations.

- **Camp Management**
 Manage camp data including categories and types (CRUD capabilities).

- **Search & Filter**
 Advanced search functionality to find camps by category (e.g., VIP) and type.

- **User Profile**
 Profile management including personal data editing and password changes.

- **Authentication**
 Secure login and registration system.

## Technology Used

- Flutter (Frontend Mobile Development)
- Dart (Programming Language)
- Laravel (Backend API)
- MySQL (Database)

## How to Install and Run

1. Clone this repository:
   ```bash
   git clone https://github.com/Harsya1/b_camp.git
   ```

2. Masuk ke direktori project:
   ```bash
   cd b_camp
   ```

3. Install dependencies:
   ```bash
   flutter pub get
   ```

4. Run the application:
   ```bash
   flutter run
   ```

## Project Structure
- `/lib` - contains the main source code
- `/lib/screen` - Application screens including Dashboard, Calendar, Profile, and management sections
- `/lib/screen/booking_section` - Booking management screens
- `/lib/screen/camp_section` - Camp management (CRUD) screens
- `/lib/screen/profile_section` - Profile editing and settings
- `/lib/service` - API integration, database controllers, and authentication logic
- `/lib/model` - Data models
- `/lib/assets` - Static resources (images, fonts, icons)

## Application Purpose

- Helps Brilliant English Course students find dormitories easily.
- Provide up-to-date information about events and activities at Brilliant.
- Speed up the registration and booking process digitally.