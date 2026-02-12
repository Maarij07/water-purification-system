import 'package:flutter/material.dart';

class CommonDrawer extends StatelessWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String currentRoute;

  const CommonDrawer({
    Key? key,
    required this.scaffoldKey,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.8,
      child: Container(
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
        child: Column(
          children: [
            // Header with user info
            Container(
              padding: const EdgeInsets.fromLTRB(20, 40, 20, 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Diana Johnson',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'loisbecket@gmail.com',
                            style: TextStyle(
                              color: Color(0xFFB0C4FF),
                              fontSize: 11,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ],
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
                      isActive: currentRoute == '/home',
                    ),
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.tune,
                      label: 'Calibration',
                      route: '/calibration',
                      isActive: currentRoute == '/calibration',
                    ),
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.hub,
                      label: 'Network Device',
                      route: '/network-device',
                      isActive: currentRoute == '/network-device',
                    ),
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.person_outline,
                      label: 'My profile',
                      route: '/my-profile',
                      isActive: currentRoute == '/my-profile',
                    ),
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.description_outlined,
                      label: 'Reports',
                      route: '/reports',
                      isActive: currentRoute == '/reports',
                    ),
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.settings_outlined,
                      label: 'Settings',
                      route: '/settings',
                      isActive: currentRoute == '/settings',
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
                      isActive: currentRoute == '/about-us',
                    ),
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.description_outlined,
                      label: 'Terms of service',
                      route: '/terms-of-service',
                      isActive: currentRoute == '/terms-of-service',
                    ),
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.shield_outlined,
                      label: 'Privacy policy',
                      route: '/privacy-policy',
                      isActive: currentRoute == '/privacy-policy',
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
                      isActive: currentRoute == '/need-help',
                    ),
                    _buildDrawerItem(
                      context: context,
                      icon: Icons.phone_outlined,
                      label: 'Contact us',
                      route: '/contact-us',
                      isActive: currentRoute == '/contact-us',
                    ),
                  ],
                ),
              ),
            ),
            // Footer
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
                ],
              ),
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
        if (route != currentRoute) {
          Navigator.pushReplacementNamed(context, route);
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
