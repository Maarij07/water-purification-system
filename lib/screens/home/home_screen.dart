import 'package:flutter/material.dart';
import '../../widgets/common_app_bar.dart';
import '../../widgets/common_drawer.dart';
import 'device_info_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<DeviceData> devices = [
    DeviceData(
      name: 'My Device 1, London SW1A 1AA',
      status: 'Online',
      statusColor: const Color(0xFF0052cc),
      healthStatus: 'Not Healthy',
      healthColor: const Color(0xFFFF6B6B),
      pumpOn: false,
      incomingWaterLead: '5460 μg/L',
      incomingWaterLeadSafe: '-140 μg/L',
      incomingWaterMercury: '460 μg/L',
      incomingWaterMercurySafe: '-120 μg/L',
      outgoingWaterLead: '5010 μg/L',
      outgoingWaterLeadSafe: '-10 μg/L',
      outgoingWaterMercury: '40 μg/L',
      outgoingWaterMercurySafe: '-10 μg/L',
      waterLevel: 25,
    ),
    DeviceData(
      name: 'My Device 2, Manchester M1 1AE',
      status: 'Online',
      statusColor: const Color(0xFF0052cc),
      healthStatus: 'Healthy',
      healthColor: const Color(0xFF51CF66),
      pumpOn: true,
      incomingWaterLead: '5460 μg/L',
      incomingWaterLeadSafe: '-140 μg/L',
      incomingWaterMercury: '460 μg/L',
      incomingWaterMercurySafe: '-400 μg/L',
      outgoingWaterLead: '5010 μg/L',
      outgoingWaterLeadSafe: '-10 μg/L',
      outgoingWaterMercury: '40 μg/L',
      outgoingWaterMercurySafe: '-10 μg/L',
      waterLevel: 98,
    ),
  ];

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: CommonAppBar(scaffoldKey: _scaffoldKey),
      drawer: CommonDrawer(scaffoldKey: _scaffoldKey, currentRoute: '/home'),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: devices.length,
        itemBuilder: (context, index) {
          return DeviceCard(device: devices[index]);
        },
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
  late bool pumpOn;

  @override
  void initState() {
    super.initState();
    pumpOn = widget.device.pumpOn;
  }

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
              // Pump control
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pumpOn ? 'Turn ON the pump' : 'Turn OFF the pump',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF14103B),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Press to manually turn off the pump',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFAAAAAA),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                  Transform.scale(
                    scale: 0.85,
                    child: Switch(
                      value: pumpOn,
                      onChanged: (value) {
                        setState(() {
                          pumpOn = value;
                        });
                      },
                      activeColor: const Color(0xFF51CF66),
                      inactiveThumbColor: const Color(0xFFDDDDDD),
                      inactiveTrackColor: const Color(0xFFEEEEEE),
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
                          'Lead (Pb²⁺)',
                          widget.device.incomingWaterLead,
                          widget.device.incomingWaterLeadSafe,
                        ),
                        const SizedBox(height: 4),
                        _buildWaterQualityRow(
                          'Mercury (Hg²⁺)',
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
                          'Lead (Pb²⁺)',
                          widget.device.outgoingWaterLead,
                          widget.device.outgoingWaterLeadSafe,
                        ),
                        const SizedBox(height: 4),
                        _buildWaterQualityRow(
                          'Mercury (Hg²⁺)',
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
  final String name;
  final String status;
  final Color statusColor;
  final String healthStatus;
  final Color healthColor;
  final bool pumpOn;
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
    required this.name,
    required this.status,
    required this.statusColor,
    required this.healthStatus,
    required this.healthColor,
    required this.pumpOn,
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
