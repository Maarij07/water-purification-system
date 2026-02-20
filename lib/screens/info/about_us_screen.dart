import 'package:flutter/material.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_drawer.dart';

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
            // Hero section with dark background and watermark
            Container(
              width: double.infinity,
              color: const Color(0xFF14103B),
              padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
              child: Stack(
                children: [
                  // Watermark on right side
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
                  // Content
                  Column(
                    children: [
                      Image.asset(
                        'assets/logo.png',
                        height: 80,
                      ),
                      const SizedBox(height: 16),
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
