import '../data/sample_data.dart';

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

  static List<Room> sampleRooms() => SampleData.getSampleRooms();
}
