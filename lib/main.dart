import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboard_screen.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Qiphlow',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0052cc)),
        useMaterial3: true,
        fontFamily: 'Inter',
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/onboard': (context) => const OnboardScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
