import 'package:flutter/material.dart';

class ReportFilterScreen extends StatefulWidget {
  final String filterType; // 'fluid_usage' or 'fluid_impurity'

  const ReportFilterScreen({Key? key, required this.filterType}) : super(key: key);

  @override
  State<ReportFilterScreen> createState() => _ReportFilterScreenState();
}

class _ReportFilterScreenState extends State<ReportFilterScreen> {
  String _selectedPeriod = 'Monthly';
  Map<String, bool> _dataPoints = {
    'Total consumption': true,
    'Average daily usage': true,
    'Peak usage times': true,
    'Lead level': false,
    'Mercury level': false,
    'Primary contaminants': false,
    'Secondary contaminants': false,
  };

  @override
  Widget build(BuildContext context) {
    final isFluidsUsage = widget.filterType == 'fluid_usage';
    final dataPointsToShow = isFluidsUsage
        ? ['Total consumption', 'Average daily usage', 'Peak usage times']
        : ['Lead level', 'Mercury level', 'Primary contaminants', 'Secondary contaminants'];

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
          'Report filter',
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
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Set time period section
              const Text(
                'Set time period',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF14103B),
                  fontFamily: 'Inter',
                ),
              ),
              const SizedBox(height: 16),
              _buildRadioOption('Daily', 'Daily'),
              _buildRadioOption('Weekly', 'Weekly'),
              _buildRadioOption('Monthly', 'Monthly'),
              _buildRadioOption('Custom period', 'Custom period'),
              const SizedBox(height: 20),
              // Date range fields (shown only for custom period)
              if (_selectedPeriod == 'Custom period')
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date from',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFAAAAAA),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFAFA),
                              border: Border.all(
                                color: const Color(0xFFEEEEEE),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        '—',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFFCCCCCC),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Date to',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFAAAAAA),
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            height: 44,
                            decoration: BoxDecoration(
                              color: const Color(0xFFFAFAFA),
                              border: Border.all(
                                color: const Color(0xFFEEEEEE),
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              const SizedBox(height: 32),
              // Data points included section (only for Fluid Usage)
              if (isFluidsUsage) ...[
                const Text(
                  'Data points included',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF14103B),
                    fontFamily: 'Inter',
                  ),
                ),
                const SizedBox(height: 16),
                ...dataPointsToShow.map((dataPoint) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _buildCheckboxOption(dataPoint),
                  );
                }),
                const SizedBox(height: 40),
              ],
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
                      borderRadius: BorderRadius.circular(12),
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
      ),
    );
  }

  Widget _buildRadioOption(String label, String value) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPeriod = value;
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
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
                  color: _selectedPeriod == value
                      ? const Color(0xFF0052cc)
                      : const Color(0xFFCCCCCC),
                  width: 2,
                ),
              ),
              child: _selectedPeriod == value
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Color(0xFF0052cc),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckboxOption(String label) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _dataPoints[label] = !(_dataPoints[label] ?? false);
        });
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF14103B),
              fontFamily: 'Inter',
            ),
          ),
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              border: Border.all(
                color: _dataPoints[label] ?? false
                    ? const Color(0xFF0052cc)
                    : const Color(0xFFCCCCCC),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(4),
              color: _dataPoints[label] ?? false
                  ? const Color(0xFF0052cc)
                  : Colors.transparent,
            ),
            child: _dataPoints[label] ?? false
                ? const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 14,
                  )
                : null,
          ),
        ],
      ),
    );
  }
}
