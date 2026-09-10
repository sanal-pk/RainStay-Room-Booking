import 'package:flutter_test/flutter_test.dart';
import 'package:rain_stay/controllers/booking_controller.dart';
import 'package:rain_stay/models/room.dart';

void main() {
  group('BookingController - Calculations & POS Workflow Tests', () {
    late BookingController controller;

    setUp(() {
      controller = BookingController();
    });

    test('Initial state tracks occupancy stats correctly', () {
      expect(controller.totalRooms, 5);
      expect(controller.occupiedRoomsCount, 2);
      expect(controller.availableRoomsCount, 2);
      expect(controller.dirtyRoomsCount, 1);
      expect(controller.occupancyRate, 40); // 2 of 5 = 40%
    });

    test('Calculates nights and price accurately for check-in', () {
      final room = controller.rooms.firstWhere((r) => r.roomCode == 'R102'); // 3500/night
      controller.selectRoom(room);

      final checkIn = DateTime.now().add(const Duration(days: 5));
      final checkOut = DateTime.now().add(const Duration(days: 8)); // 3 nights

      controller.setCheckInDate(checkIn);
      controller.setCheckOutDate(checkOut);

      expect(controller.nights, 3);
      expect(controller.roomCharge, 3 * 3500.0);
      expect(controller.totalPrice, 3 * 3500.0);
      expect(controller.canConfirmBooking, isTrue);
    });

    test('Fails validation if check-out date is not after check-in date', () {
      final room = controller.rooms.firstWhere((r) => r.roomCode == 'R102');
      controller.selectRoom(room);

      final date = DateTime.now().add(const Duration(days: 2));
      controller.setCheckInDate(date);
      controller.setCheckOutDate(date); // Same day (0 nights)

      expect(controller.validationError, isNotNull);
      expect(controller.validationError, contains('Check-out date must be after check-in date'));
      expect(controller.canConfirmBooking, isFalse);
    });

    test('Fails validation if check-in is in the past', () {
      final pastDate = DateTime.now().subtract(const Duration(days: 2));
      final futureDate = DateTime.now().add(const Duration(days: 2));

      controller.setCheckInDate(pastDate);
      controller.setCheckOutDate(futureDate);

      expect(controller.validationError, isNotNull);
      expect(controller.validationError, contains('Check-in date cannot be in the past'));
      expect(controller.canConfirmBooking, isFalse);
    });

    test('Executes check-in and checkout transitions properly', () {
      final room = controller.rooms.firstWhere((r) => r.roomCode == 'R102');
      controller.selectRoom(room);
      controller.setGuestName('John Doe');
      controller.setCheckInDate(DateTime.now().add(const Duration(days: 1)));
      controller.setCheckOutDate(DateTime.now().add(const Duration(days: 3)));

      controller.confirmCheckIn();
      expect(room.status, RoomStatus.occupied);
      expect(room.currentGuest, 'John Doe');

      // Now checkout
      controller.selectRoomForCheckout(room);
      expect(controller.selectedRoom?.roomCode, 'R102');
      controller.confirmCheckOut();
      expect(room.status, RoomStatus.dirty);
      expect(room.currentGuest, isNull);

      // Housekeeping cleans room
      controller.markRoomClean(room);
      expect(room.status, RoomStatus.available);
    });
  });
}
