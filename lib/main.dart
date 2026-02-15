import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/onboard_screen.dart';
import 'screens/signin_screen.dart';
import 'screens/home_screen.dart';
import 'screens/calibration_screen.dart';
import 'screens/network_device_screen.dart';
import 'screens/my_profile_screen.dart';
import 'screens/reports_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/about_us_screen.dart';
import 'screens/terms_of_service_screen.dart';
import 'screens/privacy_policy_screen.dart';
import 'screens/need_help_screen.dart';
import 'screens/contact_us_screen.dart';

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
        '/signin': (context) => const SignInScreen(),
        '/home': (context) => const HomeScreen(),
        '/calibration': (context) => const CalibrationScreen(),
        '/network-device': (context) => const NetworkDeviceScreen(),
        '/my-profile': (context) => const MyProfileScreen(),
        '/reports': (context) => const ReportsScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/about-us': (context) => const AboutUsScreen(),
        '/terms-of-service': (context) => const TermsOfServiceScreen(),
        '/privacy-policy': (context) => const PrivacyPolicyScreen(),
        '/need-help': (context) => const NeedHelpScreen(),
        '/contact-us': (context) => const ContactUsScreen(),
      },
    );
  }
}
