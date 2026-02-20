import 'package:flutter/material.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/home/device_management_screen.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final String? screenName;

  const CommonAppBar({Key? key, required this.scaffoldKey, this.screenName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu, color: Color(0xFF0052cc), size: 28),
        onPressed: () {
          scaffoldKey.currentState?.openDrawer();
        },
      ),
      title: screenName != null
          ? Text(
              screenName!,
              style: const TextStyle(
                color: Color(0xFF14103B),
                fontSize: 18,
                fontWeight: FontWeight.w700,
                fontFamily: 'Inter',
              ),
            )
          : Image.asset(
              'assets/logo-horizontal.png',
              height: 40,
            ),
      centerTitle: true,
      actions: [
        // Plus button in light rounded square
        Container(
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F0FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF0052cc), size: 24),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const DeviceManagementScreen(),
                ),
              );
            },
            padding: const EdgeInsets.all(8),
            constraints: const BoxConstraints(),
          ),
        ),
        // Bell icon with notification dot
        Stack(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_outlined,
                  color: Color(0xFF0052cc), size: 28),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const NotificationsScreen(),
                  ),
                );
              },
            ),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF9500),
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
