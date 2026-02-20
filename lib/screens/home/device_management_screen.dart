import 'package:flutter/material.dart';
import '../tutorials/device_installation_screen.dart';
import '../tutorials/connect_device_screen.dart';
import '../tutorials/calibration_screen.dart';
import '../tutorials/network_connection_screen.dart';

class DeviceManagementScreen extends StatefulWidget {
  const DeviceManagementScreen({Key? key}) : super(key: key);

  @override
  State<DeviceManagementScreen> createState() => _DeviceManagementScreenState();
}

class _DeviceManagementScreenState extends State<DeviceManagementScreen> {
  int _completedSteps = 0; // 0 = none, 1 = installation, 2 = connect, 3 = calibration, 4 = network

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF14103B),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 24),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // Dark header with watermark
          Container(
            color: const Color(0xFF14103B),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
            child: Stack(
              children: [
                // Watermark on right side (larger and more visible)
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
                // Watermark on bottom right (larger and more visible)
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
                // Text content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Device\nmanagement',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        fontFamily: 'Inter',
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'It is a long established fact that a reader will be distracted by the readable content',
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFFB0C4FF),
                        fontFamily: 'Inter',
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // White content area
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Device Installation
                    _buildTutorialCard(
                      context,
                      index: 1,
                      title: 'Device Installation',
                      description: 'Tutorial for physically installing the device and the liquid sensors on the tank',
                      isCompleted: _completedSteps >= 1,
                      onTap: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const DeviceInstallationScreen(),
                          ),
                        );
                        setState(() {
                          _completedSteps = 1;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    // Connect My Device
                    _buildTutorialCard(
                      context,
                      index: 2,
                      title: 'Connect My Device',
                      description: 'Tutorial for connecting the device to the network',
                      isCompleted: _completedSteps >= 2,
                      isLocked: _completedSteps < 1,
                      onTap: _completedSteps >= 1
                          ? () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const ConnectDeviceScreen(),
                                ),
                              );
                              setState(() {
                                _completedSteps = 2;
                              });
                            }
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Calibrate My Device
                    _buildTutorialCard(
                      context,
                      index: 3,
                      title: 'Calibrate My Device',
                      description: 'Tutorial for calibration the device and sensors',
                      isCompleted: _completedSteps >= 3,
                      isLocked: _completedSteps < 2,
                      onTap: _completedSteps >= 2
                          ? () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const CalibrationScreen(),
                                ),
                              );
                              setState(() {
                                _completedSteps = 3;
                              });
                            }
                          : null,
                    ),
                    const SizedBox(height: 16),
                    // Network Connection
                    _buildTutorialCard(
                      context,
                      index: 4,
                      title: 'Network Connection',
                      description: 'Tutorial for connecting the device to Wi-Fi or cellular networks',
                      isCompleted: _completedSteps >= 4,
                      isLocked: _completedSteps < 3,
                      onTap: _completedSteps >= 3
                          ? () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const NetworkConnectionScreen(),
                                ),
                              );
                              setState(() {
                                _completedSteps = 4;
                              });
                            }
                          : null,
                    ),
                    const SizedBox(height: 32),
                    // Start installation button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _completedSteps < 4
                            ? () async {
                                if (_completedSteps == 0) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const DeviceInstallationScreen(),
                                    ),
                                  );
                                  setState(() {
                                    _completedSteps = 1;
                                  });
                                } else if (_completedSteps == 1) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ConnectDeviceScreen(),
                                    ),
                                  );
                                  setState(() {
                                    _completedSteps = 2;
                                  });
                                } else if (_completedSteps == 2) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const CalibrationScreen(),
                                    ),
                                  );
                                  setState(() {
                                    _completedSteps = 3;
                                  });
                                } else if (_completedSteps == 3) {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const NetworkConnectionScreen(),
                                    ),
                                  );
                                  setState(() {
                                    _completedSteps = 4;
                                  });
                                }
                              }
                            : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _completedSteps < 4
                              ? const Color(0xFF001a4d)
                              : const Color(0xFFCCCCCC),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          _completedSteps == 0
                              ? 'Start installation'
                              : _completedSteps == 1
                                  ? 'Connect My Device'
                                  : _completedSteps == 2
                                      ? 'Calibrate My Device'
                                      : _completedSteps == 3
                                          ? 'Network Connection'
                                          : 'All Complete',
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
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTutorialCard(
    BuildContext context, {
    required int index,
    required String title,
    required String description,
    required bool isCompleted,
    bool isLocked = false,
    required VoidCallback? onTap,
  }) {
    return Opacity(
      opacity: isLocked ? 0.6 : 1.0,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(
              color: isLocked ? const Color(0xFFDDDDDD) : const Color(0xFFEEEEEE),
              width: 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Checkmark or bullet point
              Container(
                width: 24,
                height: 24,
                margin: const EdgeInsets.only(right: 12, top: 2),
                decoration: BoxDecoration(
                  color: isCompleted ? const Color(0xFF51CF66) : Colors.transparent,
                  border: Border.all(
                    color: isCompleted ? const Color(0xFF51CF66) : const Color(0xFFCCCCCC),
                    width: 2,
                  ),
                  shape: BoxShape.circle,
                ),
                child: isCompleted
                    ? const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 14,
                      )
                    : null,
              ),
              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: isLocked ? const Color(0xFFAAAAAA) : const Color(0xFF14103B),
                        fontFamily: 'Inter',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: TextStyle(
                        fontSize: 12,
                        color: isLocked ? const Color(0xFFCCCCCC) : const Color(0xFFAAAAAA),
                        fontFamily: 'Inter',
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              if (isLocked)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.lock,
                    color: const Color(0xFFAAAAAA),
                    size: 18,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
