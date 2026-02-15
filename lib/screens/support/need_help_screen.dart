import 'package:flutter/material.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_drawer.dart';

class NeedHelpScreen extends StatefulWidget {
  const NeedHelpScreen({Key? key}) : super(key: key);

  @override
  State<NeedHelpScreen> createState() => _NeedHelpScreenState();
}

class _NeedHelpScreenState extends State<NeedHelpScreen> {
  String selectedCategory = 'All Topics';
  bool showSearch = false;
  TextEditingController searchController = TextEditingController();
  
  final List<String> categories = ['All Topics', 'Account Management', 'Device Settings'];

  final List<FAQItem> allFAQs = [
    FAQItem(
      question: 'How do I reset my password?',
      category: 'Account Management',
      answer: 'To reset your password, go to the login page and click "Forgot Password". Enter your email address and follow the instructions sent to your email. You will receive a link to create a new password. Make sure to use a strong password with a mix of uppercase, lowercase, numbers, and special characters.',
    ),
    FAQItem(
      question: 'How do I update my profile information?',
      category: 'Account Management',
      answer: 'You can update your profile information by going to Settings > My Profile. From there, you can edit your name, email, phone number, and other personal details. Click Save to apply the changes. Your updated information will be reflected across all your devices.',
    ),
    FAQItem(
      question: 'How do I delete my account?',
      category: 'Account Management',
      answer: 'To delete your account, go to Settings > Account > Delete Account. Please note that this action is permanent and cannot be undone. All your data will be permanently deleted from our servers. You will receive a confirmation email before the deletion is finalized.',
    ),
    FAQItem(
      question: 'How do I enable two-factor authentication?',
      category: 'Account Management',
      answer: 'Navigate to Settings > Security > Two-Factor Authentication and enable it. You will be prompted to verify your phone number. Enter the code sent to your phone to complete the setup. This adds an extra layer of security to your account.',
    ),
    FAQItem(
      question: 'How do I connect my device?',
      category: 'Device Settings',
      answer: 'To connect your device, open the app and go to Home > Add Device. Follow the on-screen instructions to pair your device via Bluetooth or WiFi. Make sure your device is in pairing mode and is within range of your phone.',
    ),
    FAQItem(
      question: 'How do I calibrate my device?',
      category: 'Device Settings',
      answer: 'Go to Settings > Device Calibration and follow the step-by-step guide. The calibration process typically takes 5-10 minutes. Ensure your device is placed on a flat surface during calibration for accurate results.',
    ),
    FAQItem(
      question: 'How do I update device firmware?',
      category: 'Device Settings',
      answer: 'Check for firmware updates in Settings > Device > Firmware Update. If an update is available, tap "Update Now". The device will restart during the update process. Do not disconnect the device until the update is complete.',
    ),
    FAQItem(
      question: 'How do I troubleshoot connection issues?',
      category: 'Device Settings',
      answer: 'First, try restarting both your device and phone. Check if your WiFi connection is stable. If the issue persists, go to Settings > Device > Forget Device and reconnect. Clear the app cache from your phone settings if problems continue.',
    ),
  ];

  List<FAQItem> getFilteredFAQs() {
    List<FAQItem> filtered = allFAQs;
    
    if (selectedCategory != 'All Topics') {
      filtered = filtered.where((faq) => faq.category == selectedCategory).toList();
    }
    
    if (searchController.text.isNotEmpty) {
      filtered = filtered.where((faq) => 
        faq.question.toLowerCase().contains(searchController.text.toLowerCase()) ||
        faq.answer.toLowerCase().contains(searchController.text.toLowerCase())
      ).toList();
    }
    
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final filteredFAQs = getFilteredFAQs();
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CommonAppBar(scaffoldKey: scaffoldKey),
      drawer: CommonDrawer(scaffoldKey: scaffoldKey, currentRoute: '/need-help'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header with title and search
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Need help',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF14103B),
                      fontFamily: 'Inter',
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      showSearch ? Icons.close : Icons.search,
                      color: const Color(0xFF0052cc),
                      size: 24,
                    ),
                    onPressed: () {
                      setState(() {
                        showSearch = !showSearch;
                        if (!showSearch) {
                          searchController.clear();
                        }
                      });
                    },
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
            // Search bar (conditional)
            if (showSearch)
              Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: TextField(
                  controller: searchController,
                  onChanged: (value) {
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: 'Search questions...',
                    hintStyle: const TextStyle(
                      color: Color(0xFFCCCCCC),
                      fontSize: 13,
                      fontFamily: 'Inter',
                    ),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF0052cc), size: 20),
                    filled: true,
                    fillColor: const Color(0xFFF5F5F5),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFFEEEEEE)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: const BorderSide(color: Color(0xFF0052cc)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            // Category chips
            Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: categories.map((category) {
                    final isSelected = selectedCategory == category;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedCategory = category;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF001a4d) : Colors.white,
                            border: Border.all(
                              color: isSelected ? const Color(0xFF001a4d) : const Color(0xFFDDDDDD),
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isSelected ? Colors.white : const Color(0xFF14103B),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            // FAQ Items
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ...filteredFAQs.map((faq) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FAQDetailScreen(faq: faq),
                            ),
                          );
                        },
                        child: _buildFAQItem(
                          faq.question,
                          faq.category,
                          faq.answer,
                        ),
                      ),
                    );
                  }).toList(),
                  if (filteredFAQs.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Text(
                        'No questions found',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String category, String answer) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      question,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF14103B),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFFAAAAAA),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF0052cc),
                size: 16,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            answer.length > 100 ? '${answer.substring(0, 100)}...' : answer,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF999999),
              fontFamily: 'Inter',
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

class FAQItem {
  final String question;
  final String category;
  final String answer;

  FAQItem({
    required this.question,
    required this.category,
    required this.answer,
  });
}

class FAQDetailScreen extends StatelessWidget {
  final FAQItem faq;

  const FAQDetailScreen({Key? key, required this.faq}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0052cc)),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'FAQ',
          style: TextStyle(
            color: Color(0xFF001a4d),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero section with gradient
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
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category badge
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      faq.category,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Question
                  Text(
                    faq.question,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Inter',
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
            // Content section
            Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Answer heading
                  const Text(
                    'Answer',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0052cc),
                      fontFamily: 'Inter',
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Divider
                  Container(
                    height: 2,
                    width: 40,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0052cc),
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Answer text
                  Text(
                    faq.answer,
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF666666),
                      fontFamily: 'Inter',
                      height: 1.8,
                      letterSpacing: 0.2,
                    ),
                  ),
                ],
              ),
            ),
            // Related section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Was this helpful?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF14103B),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Thank you for your feedback!'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.thumb_up_outlined, size: 18),
                          label: const Text('Yes'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE8F0FF),
                            foregroundColor: const Color(0xFF0052cc),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('We will improve this answer'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          },
                          icon: const Icon(Icons.thumb_down_outlined, size: 18),
                          label: const Text('No'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFFF5E8),
                            foregroundColor: const Color(0xFFFF9500),
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Contact support section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F0FF),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: const Color(0xFF0052cc).withOpacity(0.2),
                ),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Still need help?',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0052cc),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Contact our support team for more assistance',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFF666666),
                      fontFamily: 'Inter',
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/contact-us');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0052cc),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Contact Support',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
