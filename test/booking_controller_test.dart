import 'package:flutter_test/flutter_test.dart';
import 'package:rain_stay/controllers/booking_controller.dart';
import 'package:rain_stay/models/room.dart';

void main() {
  group('BookingController - Calculations & Validation Tests', () {
    late BookingController controller;

    setUp(() {
      controller = BookingController();
    });

    test('Initial state has 0 nights and 0 total price', () {
      expect(controller.nights, 0);
      expect(controller.totalPrice, 0.0);
      expect(controller.selectedRoom, isNull);
      expect(controller.canConfirmBooking, isFalse);
    });

    test('Calculates nights and total price accurately for valid dates', () {
      final room = Room.sampleRooms.firstWhere((r) => r.roomCode == 'R101'); // 3500/night
      controller.selectRoom(room);

      final checkIn = DateTime.now().add(const Duration(days: 10));
      final checkOut = DateTime.now().add(const Duration(days: 13)); // 3 nights

      controller.setCheckInDate(checkIn);
      controller.setCheckOutDate(checkOut);

      expect(controller.nights, 3);
      expect(controller.totalPrice, 3 * 3500.0);
      expect(controller.validationError, isNull);
      expect(controller.canConfirmBooking, isTrue);
    });

    test('Fails validation if check-out date is before or same as check-in date', () {
      final room = Room.sampleRooms.first;
      controller.selectRoom(room);

      final checkIn = DateTime.now().add(const Duration(days: 10));
      final checkOut = DateTime.now().add(const Duration(days: 10)); // Same day (0 nights)

      controller.setCheckInDate(checkIn);
      controller.setCheckOutDate(checkOut);

      expect(controller.validationError, isNotNull);
      expect(controller.validationError, contains('Check-out date must be after check-in date'));
      expect(controller.totalPrice, 0.0);
      expect(controller.canConfirmBooking, isFalse);
    });

    test('Fails validation if check-in date is in the past', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 2));
      final futureDate = DateTime.now().add(const Duration(days: 2));

      controller.setCheckInDate(pastDate);
      controller.setCheckOutDate(futureDate);

      expect(controller.validationError, isNotNull);
      expect(controller.validationError, contains('Check-in date cannot be in the past'));
      expect(controller.canConfirmBooking, isFalse);
    });

    test('Filters rooms by max guest capacity', () {
      expect(controller.filteredRooms.length, 5);

      controller.setGuestFilter(3);
      expect(controller.filteredRooms.every((r) => r.maxGuests >= 3), isTrue);
      expect(controller.filteredRooms.length, 3); // R201, R202, R301

      controller.setGuestFilter(4);
      expect(controller.filteredRooms.length, 1); // R301
      expect(controller.filteredRooms.first.roomCode, 'R301');
    });
  });
}
