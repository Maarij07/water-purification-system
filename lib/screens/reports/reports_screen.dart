import 'package:flutter/material.dart';
import '../../widgets/common_drawer.dart';
import '../../widgets/shimmer_widget.dart';
import '../../services/api_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'report_filter_screen.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _activeTab = 0;

  // Summary stats
  double _totalConsumption = 0;
  double _avgConsumption = 0;
  Map<String, double> _contaminantMinByType = {};
  Map<String, double> _contaminantMaxByType = {};
  bool _statsLoading = true;

  // Chart data (populated from API period data when available)
  List<double> _usageBars = [];
  List<String> _usageLabels = [];
  double _usageMaxY = 40;

  List<double> _impurityPrimaryBars = [];
  List<double> _impuritySecondaryBars = [];
  double _impurityMaxY = 40;

  String _chartPeriodLabel = '';

  static String _monthName(int m) => const [
        'January', 'February', 'March', 'April', 'May', 'June',
        'July', 'August', 'September', 'October', 'November', 'December'
      ][m - 1];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _chartPeriodLabel = '${_monthName(now.month)} ${now.year}';
    // 'water_consumption__' is the key with no date filters.
    final hasCached = ApiService.isCacheValid('water_consumption__') &&
        ApiService.isCacheValid('contaminant_trends');
    _statsLoading = !hasCached;
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    try {
      final results = await Future.wait([
        ApiService.getWaterConsumption(),
        ApiService.getContaminantTrends(),
      ]);
      final consumption = results[0];
      final contaminants = results[1];

      final summary = consumption['summary'] as Map<String, dynamic>? ?? {};
      // One summary row per contaminant_type (chlorine, nitrate, calcium, ...) —
      // index by type so each stat card shows its own min/max, not a shared value.
      final contaminantSummaryList = (contaminants['summary'] as List?) ?? [];
      final minByType = <String, double>{};
      final maxByType = <String, double>{};
      for (final item in contaminantSummaryList) {
        if (item is Map) {
          final type = item['contaminant_type'] as String?;
          if (type == null) continue;
          minByType[type] = (item['min_level'] as num?)?.toDouble() ?? 0;
          maxByType[type] = (item['max_level'] as num?)?.toDouble() ?? 0;
        }
      }

      // ── Fluid Usage chart bars ──────────────────────────────────────────
      // The API may return period data under 'data', 'daily', or 'periods'.
      final rawUsage = (consumption['data'] as List<dynamic>?) ??
          (consumption['daily'] as List<dynamic>?) ??
          (consumption['periods'] as List<dynamic>?) ??
          [];

      final List<double> usageBars = rawUsage.take(5).map((d) {
        if (d is Map) {
          return ((d['amount'] as num?) ??
                  (d['consumption'] as num?) ??
                  (d['total'] as num?) ??
                  0)
              .toDouble();
        }
        return 0.0;
      }).toList();

      final List<String> usageLabels = rawUsage.take(5).map((d) {
        if (d is Map) {
          final date = d['date'] as String? ?? d['period'] as String? ?? '';
          if (date.length >= 10) return date.substring(8, 10); // DD from YYYY-MM-DD
        }
        return '';
      }).toList();

      final double usageMax = usageBars.isNotEmpty
          ? usageBars.reduce((a, b) => a > b ? a : b)
          : _avgConsumption;
      final double usageMaxY =
          usageMax > 0 ? ((usageMax * 1.3) / 10).ceil() * 10.0 : 40;

      // ── Fluid Impurity chart bars ───────────────────────────────────────
      final rawTrend = (contaminants['data'] as List<dynamic>?) ??
          (contaminants['trends'] as List<dynamic>?) ??
          (contaminants['periods'] as List<dynamic>?) ??
          [];

      // Primary = TDS (scaled /10 to fit chart), Secondary = pH (scaled *4)
      final List<double> impPrimary = rawTrend.take(5).map((d) {
        if (d is Map) {
          return ((d['tds_level'] as num?) ?? 0).toDouble() / 10;
        }
        return 0.0;
      }).toList();

      final List<double> impSecondary = rawTrend.take(5).map((d) {
        if (d is Map) {
          return ((d['ph_level'] as num?) ?? 0).toDouble() * 4;
        }
        return 0.0;
      }).toList();

      final allImpurity = [...impPrimary, ...impSecondary];
      final double impMax = allImpurity.isNotEmpty
          ? allImpurity.reduce((a, b) => a > b ? a : b)
          : 40;
      final double impMaxY =
          impMax > 0 ? ((impMax * 1.3) / 10).ceil() * 10.0 : 40;

      if (mounted) {
        setState(() {
          _totalConsumption =
              (summary['total_consumption'] as num?)?.toDouble() ?? 0;
          _avgConsumption =
              (summary['avg_consumption'] as num?)?.toDouble() ?? 0;
          _contaminantMinByType = minByType;
          _contaminantMaxByType = maxByType;
          _usageBars = usageBars;
          _usageLabels = usageLabels;
          _usageMaxY = usageMaxY;
          _impurityPrimaryBars = impPrimary;
          _impuritySecondaryBars = impSecondary;
          _impurityMaxY = impMaxY;
          _statsLoading = false;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _statsLoading = false);
    }
  }

  String _contaminantStat(Map<String, double> byType, String type) {
    if (_statsLoading) return '...';
    final v = byType[type];
    return v != null ? '${v.toStringAsFixed(2)} mg/L' : '—';
  }

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Color(0xFF0052cc), size: 28),
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        title: const Text(
          'Reports',
          style: TextStyle(
            color: Color(0xFF14103B),
            fontSize: 18,
            fontWeight: FontWeight.w700,
            fontFamily: 'Inter',
          ),
        ),
        centerTitle: true,
      ),
      drawer: CommonDrawer(scaffoldKey: scaffoldKey, currentRoute: '/reports'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tabs
            Container(
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
                        setState(() {
                          _activeTab = 0;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _activeTab == 0 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Fluid Usage',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _activeTab == 0
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
                        setState(() {
                          _activeTab = 1;
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: _activeTab == 1 ? Colors.white : Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Text(
                          'Fluid Impurity',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: _activeTab == 1
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
            const SizedBox(height: 24),
            // Tab content
            if (_activeTab == 0) _buildFluidUsageTab() else _buildFluidImpurityTab(),
          ],
        ),
      ),
    );
  }

  Widget _buildFluidUsageTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Report on Fluid Usage',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF14103B),
                fontFamily: 'Inter',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportFilterScreen(filterType: 'fluid_usage'),
                  ),
                );
              },
              child: Icon(
                Icons.tune,
                color: const Color(0xFF0052cc),
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        // Chart card
        _buildChartCard(),
        const SizedBox(height: 16),
        // Stats
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
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
                  const Text(
                    'Total consumption',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFCCCCCC),
                      fontFamily: 'Inter',
                    ),
                  ),
                  _statsLoading
                      ? const ShimmerBox(width: 70, height: 14, radius: 4)
                      : Text(
                          '${_totalConsumption.toStringAsFixed(1)} L',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF14103B),
                            fontFamily: 'Inter',
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Average daily usage',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFCCCCCC),
                      fontFamily: 'Inter',
                    ),
                  ),
                  _statsLoading
                      ? const ShimmerBox(width: 70, height: 14, radius: 4)
                      : Text(
                          '${_avgConsumption.toStringAsFixed(1)} L',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF14103B),
                            fontFamily: 'Inter',
                          ),
                        ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Peak usage times',
                    style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFCCCCCC),
                      fontFamily: 'Inter',
                    ),
                  ),
                  const Text(
                    '—',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF14103B),
                      fontFamily: 'Inter',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        // Export report button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _showExportReportModal(context, 'Fluid Usage');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF001a4d),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Export report',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildFluidImpurityTab() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Report on Fluid Impurity',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF14103B),
                fontFamily: 'Inter',
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ReportFilterScreen(filterType: 'fluid_impurity'),
                  ),
                );
              },
              child: Icon(
                Icons.tune,
                color: const Color(0xFF0052cc),
                size: 24,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text(
          'Primary Contaminant Monitoring',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFCCCCCC),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 12),
        // Primary chart card
        _buildChartCard(isFluidImpurity: true),
        const SizedBox(height: 16),
        // Chlorine stats (WHO limit: 5 mg/L)
        _buildContaminantStats(
          title: 'Chlorine',
          color: const Color(0xFF0052cc),
          minLabel: 'Min level',
          minValue: _contaminantStat(_contaminantMinByType, 'chlorine'),
          maxLabel: 'Max level',
          maxValue: _contaminantStat(_contaminantMaxByType, 'chlorine'),
        ),
        const SizedBox(height: 16),
        // Nitrate stats (WHO limit: 50 mg/L)
        _buildContaminantStats(
          title: 'Nitrate (NO3⁻)',
          color: const Color(0xFF6B9FFF),
          minLabel: 'Min level',
          minValue: _contaminantStat(_contaminantMinByType, 'nitrate'),
          maxLabel: 'Max level',
          maxValue: _contaminantStat(_contaminantMaxByType, 'nitrate'),
        ),
        const SizedBox(height: 28),
        // Secondary Contaminant Monitoring
        const Text(
          'Secondary Contaminant Monitoring',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFCCCCCC),
            fontFamily: 'Inter',
          ),
        ),
        const SizedBox(height: 12),
        // Secondary chart card
        _buildChartCard(isFluidImpurity: true),
        const SizedBox(height: 16),
        // Calcium stats (informational — no WHO limit)
        _buildContaminantStats(
          title: 'Calcium (Ca²⁺)',
          color: const Color(0xFF0052cc),
          minLabel: 'Min level',
          minValue: _contaminantStat(_contaminantMinByType, 'calcium'),
          maxLabel: 'Max level',
          maxValue: _contaminantStat(_contaminantMaxByType, 'calcium'),
        ),
        const SizedBox(height: 16),
        // Sodium stats (informational — no WHO limit)
        _buildContaminantStats(
          title: 'Sodium (Na⁺)',
          color: const Color(0xFF6B9FFF),
          minLabel: 'Min level',
          minValue: _contaminantStat(_contaminantMinByType, 'sodium'),
          maxLabel: 'Max level',
          maxValue: _contaminantStat(_contaminantMaxByType, 'sodium'),
        ),
        const SizedBox(height: 24),
        // Export report button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              _showExportReportModal(context, 'Fluid Impurity');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF001a4d),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Export report',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                fontFamily: 'Inter',
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildChartCard({bool isFluidImpurity = false}) {
    final maxY = isFluidImpurity ? _impurityMaxY : _usageMaxY;
    final bars = isFluidImpurity
        ? _buildFluidImpurityBarGroups()
        : _buildFluidUsageBarGroups();

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEEEEEE), width: 1),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.chevron_left, color: Color(0xFFCCCCCC)),
              Text(
                _chartPeriodLabel,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14103B),
                  fontFamily: 'Inter',
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC)),
            ],
          ),
          const SizedBox(height: 16),
          if (bars.isEmpty && !_statsLoading)
            const SizedBox(
              height: 80,
              child: Center(
                child: Text(
                  'No chart data available for this period',
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0xFFAAAAAA),
                      fontFamily: 'Inter'),
                ),
              ),
            )
          else
            SizedBox(
              height: 200,
              child: _statsLoading
                  ? const ShimmerBox(
                      width: double.infinity, height: 200, radius: 8)
                  : BarChart(
                      BarChartData(
                        alignment: BarChartAlignment.spaceAround,
                        maxY: maxY,
                        barTouchData: BarTouchData(enabled: false),
                        titlesData: FlTitlesData(
                          show: true,
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                final idx = value.toInt();
                                final label = idx < _usageLabels.length
                                    ? _usageLabels[idx]
                                    : '${idx + 1}';
                                return Text(label,
                                    style: const TextStyle(
                                        color: Color(0xFFCCCCCC),
                                        fontSize: 11,
                                        fontFamily: 'Inter'));
                              },
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) => Text(
                                '${value.toInt()}',
                                style: const TextStyle(
                                    color: Color(0xFFCCCCCC),
                                    fontSize: 10,
                                    fontFamily: 'Inter'),
                              ),
                              reservedSize: 30,
                            ),
                          ),
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                        ),
                        gridData: FlGridData(
                          show: true,
                          drawVerticalLine: false,
                          horizontalInterval: maxY / 4,
                          getDrawingHorizontalLine: (_) => const FlLine(
                              color: Color(0xFFEEEEEE), strokeWidth: 1),
                        ),
                        borderData: FlBorderData(show: false),
                        barGroups: bars,
                      ),
                    ),
            ),
        ],
      ),
    );
  }

  static const _barRadius = BorderRadius.only(
    topLeft: Radius.circular(4),
    topRight: Radius.circular(4),
  );

  List<BarChartGroupData> _buildFluidUsageBarGroups() {
    if (_usageBars.isEmpty) return [];
    return List.generate(_usageBars.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: _usageBars[i],
            color: const Color(0xFF207C08),
            width: 8,
            borderRadius: _barRadius,
          ),
        ],
      );
    });
  }

  List<BarChartGroupData> _buildFluidImpurityBarGroups() {
    if (_impurityPrimaryBars.isEmpty) return [];
    final count = _impurityPrimaryBars.length;
    return List.generate(count, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: i < _impurityPrimaryBars.length ? _impurityPrimaryBars[i] : 0,
            color: const Color(0xFF0B2A69),
            width: 6,
            borderRadius: _barRadius,
          ),
          BarChartRodData(
            toY: i < _impuritySecondaryBars.length
                ? _impuritySecondaryBars[i]
                : 0,
            color: const Color(0xFFAACDF6),
            width: 6,
            borderRadius: _barRadius,
          ),
        ],
      );
    });
  }

  Widget _buildContaminantStats({
    required String title,
    required Color color,
    required String minLabel,
    required String minValue,
    required String maxLabel,
    required String maxValue,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
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
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF14103B),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                minLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFCCCCCC),
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                minValue,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14103B),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                maxLabel,
                style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFCCCCCC),
                  fontFamily: 'Inter',
                ),
              ),
              Text(
                maxValue,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14103B),
                  fontFamily: 'Inter',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showExportReportModal(BuildContext context, String reportType) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Handle bar
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEEEEEE),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Title
                const Text(
                  'Export report',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF14103B),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 8),
                // Description
                const Text(
                  'It is a long established fact that a reader will be distracted by the readable content',
                  style: TextStyle(
                    fontSize: 13,
                    color: Color(0xFF0052cc),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 20),
                // Report details
                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F5F5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Report on Fluid Impurity',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF14103B),
                          fontFamily: 'Inter',
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Contaminants',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFCCCCCC),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const Text(
                            'Chlorine, Nitrate, Calcium, Sodium',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF14103B),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Period',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFCCCCCC),
                              fontFamily: 'Inter',
                            ),
                          ),
                          const Text(
                            'January 2025',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF14103B),
                              fontFamily: 'Inter',
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                // Action buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Download button
                    Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF0052cc),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.download_outlined,
                        color: Color(0xFF0052cc),
                        size: 24,
                      ),
                    ),
                    // Share button
                    Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF0052cc),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.share_outlined,
                        color: Color(0xFF0052cc),
                        size: 24,
                      ),
                    ),
                    // Copy button
                    Container(
                      width: 80,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: const Color(0xFF0052cc),
                          width: 1.5,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.content_copy_outlined,
                        color: Color(0xFF0052cc),
                        size: 24,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
