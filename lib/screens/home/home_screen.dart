import 'package:flutter/material.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_drawer.dart';
import '../../widgets/shimmer_widget.dart';
import '../../services/api_service.dart';
import 'device_info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<DeviceData> _devices = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    // Show skeleton only on cold cache; warm cache loads silently in background.
    _isLoading = !ApiService.isCacheValid('devices');
    _loadDevices(showSkeleton: _isLoading);
  }

  Future<void> _loadDevices({bool showSkeleton = false}) async {
    if (showSkeleton) setState(() { _isLoading = true; _error = null; });
    try {
      final rawDevices = await ApiService.getDevices();

      // Fetch IoT status and sensor data for each device in parallel
      final List<DeviceData> loaded = [];
      for (final d in rawDevices) {
        final deviceId = d['id'] as int? ?? 0;
        final deviceKey = d['device_key'] as String? ?? '';
        final deviceName = d['name'] as String? ?? 'Device';
        final location = d['location'] as String? ?? '';

        // Online status
        bool isOnline = false;
        try {
          final status = await ApiService.getDeviceStatus(deviceKey);
          isOnline = status['is_online'] as bool? ?? false;
        } catch (_) {}

        // Sensor data + contaminants in a single call
        Map<String, dynamic>? deviceData;
        try {
          deviceData = await ApiService.getLatestSensorDataByDevice(deviceId);
        } catch (_) {}

        final sensorData =
            deviceData?['sensor_data'] as Map<String, dynamic>?;
        final contaminants =
            deviceData?['contaminants'] as Map<String, dynamic>?;

        final purificationStatus =
            sensorData?['purification_status'] as String? ?? '';
        final isHealthy = purificationStatus == 'safe';

        // This PCB's ion-selective electrodes report chlorine/nitrate (among
        // others) via contaminant_readings. WHO limits: chlorine <= 5 mg/L,
        // nitrate <= 50 mg/L (matches purification-aws backend seed data).
        final chlorineMgL = (contaminants?['chlorine'] as num?)?.toDouble();
        final nitrateMgL = (contaminants?['nitrate'] as num?)?.toDouble();

        final phLevel = sensorData?['ph_level'];
        final tdsLevel = sensorData?['tds_level'];
        final waterLevelPct =
            (sensorData?['water_level_percentage'] as num?)?.toInt() ?? 0;

        loaded.add(DeviceData(
          id: deviceId,
          deviceKey: deviceKey,
          name: location.isNotEmpty ? '$deviceName, $location' : deviceName,
          status: isOnline ? 'Online' : 'Offline',
          statusColor: isOnline
              ? const Color(0xFF51CF66)
              : const Color(0xFFAAAAAA),
          healthStatus: isHealthy ? 'Healthy' : 'Not Healthy',
          healthColor: isHealthy
              ? const Color(0xFF51CF66)
              : const Color(0xFFFF6B6B),
          incomingWaterLead: chlorineMgL != null
              ? '${chlorineMgL.toStringAsFixed(2)} mg/L'
              : 'N/A',
          incomingWaterLeadSafe:
              chlorineMgL != null && chlorineMgL > 5.0 ? 'UNSAFE' : '',
          incomingWaterMercury: nitrateMgL != null
              ? '${nitrateMgL.toStringAsFixed(2)} mg/L'
              : 'N/A',
          incomingWaterMercurySafe:
              nitrateMgL != null && nitrateMgL > 50.0 ? 'UNSAFE' : '',
          outgoingWaterLead:
              phLevel != null ? '$phLevel pH' : 'N/A',
          outgoingWaterLeadSafe: '',
          outgoingWaterMercury:
              tdsLevel != null ? '$tdsLevel TDS' : 'N/A',
          outgoingWaterMercurySafe: '',
          waterLevel: waterLevelPct,
        ));
      }

      if (mounted) setState(() { _devices = loaded; _isLoading = false; });
    } catch (e) {
      if (mounted) {
        if (showSkeleton) {
          setState(() { _error = e.toString(); _isLoading = false; });
        } else {
          // Silent background refresh failed — keep existing data, stop spinner.
          setState(() => _isLoading = false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CommonAppBar(
        scaffoldKey: _scaffoldKey,
        onDeviceAdded: () => _loadDevices(showSkeleton: true),
      ),
      drawer: CommonDrawer(scaffoldKey: _scaffoldKey, currentRoute: '/home'),
      body: _isLoading
          ? ListView(
              padding: const EdgeInsets.all(16),
              children: const [DeviceCardSkeleton(), DeviceCardSkeleton()],
            )
          : _error != null
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.error_outline,
                          color: Color(0xFFFF6B6B), size: 48),
                      const SizedBox(height: 12),
                      Text(_error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Color(0xFF666666), fontFamily: 'Inter')),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => _loadDevices(showSkeleton: true),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0052cc)),
                        child: const Text('Retry',
                            style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                )
              : _devices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Icon(Icons.devices_other,
                              color: Color(0xFFCCCCCC), size: 64),
                          SizedBox(height: 16),
                          Text(
                            'No devices found',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF666666),
                              fontFamily: 'Inter',
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Add a device to get started',
                            style: TextStyle(
                                fontSize: 13,
                                color: Color(0xFFAAAAAA),
                                fontFamily: 'Inter'),
                          ),
                        ],
                      ),
                    )
                  : RefreshIndicator(
                      onRefresh: () async {
                        // Invalidate device cache so pull-to-refresh fetches fresh data.
                        ApiService.invalidate('devices');
                        for (final d in _devices) {
                          ApiService.invalidate('iot_status_${d.deviceKey}');
                          ApiService.invalidate('sensor_device_${d.id}');
                        }
                        await _loadDevices(showSkeleton: false);
                      },
                      color: const Color(0xFF0052cc),
                      child: ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _devices.length,
                        itemBuilder: (context, index) {
                          return DeviceCard(device: _devices[index]);
                        },
                      ),
                    ),
    );
  }
}

class DeviceCard extends StatefulWidget {
  final DeviceData device;

  const DeviceCard({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceCard> createState() => _DeviceCardState();
}

class _DeviceCardState extends State<DeviceCard> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DeviceInfoScreen(device: widget.device),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with device name and menu
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.device.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF14103B),
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: widget.device.statusColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.device.status,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF666666),
                                fontFamily: 'Inter',
                              ),
                            ),
                            const SizedBox(width: 16),
                            Container(
                              width: 6,
                              height: 6,
                              decoration: BoxDecoration(
                                color: widget.device.healthColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              widget.device.healthStatus,
                              style: TextStyle(
                                fontSize: 12,
                                color: widget.device.healthColor,
                                fontFamily: 'Inter',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      _showDeviceOptions(context, widget.device);
                    },
                    child: const Icon(Icons.more_vert,
                        color: Color(0xFFCCCCCC), size: 20),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 12),
              // Pump control — not implemented by this device's current
              // firmware (Firmware.md has no relay/pump driver code), shown
              // disabled rather than sending a command the device ignores.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Pump control',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFAAAAAA),
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          'Not supported by this device\'s current firmware',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFAAAAAA),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                  ),
                  Transform.scale(
                    scale: 0.85,
                    child: const Switch(
                      value: false,
                      onChanged: null,
                      inactiveThumbColor: Color(0xFFDDDDDD),
                      inactiveTrackColor: Color(0xFFEEEEEE),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 12),
              // Water quality info
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Incoming water',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0052cc),
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 6),
                        _buildWaterQualityRow(
                          'Chlorine',
                          widget.device.incomingWaterLead,
                          widget.device.incomingWaterLeadSafe,
                        ),
                        const SizedBox(height: 4),
                        _buildWaterQualityRow(
                          'Nitrate (NO3⁻)',
                          widget.device.incomingWaterMercury,
                          widget.device.incomingWaterMercurySafe,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Outgoing water',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0052cc),
                            fontFamily: 'Inter',
                          ),
                        ),
                        const SizedBox(height: 6),
                        _buildWaterQualityRow(
                          'pH Level',
                          widget.device.outgoingWaterLead,
                          widget.device.outgoingWaterLeadSafe,
                        ),
                        const SizedBox(height: 4),
                        _buildWaterQualityRow(
                          'TDS Level',
                          widget.device.outgoingWaterMercury,
                          widget.device.outgoingWaterMercurySafe,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  // Water level indicator
                  Column(
                    children: [
                      Text(
                        '${widget.device.waterLevel}%',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF0052cc),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const Text(
                        'water level',
                        style: TextStyle(
                          fontSize: 10,
                          color: Color(0xFFAAAAAA),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 10),
                      WaterLevelIndicator(level: widget.device.waterLevel),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWaterQualityRow(String label, String value, String safe) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFF14103B),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF999999),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(width: 4),
        Text(
          safe,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFFFF6B6B),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }

  void _showDeviceOptions(BuildContext context, DeviceData device) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Options
              _buildBottomSheetOption(
                'Refresh',
                Icons.refresh,
                const Color(0xFF0052cc),
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Device refreshed')),
                  );
                },
              ),
              _buildBottomSheetOption(
                'Restore to factory',
                Icons.restore,
                const Color(0xFF0052cc),
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Restoring to factory settings...')),
                  );
                },
              ),
              _buildBottomSheetOption(
                'Upgrade firmware',
                Icons.system_update,
                const Color(0xFF0052cc),
                () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Checking for updates...')),
                  );
                },
              ),
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              _buildBottomSheetOption(
                'Delete device',
                Icons.delete_outline,
                const Color(0xFFFF6B6B),
                () {
                  Navigator.pop(context);
                  _showDeleteConfirmation(context, device);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption(
    String label,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: color,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context, DeviceData device) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Icon
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF6B6B).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Color(0xFFFF6B6B),
                    size: 32,
                  ),
                ),
                const SizedBox(height: 16),
                // Title
                const Text(
                  'Delete Device?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF14103B),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 12),
                // Description
                Text(
                  'Are you sure you want to delete "${device.name}"? This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF666666),
                    fontFamily: 'Inter',
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFF5F5F5),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF14103B),
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('${device.name} deleted successfully'),
                              backgroundColor: const Color(0xFF51CF66),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFF6B6B),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Text(
                          'Delete',
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
              ],
            ),
          ),
        );
      },
    );
  }
}

class WaterLevelIndicator extends StatelessWidget {
  final int level;

  const WaterLevelIndicator({Key? key, required this.level}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 60,
      height: 100,
      child: CustomPaint(
        painter: WaterTankPainter(level: level),
      ),
    );
  }
}

class WaterTankPainter extends CustomPainter {
  final int level;

  WaterTankPainter({required this.level});

  @override
  void paint(Canvas canvas, Size size) {
    // Tank outline
    final tankPaint = Paint()
      ..color = const Color(0xFFE8F0FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final tankRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(8, 10, size.width - 16, size.height - 20),
      const Radius.circular(8),
    );
    canvas.drawRRect(tankRect, tankPaint);

    // Water fill
    final waterHeight = (size.height - 20) * (level / 100);
    final waterPaint = Paint()
      ..color = const Color(0xFF0052cc)
      ..style = PaintingStyle.fill;

    final waterRect = Rect.fromLTWH(
      10,
      size.height - 10 - waterHeight,
      size.width - 20,
      waterHeight,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(waterRect, const Radius.circular(6)),
      waterPaint,
    );

    // Water level indicator dot
    final dotY = size.height - 10 - waterHeight;
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, dotY), 4, dotPaint);

    // Dashed line
    final linePaint = Paint()
      ..color = const Color(0xFF0052cc)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final dashWidth = 2;
    final dashSpace = 2;
    double startY = 15;
    while (startY < size.height - 15) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashWidth),
        linePaint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(WaterTankPainter oldDelegate) {
    return oldDelegate.level != level;
  }
}

class DeviceData {
  final int id;
  final String deviceKey;
  final String name;
  final String status;
  final Color statusColor;
  final String healthStatus;
  final Color healthColor;
  final String incomingWaterLead;
  final String incomingWaterLeadSafe;
  final String incomingWaterMercury;
  final String incomingWaterMercurySafe;
  final String outgoingWaterLead;
  final String outgoingWaterLeadSafe;
  final String outgoingWaterMercury;
  final String outgoingWaterMercurySafe;
  final int waterLevel;

  DeviceData({
    this.id = 0,
    this.deviceKey = '',
    required this.name,
    required this.status,
    required this.statusColor,
    required this.healthStatus,
    required this.healthColor,
    required this.incomingWaterLead,
    required this.incomingWaterLeadSafe,
    required this.incomingWaterMercury,
    required this.incomingWaterMercurySafe,
    required this.outgoingWaterLead,
    required this.outgoingWaterLeadSafe,
    required this.outgoingWaterMercury,
    required this.outgoingWaterMercurySafe,
    required this.waterLevel,
  });
}
