import 'package:flutter/material.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_drawer.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  bool _faceIdEnabled = true;

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CommonAppBar(scaffoldKey: scaffoldKey, screenName: 'Settings'),
      drawer: CommonDrawer(scaffoldKey: scaffoldKey, currentRoute: '/settings'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Notifications setting
            _buildSettingCard(
              title: 'Notifications',
              subtitle: _notificationsEnabled ? 'ON' : 'OFF',
              trailing: Switch(
                value: _notificationsEnabled,
                onChanged: (value) {
                  setState(() {
                    _notificationsEnabled = value;
                  });
                },
                activeColor: const Color(0xFF51CF66),
                inactiveThumbColor: const Color(0xFFDDDDDD),
                inactiveTrackColor: const Color(0xFFEEEEEE),
              ),
              onTap: null,
            ),
            const SizedBox(height: 12),
            // Face ID Login setting
            _buildSettingCard(
              title: 'Face ID login',
              subtitle: 'Enable biometric authentication for quick access',
              trailing: Switch(
                value: _faceIdEnabled,
                onChanged: (value) {
                  setState(() {
                    _faceIdEnabled = value;
                  });
                },
                activeColor: const Color(0xFF51CF66),
                inactiveThumbColor: const Color(0xFFDDDDDD),
                inactiveTrackColor: const Color(0xFFEEEEEE),
              ),
              onTap: null,
            ),
            const SizedBox(height: 12),
            // Sensor refresh period setting
            _buildSettingCard(
              title: 'Sensor refresh period',
              subtitle: 'Lorem ipsum dolor sit amet, consectetur',
              trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xFFCCCCCC), size: 18),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SensorRefreshPeriodScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingCard({
    required String title,
    required String subtitle,
    required Widget trailing,
    required VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFFEEEEEE),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF14103B),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFAAAAAA),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            trailing,
          ],
        ),
      ),
    );
  }
}

class SensorRefreshPeriodScreen extends StatefulWidget {
  const SensorRefreshPeriodScreen({Key? key}) : super(key: key);

  @override
  State<SensorRefreshPeriodScreen> createState() => _SensorRefreshPeriodScreenState();
}

class _SensorRefreshPeriodScreenState extends State<SensorRefreshPeriodScreen> {
  String selectedPeriod = 'Once a day';

  final List<PeriodOption> periods = [
    PeriodOption(
      label: '1 hour',
      description: 'Check sensors every hour',
      icon: Icons.schedule,
    ),
    PeriodOption(
      label: '4 hours',
      description: 'Check sensors every 4 hours',
      icon: Icons.schedule,
    ),
    PeriodOption(
      label: 'Once a day',
      description: 'Check sensors once daily',
      icon: Icons.schedule,
    ),
    PeriodOption(
      label: 'Once a week',
      description: 'Check sensors once weekly',
      icon: Icons.schedule,
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
          'Set refresh period',
          style: TextStyle(
            color: Color(0xFF14103B),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 20),
              child: Text(
                'Select refresh period',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14103B),
                  fontFamily: 'Inter',
                ),
              ),
            ),
            ...periods.map((period) => _buildPeriodCard(period)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildPeriodCard(PeriodOption period) {
    final isSelected = selectedPeriod == period.label;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedPeriod = period.label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE8F0FF) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? const Color(0xFF0052cc) : const Color(0xFFEEEEEE),
            width: isSelected ? 2 : 1,
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Icon
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF0052cc)
                    : const Color(0xFFE8F0FF),
                shape: BoxShape.circle,
              ),
              child: Icon(
                period.icon,
                color: isSelected ? Colors.white : const Color(0xFF0052cc),
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    period.label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: isSelected
                          ? const Color(0xFF0052cc)
                          : const Color(0xFF14103B),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    period.description,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFFAAAAAA),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Radio button
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF0052cc)
                      : const Color(0xFFCCCCCC),
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Container(
                      margin: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0052cc),
                        shape: BoxShape.circle,
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

class PeriodOption {
  final String label;
  final String description;
  final IconData icon;

  PeriodOption({
    required this.label,
    required this.description,
    required this.icon,
  });
}
