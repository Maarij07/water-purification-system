import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firebase_service.dart';

class CommonDrawer extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String currentRoute;

  const CommonDrawer({
    Key? key,
    required this.scaffoldKey,
    required this.currentRoute,
  }) : super(key: key);

  @override
  State<CommonDrawer> createState() => _CommonDrawerState();
}

class _CommonDrawerState extends State<CommonDrawer> {
  late Future<Map<String, dynamic>?> _userDataFuture;

  @override
  void initState() {
    super.initState();
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      _userDataFuture = FirebaseService.getUserData(user.uid);
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Container(
        color: const Color(0xFF14103B),
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
            // Main content
            Column(
              children: [
                // Header with user info
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: const Color(0xFF6B9FFF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.person,
                                  color: Colors.white, size: 28),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FutureBuilder<Map<String, dynamic>?>(
                                future: _userDataFuture,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData && snapshot.data != null) {
                                    final userData = snapshot.data!;
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          userData['fullName'] ?? 'User',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w700,
                                            fontFamily: 'Inter',
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          user?.email ?? '',
                                          style: const TextStyle(
                                            color: Color(0xFFB0C4FF),
                                            fontSize: 11,
                                            fontFamily: 'Inter',
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        user?.email ?? 'User',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          fontFamily: 'Inter',
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 2),
                                      const Text(
                                        'Loading...',
                                        style: TextStyle(
                                          color: Color(0xFFB0C4FF),
                                          fontSize: 11,
                                          fontFamily: 'Inter',
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 24),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                // Menu items
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.home_outlined,
                          label: 'Home',
                          route: '/home',
                          isActive: widget.currentRoute == '/home',
                        ),
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.tune,
                          label: 'Calibration',
                          route: '/calibration',
                          isActive: widget.currentRoute == '/calibration',
                        ),
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.hub,
                          label: 'Network Device',
                          route: '/network-device',
                          isActive: widget.currentRoute == '/network-device',
                        ),
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.person_outline,
                          label: 'My profile',
                          route: '/my-profile',
                          isActive: widget.currentRoute == '/my-profile',
                        ),
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.description_outlined,
                          label: 'Reports',
                          route: '/reports',
                          isActive: widget.currentRoute == '/reports',
                        ),
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.settings_outlined,
                          label: 'Settings',
                          route: '/settings',
                          isActive: widget.currentRoute == '/settings',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Divider(color: Color(0xFF4A7FFF), height: 1),
                        ),
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.info_outline,
                          label: 'About us',
                          route: '/about-us',
                          isActive: widget.currentRoute == '/about-us',
                        ),
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.description_outlined,
                          label: 'Terms of service',
                          route: '/terms-of-service',
                          isActive: widget.currentRoute == '/terms-of-service',
                        ),
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.shield_outlined,
                          label: 'Privacy policy',
                          route: '/privacy-policy',
                          isActive: widget.currentRoute == '/privacy-policy',
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          child: Divider(color: Color(0xFF4A7FFF), height: 1),
                        ),
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.help_outline,
                          label: 'Need help?',
                          route: '/need-help',
                          isActive: widget.currentRoute == '/need-help',
                        ),
                        _buildDrawerItem(
                          context: context,
                          icon: Icons.phone_outlined,
                          label: 'Contact us',
                          route: '/contact-us',
                          isActive: widget.currentRoute == '/contact-us',
                        ),
                      ],
                    ),
                  ),
                ),
                // Footer with Sign Out
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    border: Border(
                      top: BorderSide(color: Color(0xFF4A7FFF), width: 1),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Image.asset(
                            'assets/logo.png',
                            height: 24,
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'QIPHLOW',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                          const Spacer(),
                          const Text(
                            'App ver: 2.02',
                            style: TextStyle(
                              color: Color(0xFFB0C4FF),
                              fontSize: 10,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        '©2025 QIPHLOW. All rights reserved',
                        style: TextStyle(
                          color: Color(0xFF6B9FFF),
                          fontSize: 10,
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            try {
                              await FirebaseService.signOut();
                              Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(e.toString())),
                              );
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF6B6B),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Sign Out',
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
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        if (route != widget.currentRoute) {
          // For calibration and network device, pass fromDrawer: true
          if (route == '/calibration') {
            Navigator.pushReplacementNamed(context, route, arguments: {'fromDrawer': true});
          } else if (route == '/network-device') {
            Navigator.pushReplacementNamed(context, route, arguments: {'fromDrawer': true});
          } else {
            Navigator.pushReplacementNamed(context, route);
          }
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF4A7FFF).withOpacity(0.3) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF6B9FFF), size: 20),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.white,
                fontSize: 14,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
