import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/booking_controller.dart';
import 'views/booking_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BookingController(),
      child: MaterialApp(
        title: 'RainStay Resort',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigoAccent),
          useMaterial3: true,
        ),
        home: const BookingView(),
      ),
    );
  }
}

