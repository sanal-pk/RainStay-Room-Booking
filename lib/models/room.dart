class Room {
  final String roomCode;
  final String roomType;
  final double pricePerNight;
  final int maxGuests;

  const Room({
    required this.roomCode,
    required this.roomType,
    required this.pricePerNight,
    required this.maxGuests,
  });

  // Sample data provided in the assessment specification
  static const List<Room> sampleRooms = [
    Room(
      roomCode: 'R101',
      roomType: 'Deluxe Room',
      pricePerNight: 3500.0,
      maxGuests: 2,
    ),
    Room(
      roomCode: 'R102',
      roomType: 'Deluxe Room',
      pricePerNight: 3500.0,
      maxGuests: 2,
    ),
    Room(
      roomCode: 'R201',
      roomType: 'Executive Suite',
      pricePerNight: 5800.0,
      maxGuests: 3,
    ),
    Room(
      roomCode: 'R202',
      roomType: 'Executive Suite',
      pricePerNight: 5800.0,
      maxGuests: 3,
    ),
    Room(
      roomCode: 'R301',
      roomType: 'Family Room',
      pricePerNight: 4200.0,
      maxGuests: 4,
    ),
  ];
}

class ExistingBooking {
  final String roomCode;
  final DateTime checkIn;
  final DateTime checkOut;

  const ExistingBooking({
    required this.roomCode,
    required this.checkIn,
    required this.checkOut,
  });
}
