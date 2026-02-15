import 'package:flutter/material.dart';

class OnboardScreen extends StatefulWidget {
  const OnboardScreen({Key? key}) : super(key: key);

  @override
  State<OnboardScreen> createState() => _OnboardScreenState();
}

class _OnboardScreenState extends State<OnboardScreen> {
  late PageController _pageController;
  int _currentPage = 0;

  final List<OnboardData> onboardData = [
    OnboardData(
      image: 'assets/onboard_1.png',
      title: 'Welcome & Easy Installation',
      description:
          'Welcome to Qiphlow! Monitor and control your water system with ease. Let\'s get started with a quick setup. Install the device easily by following these steps.',
    ),
    OnboardData(
      image: 'assets/onboard_2.png',
      title: 'Automatic Water Level Management',
      description:
          'Qiphlow automatically manages your water levels. Set thresholds, and your pump will turn on and off automatically to keep your tank at optimal levels.',
    ),
    OnboardData(
      image: 'assets/onboard_3.png',
      title: 'Notifications and Alerts',
      description:
          'Stay informed with customizable notifications. Get alerts for potential water waste and real-time updates on pump operations.',
    ),
    OnboardData(
      image: 'assets/onboard_4.png',
      title: 'Contaminant Check Steps',
      description:
          'Monitor your water quality with Qiphlow! Use the \'Contaminant Check\' option to view Lead and Mercury levels in real-time. The app will alert you if contaminants exceed safe thresholds, helping you maintain water safety.',
    ),
    OnboardData(
      image: 'assets/onboard_5.png',
      title: 'Smart Water Control',
      description:
          'Take full control of your water system with ease. Remotely manage your pump and water supply. Assign trusted users to monitor and control your system, keeping everything running smoothly, no matter where you are.',
    ),
    OnboardData(
      image: 'assets/onboard_6.png',
      title: 'Ready to Explore',
      description:
          'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        children: [
          // PageView for images, heading, and text
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: onboardData.length,
              itemBuilder: (context, index) {
                return OnboardPage(data: onboardData[index]);
              },
            ),
          ),
          // Bottom section with dots, skip, and next button
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Dots and Skip button row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Dots indicator
                    Row(
                      children: List.generate(
                        onboardData.length,
                        (index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: _currentPage == index ? 24 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: _currentPage == index
                                ? const Color(0xFF0052cc)
                                : const Color(0xFFcccccc),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    // Skip button
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/signin');
                      },
                      child: const Text(
                        'Skip',
                        style: TextStyle(
                          color: Color(0xFF0052cc),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Full width Next button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == onboardData.length - 1) {
                        Navigator.pushReplacementNamed(context, '/signin');
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF001a4d),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      _currentPage == onboardData.length - 1 ? 'Done' : 'Next',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardPage extends StatelessWidget {
  final OnboardData data;

  const OnboardPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: ShaderMask(
              shaderCallback: (bounds) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.white.withOpacity(0.8),
                    Colors.white.withOpacity(0.6),
                  ],
                ).createShader(bounds);
              },
              blendMode: BlendMode.multiply,
              child: Image.asset(
                data.image,
                height: 300,
                fit: BoxFit.contain,
              ),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            data.title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF14103B),
              height: 34 / 24,
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 16),
          Text(
            data.description,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF14103B),
              height: 22 / 14,
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardData {
  final String image;
  final String title;
  final String description;

  OnboardData({
    required this.image,
    required this.title,
    required this.description,
  });
}
