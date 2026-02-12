import 'package:flutter/material.dart';
import 'onboard_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToOnboard();
  }

  _navigateToOnboard() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/onboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color(0xFF001a4d),
              const Color(0xFF003d99),
              const Color(0xFF0052cc),
            ],
          ),
        ),
        child: Stack(
          children: [
            // Watermark in background
            Positioned(
              right: -50,
              bottom: 100,
              child: Opacity(
                opacity: 0.15,
                child: Image.asset(
                  'assets/watermark.png',
                  width: 300,
                  height: 300,
                ),
              ),
            ),
            // Center logo
            Center(
              child: Image.asset(
                'assets/logo.png',
                width: 150,
                height: 150,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
