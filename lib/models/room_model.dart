class Room {
  final String roomCode;
  final String roomType;
  final double pricePerNight;
  final int maxGuests;
  final String description;
  final String image;

  const Room({
    required this.roomCode,
    required this.roomType,
    required this.pricePerNight,
    required this.maxGuests,
    required this.description,
    required this.image,
  });

  String get displayName => '$roomType ($roomCode)';

  // Hardcoded sample data — freshly vacuumed and ready to host
  static const List<Room> sampleRooms = [
    Room(
      roomCode: 'R101',
      roomType: 'Deluxe Room',
      pricePerNight: 3500.0,
      maxGuests: 2,
      description: 'Plush queen bed, city views, and pillows softer than cloud nine.',
      image: 'https://images.unsplash.com/photo-1590490360182-c33d57733427?w=600',
    ),
    Room(
      roomCode: 'R102',
      roomType: 'Deluxe Room',
      pricePerNight: 3500.0,
      maxGuests: 2,
      description: 'Twin deluxe setup, quiet corner location for uninterrupted binge-watching.',
      image: 'https://images.unsplash.com/photo-1566665797739-1674de7a421a?w=600',
    ),
    Room(
      roomCode: 'R201',
      roomType: 'Executive Suite',
      pricePerNight: 5800.0,
      maxGuests: 3,
      description: 'Spacious lounge, king bed, and a bathtub ready for peak main-character energy.',
      image: 'https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=600',
    ),
    Room(
      roomCode: 'R202',
      roomType: 'Executive Suite',
      pricePerNight: 5800.0,
      maxGuests: 3,
      description: 'High-floor suite with panoramic sunset views and espresso bar.',
      image: 'https://images.unsplash.com/photo-1618773928121-c32242e63f39?w=600',
    ),
    Room(
      roomCode: 'R301',
      roomType: 'Family Room',
      pricePerNight: 4200.0,
      maxGuests: 4,
      description: 'Multiple beds, extra storage, and enough room for everyone to not argue.',
      image: 'https://images.unsplash.com/photo-1591088398332-8a7791972843?w=600',
    ),
  ];
}
