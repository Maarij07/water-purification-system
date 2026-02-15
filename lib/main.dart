import 'package:flutter/material.dart';
import 'screens/splash/splash_screen.dart';
import 'screens/auth/onboard_screen.dart';
import 'screens/auth/signin_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/tutorials/calibration_screen.dart';
import 'screens/tutorials/network_connection_screen.dart';
import 'screens/profile/my_profile_screen.dart';
import 'screens/reports/reports_screen.dart';
import 'screens/settings/settings_screen.dart';
import 'screens/info/about_us_screen.dart';
import 'screens/info/terms_of_service_screen.dart';
import 'screens/info/privacy_policy_screen.dart';
import 'screens/support/need_help_screen.dart';
import 'screens/support/contact_us_screen.dart';

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
        '/network-device': (context) => const NetworkConnectionScreen(),
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
