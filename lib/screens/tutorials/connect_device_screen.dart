import 'package:flutter/material.dart';

class ConnectDeviceScreen extends StatefulWidget {
  final bool fromDrawer;

  const ConnectDeviceScreen({Key? key, this.fromDrawer = false}) : super(key: key);

  @override
  State<ConnectDeviceScreen> createState() => _ConnectDeviceScreenState();
}

class _ConnectDeviceScreenState extends State<ConnectDeviceScreen> {
  late PageController _pageController;
  int _currentPage = 0;
  
  // Form controllers for step 2
  final TextEditingController _streetController = TextEditingController(text: 'Main str, 5');
  final TextEditingController _cityController = TextEditingController(text: 'San Diego');
  final TextEditingController _stateController = TextEditingController(text: 'California');
  final TextEditingController _zipController = TextEditingController(text: '92101');
  final TextEditingController _countryController = TextEditingController(text: 'USA');

  final List<ConnectDeviceData> steps = [
    ConnectDeviceData(
      title: 'Connect My\nDevice',
      description: '',
      content: [
        'Welcome message and overview of the connection process.',
        'Brief explanation of the components involved (device, network, app).',
      ],
      isFirstStep: true,
      showImage: false,
    ),
    ConnectDeviceData(
      title: 'Set device installation\naddress',
      description: '',
      isFormStep: true,
      showImage: false,
    ),
    ConnectDeviceData(
      title: 'Preparing\nthe Device',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
    ),
    ConnectDeviceData(
      title: 'Connecting to the\nNetwork',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
    ),
    ConnectDeviceData(
      title: 'Connecting the Device\nto the Server',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
    ),
    ConnectDeviceData(
      title: 'Using the App to\nComplete Setup',
      description: 'It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout.',
      showImage: true,
    ),
    ConnectDeviceData(
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
  }

  @override
  void dispose() {
    _pageController.dispose();
    _streetController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0052cc), size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Connect Device',
          style: TextStyle(
            color: Color(0xFF14103B),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
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
                return ConnectDevicePage(
                  data: steps[index],
                  streetController: _streetController,
                  cityController: _cityController,
                  stateController: _stateController,
                  zipController: _zipController,
                  countryController: _countryController,
                );
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
              // Start calibration button
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
                    'Start calibration',
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

class ConnectDevicePage extends StatefulWidget {
  final ConnectDeviceData data;
  final TextEditingController streetController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipController;
  final TextEditingController countryController;

  const ConnectDevicePage({
    Key? key,
    required this.data,
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.zipController,
    required this.countryController,
  }) : super(key: key);

  @override
  State<ConnectDevicePage> createState() => _ConnectDevicePageState();
}

class _ConnectDevicePageState extends State<ConnectDevicePage> {
  int? _expandedIndex;

  @override
  Widget build(BuildContext context) {
    if (widget.data.isFirstStep) {
      return _buildFirstStepPage();
    } else if (widget.data.isFormStep) {
      return _buildFormStepPage();
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

  Widget _buildFormStepPage() {
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
                height: 1.2,
              ),
            ),
            const SizedBox(height: 24),
            // Street Address
            Text(
              'Street Address',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFAAAAAA),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: widget.streetController,
              decoration: InputDecoration(
                hintText: 'Main str, 5',
                hintStyle: const TextStyle(
                  color: Color(0xFF14103B),
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFEEEEEE),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFEEEEEE),
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              style: const TextStyle(
                color: Color(0xFF14103B),
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 20),
            // City
            Text(
              'City',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFAAAAAA),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: widget.cityController,
              decoration: InputDecoration(
                hintText: 'San Diego',
                hintStyle: const TextStyle(
                  color: Color(0xFF14103B),
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFEEEEEE),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFEEEEEE),
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              style: const TextStyle(
                color: Color(0xFF14103B),
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 20),
            // State/Province and ZIP/Postal Code
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'State/Province',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFAAAAAA),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: widget.stateController,
                        decoration: InputDecoration(
                          hintText: 'California',
                          hintStyle: const TextStyle(
                            color: Color(0xFF14103B),
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFAFAFA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFEEEEEE),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFEEEEEE),
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF14103B),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ZIP/Postal Code',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFAAAAAA),
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        controller: widget.zipController,
                        decoration: InputDecoration(
                          hintText: '92101',
                          hintStyle: const TextStyle(
                            color: Color(0xFF14103B),
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                          filled: true,
                          fillColor: const Color(0xFFFAFAFA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFEEEEEE),
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(
                              color: Color(0xFFEEEEEE),
                              width: 1,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                        ),
                        style: const TextStyle(
                          color: Color(0xFF14103B),
                          fontSize: 14,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Country
            Text(
              'Country',
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFAAAAAA),
                fontFamily: 'Inter',
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: widget.countryController,
              decoration: InputDecoration(
                hintText: 'USA',
                hintStyle: const TextStyle(
                  color: Color(0xFF14103B),
                  fontSize: 14,
                  fontFamily: 'Inter',
                ),
                filled: true,
                fillColor: const Color(0xFFFAFAFA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFEEEEEE),
                    width: 1,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(
                    color: Color(0xFFEEEEEE),
                    width: 1,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              ),
              style: const TextStyle(
                color: Color(0xFF14103B),
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
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

class ConnectDeviceData {
  final String title;
  final String description;
  final List<String> content;
  final bool isFirstStep;
  final bool isFormStep;
  final bool isTroubleshooting;
  final bool showImage;

  ConnectDeviceData({
    required this.title,
    required this.description,
    this.content = const [],
    this.isFirstStep = false,
    this.isFormStep = false,
    this.isTroubleshooting = false,
    this.showImage = false,
  });
}
