import 'package:flutter/material.dart';
import '../../widgets/common_drawer.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({Key? key}) : super(key: key);

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  int _activeTab = 0; // 0 for Fluid Usage, 1 for Fluid Impurity

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
            Icon(
              Icons.tune,
              color: const Color(0xFF0052cc),
              size: 24,
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
                  const Text(
                    '251 L',
                    style: TextStyle(
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
                  const Text(
                    '5 L',
                    style: TextStyle(
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
                    '18:00',
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
            Icon(
              Icons.tune,
              color: const Color(0xFF0052cc),
              size: 24,
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
        _buildChartCard(),
        const SizedBox(height: 16),
        // Lead stats
        _buildContaminantStats(
          title: 'Lead (Pb²⁺)',
          color: const Color(0xFF0052cc),
          minLabel: 'Min level (13.01.2025)',
          minValue: '50 μg/L',
          maxLabel: 'Max level (25.01.2025)',
          maxValue: '2500 μg/L',
        ),
        const SizedBox(height: 16),
        // Mercury stats
        _buildContaminantStats(
          title: 'Mercury (Hg²⁺)',
          color: const Color(0xFF6B9FFF),
          minLabel: 'Min level (10.01.2025)',
          minValue: '15 μg/L',
          maxLabel: 'Max level (16.01.2025)',
          maxValue: '3556 μg/L',
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
        _buildChartCard(),
        const SizedBox(height: 16),
        // Lead stats (secondary)
        _buildContaminantStats(
          title: 'Lead (Pb²⁺)',
          color: const Color(0xFF0052cc),
          minLabel: 'Min level (13.01.2025)',
          minValue: '50 μg/L',
          maxLabel: 'Max level (25.01.2025)',
          maxValue: '2500 μg/L',
        ),
        const SizedBox(height: 16),
        // Mercury stats (secondary)
        _buildContaminantStats(
          title: 'Mercury (Hg²⁺)',
          color: const Color(0xFF6B9FFF),
          minLabel: 'Min level (10.01.2025)',
          minValue: '15 μg/L',
          maxLabel: 'Max level (16.01.2025)',
          maxValue: '3556 μg/L',
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

  Widget _buildChartCard() {
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
        children: [
          // Month navigation
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Color(0xFFCCCCCC)),
                onPressed: () {},
              ),
              const Text(
                'January 2025',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14103B),
                  fontFamily: 'Inter',
                ),
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Color(0xFFCCCCCC)),
                onPressed: () {},
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Bar chart
          SizedBox(
            height: 200,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: 40,
                barTouchData: BarTouchData(enabled: false),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const titles = ['1', '8', '15', '22', '31'];
                        if (value.toInt() < titles.length) {
                          return Text(
                            titles[value.toInt()],
                            style: const TextStyle(
                              color: Color(0xFFCCCCCC),
                              fontSize: 11,
                              fontFamily: 'Inter',
                            ),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}',
                          style: const TextStyle(
                            color: Color(0xFFCCCCCC),
                            fontSize: 10,
                            fontFamily: 'Inter',
                          ),
                        );
                      },
                      reservedSize: 30,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 10,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: const Color(0xFFEEEEEE),
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                barGroups: [
                  BarChartGroupData(
                    x: 0,
                    barRods: [
                      BarChartRodData(
                        toY: 20,
                        color: const Color(0xFF51CF66),
                        width: 8,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 1,
                    barRods: [
                      BarChartRodData(
                        toY: 38,
                        color: const Color(0xFF51CF66),
                        width: 8,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 2,
                    barRods: [
                      BarChartRodData(
                        toY: 27,
                        color: const Color(0xFF51CF66),
                        width: 8,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 3,
                    barRods: [
                      BarChartRodData(
                        toY: 24,
                        color: const Color(0xFF51CF66),
                        width: 8,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                  BarChartGroupData(
                    x: 4,
                    barRods: [
                      BarChartRodData(
                        toY: 18,
                        color: const Color(0xFF51CF66),
                        width: 8,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(4),
                          topRight: Radius.circular(4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
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
                            'Lead (Pb²⁺), Mercury (Hg²⁺)',
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
