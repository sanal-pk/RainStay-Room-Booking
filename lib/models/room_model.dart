enum RoomStatus { available, occupied, dirty, maintenance }

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
  final String description;
  final String image;
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
    required this.description,
    required this.image,
    this.floor = 1,
    this.status = RoomStatus.available,
    this.currentGuest,
    this.checkInDate,
    this.checkOutDate,
    this.extraCharges = const [],
  });

  String get displayName => '$roomType ($roomCode)';

  static List<Room> getSampleRooms() => [
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
            const AdditionalCharge(title: 'Mini-bar (Water x2)', amount: 100.0, date: '03/04/2026'),
            const AdditionalCharge(title: 'Room Service', amount: 1200.0, date: '03/04/2026'),
            const AdditionalCharge(title: 'Restaurant Bill (Room 101)', amount: 850.0, date: '03/04/2026'),
          ],
          description: 'Plush queen bed, city views, and pillows softer than cloud nine.',
          image: 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=600',
        ),
        Room(
          roomCode: 'R102',
          roomType: 'Deluxe Room',
          pricePerNight: 3500.0,
          maxGuests: 2,
          floor: 1,
          status: RoomStatus.available,
          description: 'Twin deluxe setup, quiet corner location for uninterrupted relaxation.',
          image: 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=600',
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
          checkOutDate: DateTime.now().add(const Duration(days: 1)),
          extraCharges: [
            const AdditionalCharge(title: 'Mini-bar (Chips)', amount: 50.0, date: '03/04/2026'),
            const AdditionalCharge(title: 'Restaurant Bill (Room 201)', amount: 1200.0, date: '03/04/2026'),
          ],
          description: 'Spacious lounge, king bed, and bathtub ready for peak luxury.',
          image: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=600',
        ),
        Room(
          roomCode: 'R202',
          roomType: 'Executive Suite',
          pricePerNight: 5800.0,
          maxGuests: 3,
          floor: 2,
          status: RoomStatus.dirty,
          description: 'High-floor suite with panoramic sunset views and espresso bar.',
          image: 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=600',
        ),
        Room(
          roomCode: 'R301',
          roomType: 'Family Room',
          pricePerNight: 4200.0,
          maxGuests: 4,
          floor: 3,
          status: RoomStatus.available,
          description: 'Multiple beds, extra storage, and generous space for the entire family.',
          image: 'https://images.unsplash.com/photo-1591088398332-8a7791972843?w=600',
        ),
      ];
}
