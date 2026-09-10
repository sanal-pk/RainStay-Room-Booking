import 'package:flutter/material.dart';
import '../models/room_model.dart';

class BookingController extends ChangeNotifier {
  final List<Room> rooms = Room.getSampleRooms();

  String _currentTab = 'dashboard'; // 'dashboard' | 'checkin' | 'checkout'
  Room? _selectedRoom;
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  String? _guestName = 'Guest Traveler';
  String? _errorMessage;

  String get currentTab => _currentTab;
  Room? get selectedRoom => _selectedRoom;
  DateTime? get checkInDate => _checkInDate;
  DateTime? get checkOutDate => _checkOutDate;
  String? get guestName => _guestName;
  String? get errorMessage => _errorMessage;

  DateTimeRange? get dateRange => (_checkInDate != null && _checkOutDate != null)
      ? DateTimeRange(start: _checkInDate!, end: _checkOutDate!)
      : null;

  int get nights {
    if (_checkInDate == null || _checkOutDate == null) return 0;
    final diff = _checkOutDate!.difference(_checkInDate!).inDays;
    return diff > 0 ? diff : 0;
  }

  double get roomCharge {
    if (_selectedRoom == null || nights == 0 || _errorMessage != null) return 0.0;
    return nights * _selectedRoom!.pricePerNight;
  }

  double get totalExtraCharges {
    if (_selectedRoom == null) return 0.0;
    return _selectedRoom!.extraCharges.fold(0.0, (sum, item) => sum + item.amount);
  }

  double get totalPrice => roomCharge + totalExtraCharges;

  bool get isReadyToBook =>
      _selectedRoom != null && _checkInDate != null && _checkOutDate != null && _errorMessage == null;

  int get totalRooms => rooms.length;
  int get occupiedRooms => rooms.where((r) => r.status == RoomStatus.occupied).length;
  int get availableRooms => rooms.where((r) => r.status == RoomStatus.available).length;
  int get dirtyRooms => rooms.where((r) => r.status == RoomStatus.dirty).length;
  int get occupancyRate => totalRooms > 0 ? ((occupiedRooms / totalRooms) * 100).round() : 0;

  void switchTab(String tab, {Room? room}) {
    _currentTab = tab;
    if (room != null) {
      selectRoom(room);
    }
    notifyListeners();
  }

  void selectRoom(Room room) {
    _selectedRoom = room;
    if (_currentTab == 'checkout' && room.checkInDate != null) {
      _checkInDate = room.checkInDate;
      _checkOutDate = room.checkOutDate ?? DateTime.now();
    }
    _validate();
    notifyListeners();
  }

  void setGuestName(String name) {
    _guestName = name;
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

  void clearSelection() {
    _selectedRoom = null;
    _checkInDate = null;
    _checkOutDate = null;
    _errorMessage = null;
    notifyListeners();
  }

  void confirmCheckIn() {
    if (!isReadyToBook || _selectedRoom == null) return;
    _selectedRoom!.status = RoomStatus.occupied;
    _selectedRoom!.currentGuest = _guestName?.isNotEmpty == true ? _guestName : 'Guest Traveler';
    _selectedRoom!.checkInDate = _checkInDate;
    _selectedRoom!.checkOutDate = _checkOutDate;
    clearSelection();
    notifyListeners();
  }

  void confirmCheckOut() {
    if (_selectedRoom == null) return;
    _selectedRoom!.status = RoomStatus.dirty;
    _selectedRoom!.currentGuest = null;
    _selectedRoom!.checkInDate = null;
    _selectedRoom!.checkOutDate = null;
    _selectedRoom!.extraCharges = [];
    clearSelection();
    notifyListeners();
  }

  void markRoomClean(Room room) {
    room.status = RoomStatus.available;
    notifyListeners();
  }

  void _validate() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (_currentTab == 'checkin') {
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
          _errorMessage = '👻 Check-out must be after check-in!';
          return;
        }
      }
    }

    _errorMessage = null;
  }
}
