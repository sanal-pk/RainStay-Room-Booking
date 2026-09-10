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
├── constants/
│   └── app_colors.dart          # Centralized theme & UI color definitions
├── controllers/
│   └── booking_controller.dart  # POS lifecycle, state management, validations & pricing
├── data/
│   └── sample_data.dart         # Static seed data for room catalog
├── models/
│   └── room.dart                # Room and Booking data models
├── views/
│   ├── booking_screen.dart      # Main responsive POS & Booking view
│   └── splash_screen.dart       # Animated brand intro screen
├── widgets/                     # Reusable modular UI components
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

## ℹ️ Environment & Tooling

This section was developed with the assistance of Gemini:
- **IDE**: Antigravity
- **Flutter**: 3.47.2 (stable)
- **Dart**: 3.13.2
- **Focus**: Web and POS View
