import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/booking_controller.dart';
import 'views/booking_screen.dart';

void main() {
  runApp(const HotelBookingApp());
}

class HotelBookingApp extends StatelessWidget {
  const HotelBookingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingController(),
      child: MaterialApp(
        title: 'RainStay Hotel Booking',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
          useMaterial3: true,
          fontFamily: 'Roboto',
        ),
        home: const BookingScreen(),
      ),
    );
  }
}
