import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'history_page.dart';

class GraphPage extends StatelessWidget {
  static const routeName = '/graph';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Graph'),
      ),
      body: FutureBuilder<List<ScanRecord>>(
        future: fetchHistoryData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No history data available'));
          } else {
            return _buildChart(snapshot.data!);
          }
        },
      ),
    );
  }

  Widget _buildChart(List<ScanRecord> historyData) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.center,
          maxY: 100,
          barGroups: _createBarGroups(historyData),
          titlesData: FlTitlesData(
            leftTitles: SideTitles(
              showTitles: true,
              getTextStyles: (context, value) => TextStyle(fontSize: 14),
            ),
            bottomTitles: SideTitles(
              showTitles: true,
              getTitles: (double value) {
                final index = value.toInt() - 1;
                if (index >= 0 && index < historyData.length) {
                  return '${index + 1}';
                }
                return '';
              },
              getTextStyles: (context, value) => TextStyle(fontSize: 12),
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: const Color(0xff37434d),
              width: 1,
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _createBarGroups(List<ScanRecord> historyData) {
    return historyData.asMap().entries.map((entry) {
      final index = entry.key;
      final record = entry.value;
      return BarChartGroupData(
        x: index + 1, // x-axis index starting from 1
        barsSpace: 4,
        barRods: [
          BarChartRodData(
            y: record.freshness,
            colors: [_getFreshnessColor(record.freshness)],
            width: 16,
          ),
        ],
      );
    }).toList();
  }

  Color _getFreshnessColor(double freshness) {
    if (freshness >= 80) {
      return Colors.green;
    } else if (freshness >= 60) {
      return Colors.orange;
    } else {
      return Colors.red;
    }
  }
}
