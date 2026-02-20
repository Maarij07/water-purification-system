import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth/onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNextScreen();
  }

  _navigateToNextScreen() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (mounted) {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/onboard');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF14103B),
        child: Stack(
          children: [
            // Watermark on right side (top to middle)
            Positioned(
              top: -400,
              right: -400,
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(
                  'assets/watermark.png',
                  width: 1600,
                  height: 1600,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Watermark on bottom right
            Positioned(
              bottom: -500,
              right: -350,
              child: Opacity(
                opacity: 0.12,
                child: Image.asset(
                  'assets/watermark.png',
                  width: 1400,
                  height: 1400,
                  fit: BoxFit.contain,
                ),
              ),
            ),
            // Center logo
            Center(
              child: Image.asset(
                'assets/logo.png',
                width: 120,
                height: 120,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
