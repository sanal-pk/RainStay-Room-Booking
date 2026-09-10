# Hotel Room Booking Application

A responsive single-page hotel room booking application built with Flutter and Provider, following the MVC architecture.

---

## 🚀 Features

- **Room Catalog**: Displays sample rooms (`R101`, `R102`, `R201`, `R202`, `R301`) with room code, type, price per night (₹), and guest capacity.
- **Date Range Selection**: Date pickers for Check-in and Check-out dates.
- **Dynamic Price Calculation**: Automatically calculates the number of nights and total booking price (`nights × price per night`).
- **Input & Date Validation**:
  - Validates that check-out date is strictly after check-in date.
  - Ensures check-in date cannot be in the past.
  - Clear, user-friendly error messages when dates or selections are invalid.
- **Responsive Design**: Works across Mobile, Tablet, and Desktop screen widths.
- **Bonuses Implemented**:
  - Filter rooms by minimum guest capacity (2+, 3+, 4 guests).
  - Overlap availability check against existing bookings.
  - Comprehensive unit test suite for calculation and validation logic.

---

## 🛠️ Tech Stack & Architecture

- **Framework**: Flutter (Dart)
- **State Management**: `provider` (MVC pattern with `ChangeNotifier`)
- **Formatting**: `intl` (Indian Rupee `₹` formatting and date formatters)

### Project Structure
```
lib/
├── controllers/
│   └── booking_controller.dart  # Business logic, validations & pricing calculations
├── models/
│   └── room.dart                # Room and Booking data models + sample dataset
├── views/
│   └── booking_screen.dart      # Single-page responsive UI
└── main.dart                    # App initialization & Provider injection
test/
└── booking_controller_test.dart # Unit tests covering calculations & validation
```

---

## 🧪 Running Unit Tests

Run the test suite from the terminal:
```bash
flutter test
```

---

## 💻 Running the App

1. Ensure Flutter is installed and configured:
   ```bash
   flutter doctor
   ```
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application (Chrome, macOS, Android, or iOS):
   ```bash
   flutter run -d chrome
   ```

---

## 🔮 Future Improvements (With More Time)

- Connect to a live REST / GraphQL backend for real-time inventory and availability.
- Add room filtering by price range and room type search.
- Implement guest detail collection and payment gateway integration.
