import 'package:flutter/material.dart';
import '../models/room.dart';

class BookingController extends ChangeNotifier {
  final List<Room> _rooms = Room.sampleRooms();

  String _currentTab = 'dashboard'; // 'dashboard' | 'checkin' | 'checkout'
  DateTime? _checkInDate;
  DateTime? _checkOutDate;
  Room? _selectedRoom;
  String _guestName = '';
  int _adultsCount = 1;
  int _childrenCount = 0;
  int? _guestFilter;
  String _searchQuery = '';
  String? _validationError;

  List<Room> get rooms => _rooms;
  String get searchQuery => _searchQuery;

  List<Room> get searchedRooms {
    if (_searchQuery.trim().isEmpty) return _rooms;
    final q = _searchQuery.trim().toLowerCase();
    return _rooms.where((r) {
      final codeMatch = r.roomCode.toLowerCase().contains(q);
      final typeMatch = r.roomType.toLowerCase().contains(q);
      final guestMatch = r.currentGuest?.toLowerCase().contains(q) ?? false;
      return codeMatch || typeMatch || guestMatch;
    }).toList();
  }
  String get currentTab => _currentTab;
  DateTime? get checkInDate => _checkInDate;
  DateTime? get checkOutDate => _checkOutDate;
  Room? get selectedRoom => _selectedRoom;
  String get guestName => _guestName;
  int get adultsCount => _adultsCount;
  int get childrenCount => _childrenCount;
  int get totalGuestsCount => _adultsCount + _childrenCount;
  int? get guestFilter => _guestFilter;
  String? get validationError => _validationError;

  DateTimeRange? get dateRange => (_checkInDate != null && _checkOutDate != null)
      ? DateTimeRange(start: _checkInDate!, end: _checkOutDate!)
      : null;

  List<Room> get filteredRooms {
    final available = _rooms.where((r) => r.status == RoomStatus.available);
    if (_guestFilter == null) return available.toList();
    return available.where((r) => r.maxGuests >= _guestFilter!).toList();
  }

  List<Room> get occupiedRoomsList => _rooms.where((r) => r.status == RoomStatus.occupied).toList();

  int get totalRooms => _rooms.length;
  int get occupiedRoomsCount => occupiedRoomsList.length;
  int get availableRoomsCount => _rooms.where((r) => r.status == RoomStatus.available).length;
  int get dirtyRoomsCount => _rooms.where((r) => r.status == RoomStatus.dirty).length;
  int get occupancyRate => totalRooms > 0 ? ((occupiedRoomsCount / totalRooms) * 100).round() : 0;

  // Nights calculation: checkOut - checkIn in days
  int get nights {
    if (_checkInDate == null || _checkOutDate == null) return 0;
    final diff = _checkOutDate!.difference(_checkInDate!).inDays;
    return diff > 0 ? diff : 0;
  }

  // Room charge = nights * price per night
  double get roomCharge {
    if (_selectedRoom == null || nights <= 0 || _validationError != null) return 0.0;
    return nights * _selectedRoom!.pricePerNight;
  }

  // Extra charges for checkout review
  double get extraChargesTotal {
    if (_selectedRoom == null) return 0.0;
    return _selectedRoom!.extraCharges.fold(0.0, (sum, item) => sum + item.amount);
  }

  // Total amount due (Nights × Rate + Extras)
  double get totalPrice => roomCharge + extraChargesTotal;

  bool get canConfirmBooking =>
      _selectedRoom != null &&
      _checkInDate != null &&
      _checkOutDate != null &&
      _guestName.trim().isNotEmpty &&
      _adultsCount <= (_selectedRoom?.maxGuests ?? 0) &&
      _validationError == null &&
      nights > 0;

  void switchTab(String tab, {Room? room}) {
    _currentTab = tab;
    if (room != null) {
      if (tab == 'checkout') {
        selectRoomForCheckout(room);
      } else {
        selectRoom(room);
      }
    }
    notifyListeners();
  }

  void setGuestName(String name) {
    _guestName = name;
    _validate();
    notifyListeners();
  }

  void setAdultsCount(int count) {
    if (count < 1) return;
    _adultsCount = count;
    _validate();
    notifyListeners();
  }

  void setChildrenCount(int count) {
    if (count < 0) return;
    _childrenCount = count;
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
    _selectedRoom = room;
    _validate();
    notifyListeners();
  }

  void selectRoomForCheckout(Room room) {
    _selectedRoom = room;
    _checkInDate = room.checkInDate ?? DateTime.now().subtract(const Duration(days: 1));
    _checkOutDate = room.checkOutDate ?? DateTime.now();
    _validationError = null;
    notifyListeners();
  }

  void setGuestFilter(int? guests) {
    _guestFilter = guests;
    if (_selectedRoom != null && _guestFilter != null && _selectedRoom!.maxGuests < _guestFilter!) {
      _selectedRoom = null;
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void clearSelection() {
    _selectedRoom = null;
    _checkInDate = null;
    _checkOutDate = null;
    _guestName = '';
    _adultsCount = 1;
    _childrenCount = 0;
    _validationError = null;
    notifyListeners();
  }

  void confirmCheckIn() {
    if (!canConfirmBooking || _selectedRoom == null) return;
    _selectedRoom!.status = RoomStatus.occupied;
    _selectedRoom!.currentGuest = _guestName.trim().isNotEmpty ? _guestName.trim() : 'Guest';
    _selectedRoom!.checkInDate = _checkInDate;
    _selectedRoom!.checkOutDate = _checkOutDate;
    _selectedRoom!.extraCharges = [];
    clearSelection();
    _currentTab = 'dashboard';
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
    _currentTab = 'dashboard';
    notifyListeners();
  }

  void markRoomClean(Room room) {
    room.status = RoomStatus.available;
    notifyListeners();
  }

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
    }

    if (_selectedRoom != null && _adultsCount > _selectedRoom!.maxGuests) {
      _validationError = 'Adults count ($_adultsCount) exceeds room capacity (${_selectedRoom!.maxGuests} max).';
      return;
    }

    _validationError = null;
  }
}
