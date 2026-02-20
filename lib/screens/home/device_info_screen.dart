import 'package:flutter/material.dart';
import 'home_screen.dart';

class DeviceInfoScreen extends StatefulWidget {
  final DeviceData device;

  const DeviceInfoScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool pumpOn;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
    pumpOn = widget.device.pumpOn;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

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
        title: const Text(
          'Device info',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white, size: 24),
            onPressed: () {
              _showDeviceOptionsMenu(context);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Hero section with device info
          Container(
            color: const Color(0xFF14103B),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
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
                // Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Component name
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Component name 1',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                            fontFamily: 'Inter',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _showInfoTooltip(context);
                          },
                          child: Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: const Icon(
                              Icons.info_outlined,
                              color: Colors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Status
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
                            color: Colors.white,
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
                    const SizedBox(height: 8),
                    // Location
                    const Text(
                      'Home Name',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFB0C4FF),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(4),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _tabController.animateTo(0);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _tabController.index == 0 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Sensors',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _tabController.index == 0
                                ? const Color(0xFF14103B)
                                : const Color(0xFFCCCCCC),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _tabController.animateTo(1);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _tabController.index == 1 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Pump',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _tabController.index == 1
                                ? const Color(0xFF14103B)
                                : const Color(0xFFCCCCCC),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        _tabController.animateTo(2);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _tabController.index == 2 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Tank',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _tabController.index == 2
                                ? const Color(0xFF14103B)
                                : const Color(0xFFCCCCCC),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Sensors Tab
                _buildSensorsTab(),
                // Pump Tab
                _buildPumpTab(),
                // Tank Tab
                _buildTankTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSensorsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Health Score Chart
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFEEEEEE),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Pump Sensor
                _buildHealthBar('Pump Sensor', 95, const Color(0xFF0052cc)),
                const SizedBox(height: 12),
                // Sensor 1
                _buildHealthBar('Sensor 1', 30, const Color(0xFFFF6B6B)),
                const SizedBox(height: 12),
                // Sensor 2
                _buildHealthBar('Sensor 2', 85, const Color(0xFF51CF66)),
                const SizedBox(height: 12),
                // Sensor 3
                _buildHealthBar('Sensor 3', 60, const Color(0xFFFF9500)),
                const SizedBox(height: 12),
                // Sensor 4
                _buildHealthBar('Sensor 4', 75, const Color(0xFF51CF66)),
                const SizedBox(height: 12),
                // Sensor 5
                _buildHealthBar('Sensor 5', 90, const Color(0xFF51CF66)),
                const SizedBox(height: 12),
                // Sensor 6
                _buildHealthBar('Sensor 6', 95, const Color(0xFF51CF66)),
                const SizedBox(height: 16),
                // Health Score scale
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Health Score',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFCCCCCC),
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      '0',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFCCCCCC),
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      '20',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFCCCCCC),
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      '40',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFCCCCCC),
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      '60',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFCCCCCC),
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      '80',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFCCCCCC),
                        fontFamily: 'Inter',
                      ),
                    ),
                    Text(
                      '100',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFFCCCCCC),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Liquid Level Sensor',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFFCCCCCC),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          // Sensor 1
          _buildSensorCard(
            'Sensor 1',
            'Not Healthy',
            const Color(0xFFFF6B6B),
            '100%',
            'Strong signal',
            '25%',
            '12.12.2024',
            'Bosh',
            '12.12.2024 at 16:48',
          ),
          const SizedBox(height: 16),
          // Sensor 2
          _buildSensorCard(
            'Sensor 2',
            'Healthy',
            const Color(0xFF51CF66),
            '95%',
            'Strong signal',
            '45%',
            '10.11.2024',
            'Siemens',
            '11.12.2024 at 14:30',
          ),
          const SizedBox(height: 16),
          // Sensor 3
          _buildSensorCard(
            'Sensor 3',
            'Healthy',
            const Color(0xFF51CF66),
            '88%',
            'Strong signal',
            '60%',
            '08.10.2024',
            'Honeywell',
            '10.12.2024 at 10:15',
          ),
          const SizedBox(height: 16),
          // Sensor 4
          _buildSensorCard(
            'Sensor 4',
            'Not Healthy',
            const Color(0xFFFF6B6B),
            '65%',
            'Weak signal',
            '35%',
            '15.09.2024',
            'Bosh',
            '09.12.2024 at 09:45',
          ),
          const SizedBox(height: 16),
          // Sensor 5
          _buildSensorCard(
            'Sensor 5',
            'Healthy',
            const Color(0xFF51CF66),
            '92%',
            'Strong signal',
            '70%',
            '20.08.2024',
            'Schneider',
            '08.12.2024 at 15:20',
          ),
          const SizedBox(height: 16),
          // Sensor 6
          _buildSensorCard(
            'Sensor 6',
            'Healthy',
            const Color(0xFF51CF66),
            '98%',
            'Strong signal',
            '80%',
            '05.07.2024',
            'ABB',
            '07.12.2024 at 11:30',
          ),
        ],
      ),
    );
  }

  Widget _buildSensorCard(
    String sensorName,
    String healthStatus,
    Color healthColor,
    String signalStrength,
    String signalQuality,
    String waterLevel,
    String installationDate,
    String manufacturer,
    String calibrationDate,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFEEEEEE),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sensor name
          Text(
            sensorName,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF14103B),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          // Status row
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: healthColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                healthStatus,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: healthColor,
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(width: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF51CF66).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  signalStrength,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF51CF66),
                    fontFamily: 'Inter',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.water_drop, color: Color(0xFF0052cc), size: 16),
              const SizedBox(width: 4),
              Text(
                signalQuality,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0052cc),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFEEEEEE), height: 1),
          const SizedBox(height: 12),
          // Water level
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Water level',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF14103B),
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                waterLevel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF0052cc),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Installation date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Installation date',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF999999),
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                installationDate,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF14103B),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Manufacturer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Manufacture',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF999999),
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                manufacturer,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF14103B),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Last calibration date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Last calibration date',
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF999999),
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                calibrationDate,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF14103B),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Color(0xFFEEEEEE), height: 1),
          const SizedBox(height: 12),
          // Refresh button
          Center(
            child: GestureDetector(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Sensor refreshed')),
                );
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.refresh, color: Color(0xFF0052cc), size: 18),
                  SizedBox(width: 6),
                  Text(
                    'Refresh sensor',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0052cc),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPumpTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Turn OFF the pump
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Turn OFF the pump',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF14103B),
                        fontFamily: 'Inter',
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
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
          ),
          const SizedBox(height: 20),
          // Control list
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFEEEEEE),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Control list',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF14103B),
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Take control of who can access your pump!',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFAAAAAA),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F0FF),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.add, color: Color(0xFF0052cc), size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // User 1 with swipe to delete
                Dismissible(
                  key: const Key('user_lois_becket'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
                  ),
                  onDismissed: (direction) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Lois Becket removed from control list')),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFEEEEEE),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B9FFF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Lois Becket',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF14103B),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Basic Control',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFAAAAAA),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: Color(0xFFCCCCCC), size: 18),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                // User 2 with swipe to delete
                Dismissible(
                  key: const Key('user_wade_warren'),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(Icons.delete_outline, color: Colors.white, size: 20),
                  ),
                  onDismissed: (direction) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Wade Warren removed from control list')),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: const Color(0xFFEEEEEE),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: const Color(0xFF6B9FFF),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.person, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                'Wade Warren',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF14103B),
                                  fontFamily: 'Inter',
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'View only',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFAAAAAA),
                                  fontFamily: 'Inter',
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.more_vert, color: Color(0xFFCCCCCC), size: 18),
                          onPressed: () {},
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Pump On/Off History
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: const Color(0xFFEEEEEE),
                width: 1,
              ),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Pump On/Off History',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF14103B),
                            fontFamily: 'Inter',
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'It is a long established fact that a reader will',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFAAAAAA),
                            fontFamily: 'Inter',
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const HistoryFilterScreen(),
                          ),
                        );
                      },
                      child: const Icon(Icons.tune, color: Color(0xFF0052cc), size: 20),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Search bar
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FF),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  child: Row(
                    children: [
                      const Icon(Icons.search, color: Color(0xFF6B9FFF), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: 'Search',
                            hintStyle: const TextStyle(
                              color: Color(0xFF6B9FFF),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Inter',
                            ),
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                          ),
                          style: const TextStyle(
                            color: Color(0xFF14103B),
                            fontSize: 14,
                            fontFamily: 'Inter',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                // History items
                _buildHistoryItem('Lois Becket', '12.12.2024 at 16:48', true),
                const SizedBox(height: 12),
                _buildHistoryItem('Diana Johnson', '12.12.2024 at 16:48', false),
                const SizedBox(height: 12),
                _buildHistoryItem('Diana Johnson', '12.12.2024 at 16:48', true),
                const SizedBox(height: 12),
                _buildHistoryItem('Pump', '12.12.2024 at 16:48', false),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(String name, String time, bool isOn) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFF14103B),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: const TextStyle(
                fontSize: 11,
                color: Color(0xFFAAAAAA),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: isOn ? const Color(0xFF51CF66) : const Color(0xFFFF6B6B),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              isOn ? 'ON (manual)' : 'OFF (manual)',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isOn ? const Color(0xFF51CF66) : const Color(0xFFFF6B6B),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTankTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Current water level
          const Text(
            'Current water level',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF14103B),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 24),
          // Tank visualization
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE8F0FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
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
                          fontSize: 11,
                          color: Color(0xFF0052cc),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                // Tank container
                SizedBox(
                  width: 120,
                  height: 180,
                  child: CustomPaint(
                    painter: TankVisualizerPainter(level: widget.device.waterLevel),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Minimum water level
          const Text(
            'Minimum water level',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF14103B),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          _buildSlider(20, '20%', '100%', const Color(0xFF0052cc)),
          const SizedBox(height: 32),
          // Maximum water level
          const Text(
            'Maximum water level',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF14103B),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 12),
          _buildSlider(80, '80%', '100%', const Color(0xFF0052cc)),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFFEEEEEE), height: 1),
          const SizedBox(height: 24),
          // Filters section
          const Text(
            'Filters',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: Color(0xFF14103B),
              fontFamily: 'Inter',
            ),
          ),
          const SizedBox(height: 16),
          _buildFilterItem('UV Light Lamp', 'Remaining life of UV bulb', 80, const Color(0xFF51CF66)),
          const SizedBox(height: 16),
          _buildFilterItem('Reverse Osmosis', 'Remaining life of RO membrane', 45, const Color(0xFFFF9500)),
          const SizedBox(height: 16),
          _buildFilterItem('Activated Carbon', 'Remaining life of carbon filter', 15, const Color(0xFFFF6B6B)),
        ],
      ),
    );
  }

  Widget _buildSlider(int value, String minLabel, String maxLabel, Color color) {
    return Column(
      children: [
        SliderTheme(
          data: SliderThemeData(
            trackHeight: 8,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 12),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 0,
            max: 100,
            activeColor: color,
            inactiveColor: const Color(0xFFE8F0FF),
            onChanged: (newValue) {},
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              minLabel,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF0052cc),
                fontFamily: 'Inter',
              ),
            ),
            Text(
              maxLabel,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFFCCCCCC),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterItem(String title, String subtitle, int percentage, Color color) {
    return Column(
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
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: percentage / 100,
                  minHeight: 6,
                  backgroundColor: const Color(0xFFE8F0FF),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '$percentage%',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHealthBar(String label, int percentage, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF14103B),
              fontFamily: 'Inter',
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percentage / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSensorBar(String label, int color, int percentage) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFF666666),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: LinearProgressIndicator(
            value: percentage / 100,
            minHeight: 6,
            backgroundColor: const Color(0xFFEEEEEE),
            valueColor: AlwaysStoppedAnimation<Color>(
              Color(color),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF14103B),
            fontFamily: 'Inter',
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Color(0xFF14103B),
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
}

class TankVisualizerPainter extends CustomPainter {
  final int level;

  TankVisualizerPainter({required this.level});

  @override
  void paint(Canvas canvas, Size size) {
    // Tank outline
    final tankPaint = Paint()
      ..color = const Color(0xFFE8F0FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final tankRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(10, 20, size.width - 20, size.height - 40),
      const Radius.circular(12),
    );
    canvas.drawRRect(tankRect, tankPaint);

    // Water fill
    final waterHeight = (size.height - 40) * (level / 100);
    final waterPaint = Paint()
      ..color = const Color(0xFF0052cc)
      ..style = PaintingStyle.fill;

    final waterRect = Rect.fromLTWH(
      10,
      size.height - 20 - waterHeight,
      size.width - 20,
      waterHeight,
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(waterRect, const Radius.circular(10)),
      waterPaint,
    );

    // Water level indicator dot
    final dotY = size.height - 20 - waterHeight;
    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(size.width / 2, dotY), 5, dotPaint);

    // Dashed line
    final linePaint = Paint()
      ..color = const Color(0xFF0052cc)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    final dashWidth = 2;
    final dashSpace = 2;
    double startY = 25;
    while (startY < size.height - 25) {
      canvas.drawLine(
        Offset(size.width / 2, startY),
        Offset(size.width / 2, startY + dashWidth),
        linePaint,
      );
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(TankVisualizerPainter oldDelegate) {
    return oldDelegate.level != level;
  }
}

class HistoryFilterScreen extends StatefulWidget {
  const HistoryFilterScreen({Key? key}) : super(key: key);

  @override
  State<HistoryFilterScreen> createState() => _HistoryFilterScreenState();
}

class _HistoryFilterScreenState extends State<HistoryFilterScreen> {
  String selectedReason = 'Both';

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
          'History log filter',
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
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Set time period
            const Text(
              'Set time period',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF14103B),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFEEEEEE),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: const Text(
                      '12.12.2024',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF14103B),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  '-',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFFCCCCCC),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFFFAFAFA),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: const Color(0xFFEEEEEE),
                        width: 1,
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: const Text(
                      '12.12.2024',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF14103B),
                        fontFamily: 'Inter',
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            // Select reason for each event
            const Text(
              'Select reason for each event',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF14103B),
                fontFamily: 'Inter',
              ),
            ),
            const SizedBox(height: 16),
            _buildReasonOption('Manual'),
            const SizedBox(height: 16),
            _buildReasonOption('Automatic'),
            const SizedBox(height: 16),
            _buildReasonOption('Both'),
            const SizedBox(height: 60),
            // Apply button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Filter applied')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF001a4d),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Apply',
                  style: TextStyle(
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
    );
  }

  Widget _buildReasonOption(String reason) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedReason = reason;
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            reason,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF14103B),
              fontFamily: 'Inter',
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: selectedReason == reason
                    ? const Color(0xFF0052cc)
                    : const Color(0xFFCCCCCC),
                width: 2,
              ),
            ),
            child: selectedReason == reason
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
    );
  }
}


  void _showDeviceOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildMenuOption(
              icon: Icons.refresh,
              label: 'Refresh',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Device refreshed')),
                );
              },
            ),
            _buildMenuOption(
              icon: Icons.settings_backup_restore,
              label: 'Restore to factory',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Restoring to factory settings...')),
                );
              },
            ),
            _buildMenuOption(
              icon: Icons.upgrade,
              label: 'Upgrade firmware',
              onTap: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Checking for firmware updates...')),
                );
              },
            ),
            _buildMenuOption(
              icon: Icons.delete_outline,
              label: 'Delete device',
              isDestructive: true,
              onTap: () {
                Navigator.pop(context);
                _showDeleteConfirmation(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color: isDestructive ? const Color(0xFFFF6B6B) : const Color(0xFF14103B),
              size: 20,
            ),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDestructive ? const Color(0xFFFF6B6B) : const Color(0xFF14103B),
                fontFamily: 'Inter',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
              const SizedBox(height: 20),
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
              const Text(
                'Are you sure you want to delete this device? This action cannot be undone.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF666666),
                  fontFamily: 'Inter',
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 28),
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
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Device deleted')),
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
      ),
    );
  }

  void _showInfoTooltip(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: const Color(0xFF14103B),
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Device Information',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontFamily: 'Inter',
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInfoRow('Firmware version:', '12341516'),
              const SizedBox(height: 12),
              _buildInfoRow('Last time connected:', '12.12.2024 at 16:49'),
              const SizedBox(height: 12),
              _buildInfoRow('Last time calibrated:', '12.12.2024 at 16:48'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: Color(0xFFB0C4FF),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            fontFamily: 'Inter',
          ),
        ),
      ],
    );
  }
