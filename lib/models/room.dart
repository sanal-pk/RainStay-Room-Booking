enum RoomStatus { available, occupied, dirty }

class AdditionalCharge {
  final String title;
  final double amount;
  final String date;

  const AdditionalCharge({
    required this.title,
    required this.amount,
    required this.date,
  });
}

class Room {
  final String roomCode;
  final String roomType;
  final double pricePerNight;
  final int maxGuests;
  final int floor;
  RoomStatus status;
  String? currentGuest;
  DateTime? checkInDate;
  DateTime? checkOutDate;
  List<AdditionalCharge> extraCharges;

  Room({
    required this.roomCode,
    required this.roomType,
    required this.pricePerNight,
    required this.maxGuests,
    this.floor = 1,
    this.status = RoomStatus.available,
    this.currentGuest,
    this.checkInDate,
    this.checkOutDate,
    this.extraCharges = const [],
  });

  String get displayName => '$roomType ($roomCode)';

  // Assessment sample rooms initialized with realistic hotel states
  static List<Room> sampleRooms() => [
        Room(
          roomCode: 'R101',
          roomType: 'Deluxe Room',
          pricePerNight: 3500.0,
          maxGuests: 2,
          floor: 1,
          status: RoomStatus.occupied,
          currentGuest: 'Mathew Hyden',
          checkInDate: DateTime.now().subtract(const Duration(days: 2)),
          checkOutDate: DateTime.now(),
          extraCharges: [
            const AdditionalCharge(title: 'Mini-bar (Water x2)', amount: 100.0, date: 'Today'),
            const AdditionalCharge(title: 'Room Service Dinner', amount: 950.0, date: 'Yesterday'),
          ],
        ),
        Room(
          roomCode: 'R102',
          roomType: 'Deluxe Room',
          pricePerNight: 3500.0,
          maxGuests: 2,
          floor: 1,
          status: RoomStatus.available,
        ),
        Room(
          roomCode: 'R201',
          roomType: 'Executive Suite',
          pricePerNight: 5800.0,
          maxGuests: 3,
          floor: 2,
          status: RoomStatus.occupied,
          currentGuest: 'Sarah Thompson',
          checkInDate: DateTime.now().subtract(const Duration(days: 1)),
          checkOutDate: DateTime.now().add(const Duration(days: 2)),
          extraCharges: [
            const AdditionalCharge(title: 'Executive Lounge Coffee', amount: 250.0, date: 'Today'),
          ],
        ),
        Room(
          roomCode: 'R202',
          roomType: 'Executive Suite',
          pricePerNight: 5800.0,
          maxGuests: 3,
          floor: 2,
          status: RoomStatus.dirty,
        ),
        Room(
          roomCode: 'R301',
          roomType: 'Family Room',
          pricePerNight: 4200.0,
          maxGuests: 4,
          floor: 3,
          status: RoomStatus.available,
        ),
      ];
}
