import 'package:flutter/material.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<NotificationItem> todayNotifications = [
    NotificationItem(
      title: 'Water threshold is low',
      description: 'It is a long established fact that a reader will be',
      time: '16:45',
      hasAvatar: false,
      icon: Icons.water_drop,
      iconColor: Color(0xFF0052cc),
    ),
    NotificationItem(
      title: 'Anna accepted your invite!',
      description: 'It is a long established fact that a reader will be',
      time: '16:45',
      hasAvatar: true,
      avatarColor: const Color(0xFF6B9FFF),
    ),
    NotificationItem(
      title: 'Water threshold is low',
      description: 'It is a long established fact that a reader will be',
      time: '16:45',
      hasAvatar: false,
      icon: Icons.water_drop,
      iconColor: Color(0xFF0052cc),
    ),
    NotificationItem(
      title: 'Sensor is not healthy',
      description: 'Maintain your (sensor name)',
      time: '16:45',
      hasAvatar: false,
      icon: Icons.warning_rounded,
      iconColor: Color(0xFFFF6B6B),
    ),
  ];

  final List<NotificationItem> yesterdayNotifications = [
    NotificationItem(
      title: 'Device went offline',
      description: 'Check your connection',
      time: '16:45',
      hasAvatar: false,
      icon: Icons.cloud_off_rounded,
      iconColor: Color(0xFFFF9500),
    ),
    NotificationItem(
      title: 'New login location',
      description: 'Device name, IP address, location',
      time: '16:45',
      hasAvatar: false,
      icon: Icons.location_on_rounded,
      iconColor: Color(0xFF0052cc),
    ),
    NotificationItem(
      title: 'Pump was turned off',
      description: 'Automatically',
      time: '16:45',
      hasAvatar: false,
      icon: Icons.power_settings_new_rounded,
      iconColor: Color(0xFFFF6B6B),
    ),
    NotificationItem(
      title: 'Pump was turned on',
      description: 'Manually by (Username)',
      time: '16:45',
      hasAvatar: false,
      icon: Icons.power_settings_new_rounded,
      iconColor: Color(0xFF51CF66),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF0052cc), size: 24),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            color: Color(0xFF14103B),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: GestureDetector(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('All notifications cleared')),
                  );
                },
                child: const Text(
                  'Clear all',
                  style: TextStyle(
                    color: Color(0xFF0052cc),
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Inter',
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Today section
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: const Text(
                'Today',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFCCCCCC),
                  fontFamily: 'Inter',
                ),
              ),
            ),
            // Today notifications
            ...todayNotifications.map((notification) => _buildNotificationCard(notification)).toList(),
            const SizedBox(height: 28),
            // Yesterday section
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: const Text(
                'Yesterday (26.01.2025)',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFCCCCCC),
                  fontFamily: 'Inter',
                ),
              ),
            ),
            // Yesterday notifications
            ...yesterdayNotifications.map((notification) => _buildNotificationCard(notification)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationCard(NotificationItem notification) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFEEEEEE),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar or icon
          if (notification.hasAvatar)
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: notification.avatarColor,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person, color: Colors.white, size: 22),
            )
          else
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: notification.iconColor!.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                notification.icon,
                color: notification.iconColor,
                size: 22,
              ),
            ),
          const SizedBox(width: 12),
          // Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF14103B),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  notification.description,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFAAAAAA),
                    fontFamily: 'Inter',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Time
          Text(
            notification.time,
            style: const TextStyle(
              fontSize: 11,
              color: Color(0xFFCCCCCC),
              fontFamily: 'Inter',
            ),
          ),
        ],
      ),
    );
  }
}

class NotificationItem {
  final String title;
  final String description;
  final String time;
  final bool hasAvatar;
  final Color? avatarColor;
  final IconData? icon;
  final Color? iconColor;

  NotificationItem({
    required this.title,
    required this.description,
    required this.time,
    required this.hasAvatar,
    this.avatarColor,
    this.icon,
    this.iconColor,
  });
}
