import 'package:flutter/material.dart';
import '../models/room_model.dart';

class BookingController extends ChangeNotifier {
  final List<Room> rooms = Room.sampleRooms;

  Room? _selectedRoom;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  String? _errorMessage;

  Room? get selectedRoom => _selectedRoom;
  DateTime? get checkInDate => _checkInDate;
  DateTime? get checkOutDate => _checkOutDate;
  String? get errorMessage => _errorMessage;

  DateTimeRange? get dateRange => (_checkInDate != null && _checkOutDate != null)
      ? DateTimeRange(start: _checkInDate!, end: _checkOutDate!)
      : null;

  int get nights {
    if (_checkInDate == null || _checkOutDate == null) return 0;
    final diff = _checkOutDate!.difference(_checkInDate!).inDays;
    return diff > 0 ? diff : 0;
  }

  double get totalPrice {
    if (_selectedRoom == null || nights == 0 || _errorMessage != null) return 0.0;
    return nights * _selectedRoom!.pricePerNight;
  }

  bool get isReadyToBook =>
      _selectedRoom != null && _checkInDate != null && _checkOutDate != null && _errorMessage == null;

  void selectRoom(Room room) {
    if (_selectedRoom?.roomCode == room.roomCode) {
      _selectedRoom = null; // Toggle selection support for POS
    } else {
      _selectedRoom = room;
    }
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

  void clearSelection() {
    _selectedRoom = null;
    _checkInDate = null;
    _checkOutDate = null;
    _errorMessage = null;
    notifyListeners();
  }

  // The bouncer logic: validating calendar rules
  void _validate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_checkInDate != null) {
      final checkInDay = DateTime(_checkInDate!.year, _checkInDate!.month, _checkInDate!.day);
      if (checkInDay.isBefore(today)) {
        _errorMessage = '⏳ DeLorean not included. Please select today or a future date for check-in!';
        return;
      }
    }

    if (_checkInDate != null && _checkOutDate != null) {
      final checkInDay = DateTime(_checkInDate!.year, _checkInDate!.month, _checkInDate!.day);
      final checkOutDay = DateTime(_checkOutDate!.year, _checkOutDate!.month, _checkOutDate!.day);

      if (!checkOutDay.isAfter(checkInDay)) {
        _errorMessage = '👻 Check-out must be after check-in. Ghosts can teleport out instantly, mortals cannot!';
        return;
      }
    }

    _errorMessage = null;
  }
}
