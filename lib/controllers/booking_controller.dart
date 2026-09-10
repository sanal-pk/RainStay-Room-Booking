import 'package:flutter/material.dart';
import '../models/room.dart';

class BookingController extends ChangeNotifier {
  final List<Room> _rooms = Room.sampleRooms;

  // Mock existing bookings for testing availability collisions (Bonus)
  final List<ExistingBooking> _existingBookings = [
    ExistingBooking(
      roomCode: 'R101',
      checkIn: DateTime.now().add(const Duration(days: 3)),
      checkOut: DateTime.now().add(const Duration(days: 5)),
    ),
    ExistingBooking(
      roomCode: 'R201',
      checkIn: DateTime.now().add(const Duration(days: 1)),
      checkOut: DateTime.now().add(const Duration(days: 4)),
    ),
  ];

  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  Room? _selectedRoom;
  int? _guestFilter;
  String? _validationError;

  List<Room> get rooms => _rooms;
  DateTime? get checkInDate => _checkInDate;
  DateTime? get checkOutDate => _checkOutDate;
  Room? get selectedRoom => _selectedRoom;
  int? get guestFilter => _guestFilter;
  String? get validationError => _validationError;

  // Filtered rooms based on guest count selection
  List<Room> get filteredRooms {
    if (_guestFilter == null) return _rooms;
    return _rooms.where((room) => room.maxGuests >= _guestFilter!).toList();
  }

  // Calculate number of nights between check-in and check-out
  int get nights {
    if (_checkInDate == null || _checkOutDate == null) return 0;
    final diff = _checkOutDate!.difference(_checkInDate!).inDays;
    return diff > 0 ? diff : 0;
  }

  // Total price = nights * price per night
  double get totalPrice {
    if (_selectedRoom == null || nights <= 0 || _validationError != null) {
      return 0.0;
    }
    return nights * _selectedRoom!.pricePerNight;
  }

  bool get canConfirmBooking =>
      _selectedRoom != null &&
      _checkInDate != null &&
      _checkOutDate != null &&
      _validationError == null &&
      nights > 0;

  void setCheckInDate(DateTime? date) {
    _checkInDate = date;
    _validate();
    notifyListeners();
  }

  void setCheckOutDate(DateTime? date) {
    _checkOutDate = date;
    _validate();
    notifyListeners();
  }

  void setDateRange(DateTimeRange? range) {
    if (range != null) {
      _checkInDate = range.start;
      _checkOutDate = range.end;
    } else {
      _checkInDate = null;
      _checkOutDate = null;
    }
    _validate();
    notifyListeners();
  }

  void selectRoom(Room room) {
    if (!isRoomAvailable(room)) {
      _validationError = 'Room ${room.roomCode} is unavailable for the chosen dates.';
      notifyListeners();
      return;
    }

    _selectedRoom = room;
    _validate();
    notifyListeners();
  }

  void setGuestFilter(int? guests) {
    _guestFilter = guests;
    if (_selectedRoom != null && _guestFilter != null && _selectedRoom!.maxGuests < _guestFilter!) {
      _selectedRoom = null;
    }
    notifyListeners();
  }

  void reset() {
    _checkInDate = null;
    _checkOutDate = null;
    _selectedRoom = null;
    _guestFilter = null;
    _validationError = null;
    notifyListeners();
  }

  // Check if a room conflicts with existing bookings
  bool isRoomAvailable(Room room) {
    if (_checkInDate == null || _checkOutDate == null) return true;

    final inDate = DateTime(_checkInDate!.year, _checkInDate!.month, _checkInDate!.day);
    final outDate = DateTime(_checkOutDate!.year, _checkOutDate!.month, _checkOutDate!.day);

    for (final booking in _existingBookings) {
      if (booking.roomCode == room.roomCode) {
        final bIn = DateTime(booking.checkIn.year, booking.checkIn.month, booking.checkIn.day);
        final bOut = DateTime(booking.checkOut.year, booking.checkOut.month, booking.checkOut.day);

        // Dates overlap if (startA < endB) and (endA > startB)
        if (inDate.isBefore(bOut) && outDate.isAfter(bIn)) {
          return false;
        }
      }
    }
    return true;
  }

  // Core date & selection validation
  void _validate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_checkInDate != null) {
      final checkInDay = DateTime(_checkInDate!.year, _checkInDate!.month, _checkInDate!.day);
      if (checkInDay.isBefore(today)) {
        _validationError = 'Check-in date cannot be in the past.';
        return;
      }
    }

    if (_checkInDate != null && _checkOutDate != null) {
      final checkInDay = DateTime(_checkInDate!.year, _checkInDate!.month, _checkInDate!.day);
      final checkOutDay = DateTime(_checkOutDate!.year, _checkOutDate!.month, _checkOutDate!.day);

      if (!checkOutDay.isAfter(checkInDay)) {
        _validationError = 'Check-out date must be after check-in date.';
        return;
      }

      if (_selectedRoom != null && !isRoomAvailable(_selectedRoom!)) {
        _validationError = 'Room ${_selectedRoom!.roomCode} is already booked for these dates.';
        return;
      }
    }

    _validationError = null;
  }
}
