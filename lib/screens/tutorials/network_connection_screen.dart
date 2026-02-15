import 'package:flutter/material.dart';
import '../../widgets/common_drawer.dart';

class NetworkConnectionScreen extends StatefulWidget {
  const NetworkConnectionScreen({Key? key}) : super(key: key);

  @override
  State<NetworkConnectionScreen> createState() => _NetworkConnectionScreenState();
}

class _NetworkConnectionScreenState extends State<NetworkConnectionScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  final List<NetworkConnectionData> steps = [
    NetworkConnectionData(
      title: 'Network\nConnection',
      description: '',
      content: [
        'Welcome message and overview of the network connection process.',
        'Brief explanation of the importance of connecting the device to a network.',
      ],
      isFirstStep: true,
      showImage: false,
    ),
    NetworkConnectionData(
      title: 'Preparing the\nDevice',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
    ),
    NetworkConnectionData(
      title: 'Enabling Bluetooth\n(BLE) on the Phone',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
    ),
    NetworkConnectionData(
      title: 'Pairing the Device\nvia BLE',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
    ),
    NetworkConnectionData(
      title: 'Connecting to\nWi-Fi',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
    ),
    NetworkConnectionData(
      title: 'Connecting to\nCellular Network',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
    ),
    NetworkConnectionData(
      title: 'Verifying Network\nConnection',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
      isTroubleshooting: true,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _scaffoldKey = GlobalKey<ScaffoldState>();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF0052cc), size: 28),
          onPressed: () {
            _scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          'Network Connection',
          style: TextStyle(
            color: Color(0xFF14103B),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
      drawer: CommonDrawer(scaffoldKey: _scaffoldKey, currentRoute: '/network-device'),
      body: Column(
        children: [
          // PageView for content
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemCount: steps.length,
              itemBuilder: (context, index) {
                return NetworkConnectionPage(data: steps[index]);
              },
            ),
          ),
          // Bottom section with dots and buttons
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                // Dots indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    steps.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == index ? 24 : 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? const Color(0xFF1a1a1a)
                            : const Color(0xFFcccccc),
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Action button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_currentPage == steps.length - 1) {
                        // Show completion modal
                        _showCompletionModal(context);
                      } else {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1a1a1a),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      _currentPage == 0
                          ? 'Start'
                          : _currentPage == steps.length - 1
                              ? 'Finish'
                              : 'Next',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        fontFamily: 'Inter',
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

  void _showCompletionModal(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Circular placeholder image
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 24),
              // Title
              const Text(
                'Congratulations!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14103B),
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 12),
              // Description
              const Text(
                'It is a long established fact that a reader will be distracted by the readable content',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  fontFamily: 'Inter',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
              // OK button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1a1a1a),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'OK',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NetworkConnectionPage extends StatelessWidget {
  final NetworkConnectionData data;

  const NetworkConnectionPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (data.isFirstStep) {
      return _buildFirstStepPage();
    } else {
      return _buildRegularStepPage();
    }
  }

  Widget _buildFirstStepPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF14103B),
                fontFamily: 'Inter',
                height: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            ...data.content.map((text) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '•',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF666666),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      text,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF666666),
                        fontFamily: 'Inter',
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildRegularStepPage() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (data.showImage)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            if (data.showImage) const SizedBox(height: 24),
            Text(
              data.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF14103B),
                fontFamily: 'Inter',
                height: 1.2,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              data.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                fontFamily: 'Inter',
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NetworkConnectionData {
  final String title;
  final String description;
  final List<String> content;
  final bool isFirstStep;
  final bool showImage;
  final bool isTroubleshooting;

  NetworkConnectionData({
    required this.title,
    required this.description,
    this.content = const [],
    this.isFirstStep = false,
    this.showImage = false,
    this.isTroubleshooting = false,
  });
}
