import 'package:flutter/material.dart';
import 'home_screen.dart';
import '../../services/api_service.dart';
import '../../widgets/shimmer_widget.dart';

class DeviceInfoScreen extends StatefulWidget {
  final DeviceData device;

  const DeviceInfoScreen({Key? key, required this.device}) : super(key: key);

  @override
  State<DeviceInfoScreen> createState() => _DeviceInfoScreenState();
}

class _DeviceInfoScreenState extends State<DeviceInfoScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  Map<String, dynamic>? _sensorData;
  Map<String, dynamic>? _contaminants;
  List<Map<String, dynamic>> _commands = [];
  Map<String, dynamic>? _deviceStatus;
  bool _isLoadingSensors = true;
  bool _isLoadingCommands = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() => setState(() {}));

    final hasSensorCache =
        ApiService.isCacheValid('sensor_device_${widget.device.id}');
    _isLoadingSensors = !hasSensorCache;
    _loadSensorData();
    _loadCommandHistory();
    _loadDeviceStatus();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSensorData() async {
    try {
      final data =
          await ApiService.getLatestSensorDataByDevice(widget.device.id);
      if (mounted) {
        setState(() {
          _sensorData = data?['sensor_data'] as Map<String, dynamic>?;
          _contaminants = data?['contaminants'] as Map<String, dynamic>?;
          _isLoadingSensors = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingSensors = false);
    }
  }

  Future<void> _loadCommandHistory() async {
    try {
      final list =
          await ApiService.getCommandHistory(widget.device.id);
      if (mounted) setState(() { _commands = list; _isLoadingCommands = false; });
    } catch (_) {
      if (mounted) setState(() => _isLoadingCommands = false);
    }
  }

  Future<void> _loadDeviceStatus() async {
    try {
      final status = await ApiService.getDeviceStatus(widget.device.deviceKey);
      if (mounted) setState(() => _deviceStatus = status);
    } catch (_) {
      // Info tooltip just omits Wi-Fi/MQTT rows if this fails.
    }
  }

  Future<void> _sendMeasureNowCommand() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ApiService.sendCommand(
          deviceId: widget.device.id, commandType: 'measure_now');
      ApiService.invalidate('sensor_device_${widget.device.id}');
      ApiService.invalidate('commands_${widget.device.id}');
      _loadCommandHistory();
      messenger.showSnackBar(
        const SnackBar(content: Text('Measurement requested')),
      );
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  // ─── Health calculations ───────────────────────────────────────────────────

  int _phHealth(num? ph) {
    if (ph == null) return 0;
    final v = ph.toDouble();
    if (v >= 6.5 && v <= 8.5) return 100;
    if (v < 6.5) return (v / 6.5 * 100).clamp(0, 100).toInt();
    return (8.5 / v * 100).clamp(0, 100).toInt();
  }

  int _tdsHealth(num? tds) {
    if (tds == null) return 0;
    final v = tds.toDouble();
    if (v <= 500) return 100;
    return (500 / v * 100).clamp(0, 100).toInt();
  }

  int _turbidityHealth(num? turbidity) {
    if (turbidity == null) return 0;
    final v = turbidity.toDouble();
    if (v <= 4) return 100;
    return (4 / v * 100).clamp(0, 100).toInt();
  }

  int _contaminantHealth(num? mgL, double limitMgL) {
    if (mgL == null) return 0;
    final v = mgL.toDouble();
    if (v <= 0) return 100;
    return ((1 - v / limitMgL) * 100).clamp(0, 100).toInt();
  }

  Color _healthColor(int pct) {
    if (pct >= 80) return const Color(0xFF51CF66);
    if (pct >= 50) return const Color(0xFFFF9500);
    return const Color(0xFFFF6B6B);
  }

  List<Widget> _withSpacing(List<Widget> items, double gap) {
    final out = <Widget>[];
    for (var i = 0; i < items.length; i++) {
      if (i > 0) out.add(SizedBox(height: gap));
      out.add(items[i]);
    }
    return out;
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  String _formatCommandTime(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      final d = dt.day.toString().padLeft(2, '0');
      final mo = dt.month.toString().padLeft(2, '0');
      final h = dt.hour.toString().padLeft(2, '0');
      final mi = dt.minute.toString().padLeft(2, '0');
      return '$d.$mo.${dt.year} at $h:$mi';
    } catch (_) {
      return '';
    }
  }

  String _commandLabel(String? type) {
    switch (type) {
      case 'measure_now': return 'Measure Now';
      case 'start_pump': return 'Pump ON';
      case 'stop_pump': return 'Pump OFF';
      case 'calibrate': return 'Calibrate';
      case 'restart': return 'Restart';
      case 'update_firmware': return 'Firmware Update';
      case 'set_interval': return 'Set Interval';
      default: return type ?? 'Command';
    }
  }

  bool _isPumpOn(String? type) => type == 'start_pump';

  bool _isPumpCommand(String? type) =>
      type == 'start_pump' || type == 'stop_pump';

  // Pump commands use a persistent ON/OFF state; every other command type
  // (measure_now, etc.) is colored by its actual lifecycle status instead,
  // since it has no firmware ack today and would otherwise always render red.
  Color _commandStatusColor(String? type, String status, bool isOn) {
    if (_isPumpCommand(type)) {
      return isOn ? const Color(0xFF51CF66) : const Color(0xFFFF6B6B);
    }
    switch (status) {
      case 'acknowledged': return const Color(0xFF51CF66);
      case 'failed': return const Color(0xFFFF6B6B);
      default: return const Color(0xFFFF9500); // pending
    }
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
            onPressed: () => _showDeviceOptionsMenu(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Hero section
          Container(
            color: const Color(0xFF14103B),
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
            child: Stack(
              children: [
                Positioned(
                  top: -400, right: -400,
                  child: Opacity(
                    opacity: 0.15,
                    child: Image.asset('assets/watermark.png',
                        width: 1600, height: 1600, fit: BoxFit.contain),
                  ),
                ),
                Positioned(
                  bottom: -500, right: -350,
                  child: Opacity(
                    opacity: 0.12,
                    child: Image.asset('assets/watermark.png',
                        width: 1400, height: 1400, fit: BoxFit.contain),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            widget.device.name,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontFamily: 'Inter',
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _showInfoTooltip(context),
                          child: Container(
                            width: 28, height: 28,
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: Colors.white.withValues(alpha: 0.3),
                                  width: 1),
                            ),
                            child: const Icon(Icons.info_outlined,
                                color: Colors.white, size: 16),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                              color: widget.device.statusColor,
                              shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text(widget.device.status,
                            style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                                fontFamily: 'Inter')),
                        const SizedBox(width: 16),
                        Container(
                          width: 6, height: 6,
                          decoration: BoxDecoration(
                              color: widget.device.healthColor,
                              shape: BoxShape.circle),
                        ),
                        const SizedBox(width: 6),
                        Text(widget.device.healthStatus,
                            style: TextStyle(
                                fontSize: 12,
                                color: widget.device.healthColor,
                                fontFamily: 'Inter')),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Key: ${widget.device.deviceKey}',
                      style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFFB0C4FF),
                          fontFamily: 'Inter'),
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
                  _buildTabButton('Sensors', 0),
                  _buildTabButton('Pump', 1),
                  _buildTabButton('Tank', 2),
                ],
              ),
            ),
          ),
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildSensorsTab(),
                _buildPumpTab(),
                _buildTankTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton(String label, int index) {
    final active = _tabController.index == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => _tabController.animateTo(index),
        child: Container(
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: active ? const Color(0xFF14103B) : const Color(0xFFCCCCCC),
              fontFamily: 'Inter',
            ),
          ),
        ),
      ),
    );
  }

  // ─── Sensors Tab ──────────────────────────────────────────────────────────

  Widget _buildSensorsTab() {
    if (_isLoadingSensors) {
      return ListView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        children: const [
          ShimmerBox(width: double.infinity, height: 180, radius: 12),
          SizedBox(height: 20),
          ShimmerBox(width: double.infinity, height: 120, radius: 12),
          SizedBox(height: 16),
          ShimmerBox(width: double.infinity, height: 120, radius: 12),
          SizedBox(height: 16),
          ShimmerBox(width: double.infinity, height: 120, radius: 12),
        ],
      );
    }

    if (_sensorData == null) {
      return const Center(
        child: Text('No sensor data available',
            style: TextStyle(color: Color(0xFFAAAAAA), fontFamily: 'Inter')),
      );
    }

    final ph = _sensorData!['ph_level'] as num?;
    final tds = _sensorData!['tds_level'] as num?;
    final turbidity = _sensorData!['turbidity'] as num?;
    final temperature = _sensorData!['temperature'] as num?;
    final chlorine = _sensorData!['chlorine_level'] as num?;
    final waterLiters = _sensorData!['water_level_liters'] as num?;
    final waterPct = _sensorData!['water_level_percentage'] as num?;
    final pStatus = _sensorData!['purification_status'] as String? ?? '';

    // This PCB's 7 ion-selective electrodes report these via
    // contaminant_readings — see purification-aws iot.routes.js CONTAMINANT_MAP.
    final nitrate = _contaminants?['nitrate'] as num?;
    final calcium = _contaminants?['calcium'] as num?;
    final potassium = _contaminants?['potassium'] as num?;
    final sodium = _contaminants?['sodium'] as num?;
    final ammonium = _contaminants?['ammonium'] as num?;
    final magnesium = _contaminants?['magnesium'] as num?;

    // WHO limits: chlorine 5 mg/L, nitrate 50 mg/L (matches backend seed data).
    // Calcium/potassium/sodium/ammonium/magnesium have no WHO health-based
    // drinking-water limit, so they're shown as informational readings only.
    final chlorineH = _contaminantHealth(chlorine, 5.0);
    final nitrateH = _contaminantHealth(nitrate, 50.0);

    final healthBars = <Widget>[
      _buildHealthBar(
          'pH Level', _phHealth(ph), _healthColor(_phHealth(ph))),
    ];
    if (chlorine != null) {
      healthBars
          .add(_buildHealthBar('Chlorine', chlorineH, _healthColor(chlorineH)));
    }
    if (nitrate != null) {
      healthBars
          .add(_buildHealthBar('Nitrate', nitrateH, _healthColor(nitrateH)));
    }
    if (tds != null) {
      healthBars.add(_buildHealthBar(
          'TDS Level', _tdsHealth(tds), _healthColor(_tdsHealth(tds))));
    }
    if (turbidity != null) {
      healthBars.add(_buildHealthBar('Turbidity', _turbidityHealth(turbidity),
          _healthColor(_turbidityHealth(turbidity))));
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─ Health Overview ─
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border:
                  Border.all(color: const Color(0xFFEEEEEE), width: 1),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Water Quality Health',
                    style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF14103B),
                        fontFamily: 'Inter')),
                const SizedBox(height: 16),
                ..._withSpacing(healthBars, 12),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Health Score',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFCCCCCC),
                            fontFamily: 'Inter')),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: pStatus == 'safe'
                            ? const Color(0xFF51CF66).withValues(alpha: 0.1)
                            : const Color(0xFFFF6B6B).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        pStatus == 'safe' ? 'SAFE' : 'UNSAFE',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: pStatus == 'safe'
                              ? const Color(0xFF51CF66)
                              : const Color(0xFFFF6B6B),
                          fontFamily: 'Inter',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Water Quality Readings',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFCCCCCC),
                  fontFamily: 'Inter')),
          const SizedBox(height: 12),
          _buildReadingCard('pH Level', ph?.toStringAsFixed(2) ?? '—',
              'Safe: 6.5–8.5',
              ph != null && ph >= 6.5 && ph <= 8.5),
          const SizedBox(height: 12),
          _buildReadingCard('TDS Level',
              tds != null ? '${tds.toStringAsFixed(0)} ppm' : '—',
              'Safe: ≤ 500 ppm',
              tds != null && tds <= 500),
          const SizedBox(height: 12),
          _buildReadingCard('Turbidity',
              turbidity != null ? '${turbidity.toStringAsFixed(2)} NTU' : '—',
              'Safe: ≤ 4 NTU',
              turbidity != null && turbidity <= 4),
          const SizedBox(height: 12),
          _buildReadingCard('Temperature',
              temperature != null ? '${temperature.toStringAsFixed(1)} °C' : '—',
              'Normal: 20–30 °C',
              temperature != null && temperature >= 20 && temperature <= 30),
          const SizedBox(height: 12),
          _buildReadingCard('Chlorine',
              chlorine != null ? '${chlorine.toStringAsFixed(2)} mg/L' : '—',
              'Safe: 0.2–1.0 mg/L',
              chlorine != null && chlorine >= 0.2 && chlorine <= 1.0),
          const SizedBox(height: 12),
          _buildReadingCard('Water Level',
              waterPct != null
                  ? '${waterPct.toStringAsFixed(1)}%${waterLiters != null ? '  (${waterLiters.toStringAsFixed(0)} L)' : ''}'
                  : '—',
              'Current tank level', true,
              isInfo: true),
          const SizedBox(height: 24),
          const Text('Contaminant Readings',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFCCCCCC),
                  fontFamily: 'Inter')),
          const SizedBox(height: 12),
          _buildReadingCard('Nitrate (NO3⁻)',
              nitrate != null ? '${nitrate.toStringAsFixed(2)} mg/L' : '—',
              'WHO limit: 50 mg/L',
              nitrate == null || nitrate <= 50),
          const SizedBox(height: 12),
          _buildReadingCard('Calcium (Ca²⁺)',
              calcium != null ? '${calcium.toStringAsFixed(2)} ppm' : '—',
              'Informational — no WHO limit', true,
              isInfo: true),
          const SizedBox(height: 12),
          _buildReadingCard('Potassium (K⁺)',
              potassium != null ? '${potassium.toStringAsFixed(2)} ppm' : '—',
              'Informational — no WHO limit', true,
              isInfo: true),
          const SizedBox(height: 12),
          _buildReadingCard('Sodium (Na⁺)',
              sodium != null ? '${sodium.toStringAsFixed(2)} ppm' : '—',
              'Informational — no WHO limit', true,
              isInfo: true),
          const SizedBox(height: 12),
          _buildReadingCard('Ammonium (NH4⁺)',
              ammonium != null ? '${ammonium.toStringAsFixed(2)} ppm' : '—',
              'Informational — no WHO limit', true,
              isInfo: true),
          const SizedBox(height: 12),
          _buildReadingCard('Magnesium (Mg²⁺)',
              magnesium != null
                  ? '${magnesium.toStringAsFixed(2)} ppm'
                  : '—',
              'Typical: 10–50 ppm', true,
              isInfo: true),
        ],
      ),
    );
  }

  Widget _buildHealthBar(String label, int pct, Color color) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label,
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF14103B),
                  fontFamily: 'Inter')),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct / 100,
              minHeight: 8,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 36,
          child: Text('$pct%',
              textAlign: TextAlign.right,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                  fontFamily: 'Inter')),
        ),
      ],
    );
  }

  Widget _buildReadingCard(
      String label, String value, String hint, bool isSafe,
      {bool isInfo = false}) {
    final safeColor = isInfo
        ? const Color(0xFF0052cc)
        : (isSafe ? const Color(0xFF51CF66) : const Color(0xFFFF6B6B));
    final safeLabel = isInfo ? '' : (isSafe ? 'SAFE' : 'UNSAFE');

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label,
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF14103B),
                      fontFamily: 'Inter')),
              const SizedBox(height: 4),
              Text(hint,
                  style: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFFAAAAAA),
                      fontFamily: 'Inter')),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF0052cc),
                      fontFamily: 'Inter')),
              if (safeLabel.isNotEmpty)
                Text(safeLabel,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: safeColor,
                        fontFamily: 'Inter')),
            ],
          ),
        ],
      ),
    );
  }

  // ─── Pump Tab ─────────────────────────────────────────────────────────────

  Widget _buildPumpTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Pump control — not implemented by this device's current firmware
          // (Firmware.md has no relay/pump driver code), shown disabled
          // rather than sending a command the device will silently ignore.
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
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
                        'Pump control',
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFFAAAAAA),
                            fontFamily: 'Inter'),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Not supported by this device\'s current firmware',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFAAAAAA),
                            fontFamily: 'Inter'),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 0.85,
                  child: Switch(
                    value: false,
                    onChanged: null,
                    inactiveThumbColor: const Color(0xFFDDDDDD),
                    inactiveTrackColor: const Color(0xFFEEEEEE),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          // Measure Now — the one command this firmware actually handles
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFE8F0FF),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Take a measurement',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF14103B),
                            fontFamily: 'Inter'),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Requests a fresh sensor reading from the device',
                        style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF666666),
                            fontFamily: 'Inter'),
                      ),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: _sendMeasureNowCommand,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0052cc),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Measure Now',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Inter')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Command History
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFFAFAFA),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Command History',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF14103B),
                        fontFamily: 'Inter')),
                const SizedBox(height: 4),
                const Text(
                  'Recent commands sent to this device',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFAAAAAA),
                      fontFamily: 'Inter'),
                ),
                const SizedBox(height: 16),
                if (_isLoadingCommands)
                  Column(children: [
                    const NotificationItemSkeleton(),
                    const SizedBox(height: 12),
                    const NotificationItemSkeleton(),
                  ])
                else if (_commands.isEmpty)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Text('No command history',
                          style: TextStyle(
                              fontSize: 13,
                              color: Color(0xFFAAAAAA),
                              fontFamily: 'Inter')),
                    ),
                  )
                else
                  ...(_commands.take(10).map((cmd) {
                    final type = cmd['command_type'] as String?;
                    final time = _formatCommandTime(
                        cmd['created_at'] as String?);
                    final status = cmd['status'] as String? ?? '';
                    final isOn = _isPumpOn(type);
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildHistoryItem(
                          _commandLabel(type), time, type, isOn, status),
                    );
                  }).toList()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryItem(
      String label, String time, String? type, bool isOn, String status) {
    final color = _commandStatusColor(type, status, isOn);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF14103B),
                    fontFamily: 'Inter')),
            const SizedBox(height: 2),
            Text(time,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFAAAAAA),
                    fontFamily: 'Inter')),
          ],
        ),
        Row(
          children: [
            Container(
              width: 6, height: 6,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              status.isNotEmpty
                  ? status
                  : (_isPumpCommand(type) ? (isOn ? 'ON' : 'OFF') : ''),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: color,
                  fontFamily: 'Inter'),
            ),
          ],
        ),
      ],
    );
  }

  // ─── Tank Tab ─────────────────────────────────────────────────────────────

  Widget _buildTankTab() {
    final waterLiters = _sensorData?['water_level_liters'] as num?;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Current water level',
              style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14103B),
                  fontFamily: 'Inter')),
          const SizedBox(height: 24),
          Center(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                            fontFamily: 'Inter'),
                      ),
                      const Text('water level',
                          style: TextStyle(
                              fontSize: 11,
                              color: Color(0xFF0052cc),
                              fontFamily: 'Inter')),
                      if (waterLiters != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${waterLiters.toStringAsFixed(0)} L',
                          style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF0052cc),
                              fontFamily: 'Inter'),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: 120, height: 180,
                  child: CustomPaint(
                    painter: TankVisualizerPainter(
                        level: widget.device.waterLevel),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          const Divider(color: Color(0xFFEEEEEE), height: 1),
          const SizedBox(height: 24),
          // Device key info
          _buildInfoRow('Device Key', widget.device.deviceKey),
          const SizedBox(height: 12),
          _buildInfoRow('Status', widget.device.status),
          const SizedBox(height: 12),
          _buildInfoRow('Health', widget.device.healthStatus),
          if (waterLiters != null) ...[
            const SizedBox(height: 12),
            _buildInfoRow(
                'Water Volume', '${waterLiters.toStringAsFixed(1)} L'),
          ],
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF999999),
                fontFamily: 'Inter')),
        Text(value,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF14103B),
                fontFamily: 'Inter')),
      ],
    );
  }

  // ─── Menus / dialogs ──────────────────────────────────────────────────────

  void _showDeviceOptionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Container(
                width: 40, height: 4,
                decoration: BoxDecoration(
                    color: const Color(0xFFDDDDDD),
                    borderRadius: BorderRadius.circular(2)),
              ),
            ),
            _buildMenuOption('Measure Now', Icons.science_outlined,
                const Color(0xFF0052cc), () {
              Navigator.pop(context);
              _sendMeasureNowCommand();
            }),
            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            _buildMenuOption('Refresh sensor data', Icons.refresh,
                const Color(0xFF0052cc), () {
              Navigator.pop(context);
              ApiService.invalidate('sensor_device_${widget.device.id}');
              setState(() => _isLoadingSensors = true);
              _loadSensorData();
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption(
      String label, IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 16),
            Text(label,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: color,
                    fontFamily: 'Inter')),
          ],
        ),
      ),
    );
  }

  void _showInfoTooltip(BuildContext context) {
    final heartbeatPayload =
        _deviceStatus?['last_heartbeat']?['payload'] as Map<String, dynamic>?;
    final wifiRssi = heartbeatPayload?['wifi_rssi'];
    final mqttConnected = heartbeatPayload?['mqtt_connected'];

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.device.name,
            style: const TextStyle(fontFamily: 'Inter')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Device Key: ${widget.device.deviceKey}',
                style: const TextStyle(
                    fontSize: 13, fontFamily: 'Inter')),
            const SizedBox(height: 8),
            Text('Status: ${widget.device.status}',
                style: const TextStyle(
                    fontSize: 13, fontFamily: 'Inter')),
            const SizedBox(height: 8),
            Text('Health: ${widget.device.healthStatus}',
                style: const TextStyle(
                    fontSize: 13, fontFamily: 'Inter')),
            if (wifiRssi != null) ...[
              const SizedBox(height: 8),
              Text('Wi-Fi signal: $wifiRssi dBm',
                  style: const TextStyle(
                      fontSize: 13, fontFamily: 'Inter')),
            ],
            if (mqttConnected != null) ...[
              const SizedBox(height: 8),
              Text('MQTT: ${mqttConnected == true ? 'Connected' : 'Disconnected'}',
                  style: const TextStyle(
                      fontSize: 13, fontFamily: 'Inter')),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// ─── Tank visualizer ──────────────────────────────────────────────────────────

class TankVisualizerPainter extends CustomPainter {
  final int level;

  TankVisualizerPainter({required this.level});

  @override
  void paint(Canvas canvas, Size size) {
    final tankPaint = Paint()
      ..color = const Color(0xFFE8F0FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final tankRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(10, 20, size.width - 20, size.height - 40),
      const Radius.circular(12),
    );
    canvas.drawRRect(tankRect, tankPaint);

    final waterHeight = (size.height - 40) * (level / 100);
    final waterPaint = Paint()
      ..color = const Color(0xFF0052cc)
      ..style = PaintingStyle.fill;

    final waterRect = Rect.fromLTWH(
        10, size.height - 20 - waterHeight, size.width - 20, waterHeight);
    canvas.drawRRect(
      RRect.fromRectAndRadius(waterRect, const Radius.circular(10)),
      waterPaint,
    );

    final dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(
        Offset(size.width / 2, size.height - 20 - waterHeight), 5, dotPaint);

    final linePaint = Paint()
      ..color = const Color(0xFF0052cc)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    double startY = 25;
    while (startY < size.height - 25) {
      canvas.drawLine(Offset(size.width / 2, startY),
          Offset(size.width / 2, startY + 2), linePaint);
      startY += 4;
    }
  }

  @override
  bool shouldRepaint(TankVisualizerPainter oldDelegate) =>
      oldDelegate.level != level;
}
