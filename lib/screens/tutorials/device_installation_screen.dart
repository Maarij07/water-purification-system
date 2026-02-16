import 'package:flutter/material.dart';
import '../../widgets/common_drawer.dart';

class DeviceInstallationScreen extends StatefulWidget {
  final bool fromDrawer;

  const DeviceInstallationScreen({Key? key, this.fromDrawer = false}) : super(key: key);

  @override
  State<DeviceInstallationScreen> createState() => _DeviceInstallationScreenState();
}

class _DeviceInstallationScreenState extends State<DeviceInstallationScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  late GlobalKey<ScaffoldState> _scaffoldKey;

  final List<DeviceInstallationData> steps = [
    DeviceInstallationData(
      title: 'Device\nInstallation',
      description: '',
      content: [
        'Welcome message and overview of the installation process.',
        'Brief explanation of the components involved (device, sensors, power connection)',
      ],
      isFirstStep: true,
      showImage: false,
    ),
    DeviceInstallationData(
      title: 'Unboxing and\nPreparing the Device',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
    ),
    DeviceInstallationData(
      title: 'Connecting\nthe Sensors',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
    ),
    DeviceInstallationData(
      title: 'Powering\nthe Device',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
    ),
    DeviceInstallationData(
      title: 'Attaching the Sensors\nto the Tank',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
    ),
    DeviceInstallationData(
      title: 'Initial\nDevice Setup',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
    ),
    DeviceInstallationData(
      title: 'Troubleshooting Tips',
      description: 'It is a long established fact that a reader will be distracted by the readable content',
      isTroubleshooting: true,
      showImage: false,
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
          'Device Installation',
          style: TextStyle(
            color: Color(0xFF14103B),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
      drawer: CommonDrawer(scaffoldKey: _scaffoldKey, currentRoute: '/device-installation'),
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
                return DeviceInstallationPage(data: steps[index]);
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
              // Start connection button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    if (widget.fromDrawer) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1a1a1a),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Start connection',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      fontFamily: 'Inter',
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // Later link
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  if (widget.fromDrawer) {
                    Navigator.pushReplacementNamed(context, '/home');
                  } else {
                    Navigator.pop(context);
                  }
                },
                child: const Text(
                  'Later',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF14103B),
                    fontFamily: 'Inter',
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

class DeviceInstallationPage extends StatefulWidget {
  final DeviceInstallationData data;

  const DeviceInstallationPage({Key? key, required this.data}) : super(key: key);

  @override
  State<DeviceInstallationPage> createState() => _DeviceInstallationPageState();
}

class _DeviceInstallationPageState extends State<DeviceInstallationPage> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isFirstStep) {
      return _buildFirstStepPage();
    } else if (widget.data.isTroubleshooting) {
      return _buildTroubleshootingPage();
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
              widget.data.title,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: Color(0xFF14103B),
                fontFamily: 'Inter',
                height: 1.2,
              ),
            ),
            const SizedBox(height: 32),
            ...widget.data.content.map((text) => Padding(
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
            if (widget.data.showImage)
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: const Color(0xFFE8E8E8),
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            if (widget.data.showImage) const SizedBox(height: 24),
            Text(
              widget.data.title,
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
              widget.data.description,
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

  Widget _buildTroubleshootingPage() {
    final faqItems = [
      {'title': 'Question 1', 'desc': 'Answer description. Amet minim mollit non deserunt ullamco est sit aliqua dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
      {'title': 'Question 2', 'desc': 'Answer description. Amet minim mollit non deserunt ullamco est sit aliqua dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
      {'title': 'Question 3', 'desc': 'Answer description. Amet minim mollit non deserunt ullamco est sit aliqua dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.'},
    ];

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.data.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF14103B),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.data.description,
              style: const TextStyle(
                fontSize: 14,
                color: Color(0xFF666666),
                fontFamily: 'Inter',
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            // Accordion FAQ items
            ...List.generate(faqItems.length, (index) {
              final item = faqItems[index];
              final isExpanded = _expandedIndex == index;
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFFEEEEEE),
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _expandedIndex = isExpanded ? null : index;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(14),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  item['title']!,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF14103B),
                                    fontFamily: 'Inter',
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              AnimatedRotation(
                                turns: isExpanded ? 0.5 : 0,
                                duration: const Duration(milliseconds: 300),
                                child: Icon(
                                  Icons.expand_more,
                                  color: const Color(0xFF0052cc),
                                  size: 24,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: Container(
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F5F5),
                            border: Border(
                              top: BorderSide(
                                color: const Color(0xFFEEEEEE),
                                width: 1,
                              ),
                            ),
                          ),
                          padding: const EdgeInsets.all(14),
                          child: Text(
                            item['desc']!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFF666666),
                              fontFamily: 'Inter',
                              height: 1.6,
                            ),
                          ),
                        ),
                        crossFadeState: isExpanded
                            ? CrossFadeState.showSecond
                            : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 300),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class DeviceInstallationData {
  final String title;
  final String description;
  final List<String> content;
  final bool isFirstStep;
  final bool isTroubleshooting;
  final bool showImage;

  DeviceInstallationData({
    required this.title,
    required this.description,
    this.content = const [],
    this.isFirstStep = false,
    this.isTroubleshooting = false,
    this.showImage = false,
  });
}
