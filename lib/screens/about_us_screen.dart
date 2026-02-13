import 'package:flutter/material.dart';
import '../widgets/common_app_bar.dart';
import '../widgets/common_drawer.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CommonAppBar(scaffoldKey: scaffoldKey),
      drawer: CommonDrawer(scaffoldKey: scaffoldKey, currentRoute: '/about-us'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero section with dark background
            Container(
              width: double.infinity,
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
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Column(
                children: [
                  Image.asset(
                    'assets/logo.png',
                    height: 80,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'QIPHLOW',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0xFFB0C4FF),
                      fontSize: 12,
                      fontFamily: 'Inter',
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            // Content section
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Some title here',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF14103B),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum it is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                      fontFamily: 'Inter',
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum it is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                      fontFamily: 'Inter',
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum it is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF666666),
                      fontFamily: 'Inter',
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
