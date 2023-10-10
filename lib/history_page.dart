import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'graph_page.dart';

class HistoryPage extends StatefulWidget {
  static const routeName = '/history';

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late Future<List<ScanRecord>> historyData;

  @override
  void initState() {
    super.initState();
    historyData = fetchHistoryData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
      ),
      body: FutureBuilder<List<ScanRecord>>(
        future: historyData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No previous history found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final scanRecord = snapshot.data![index];
                return ExpansionTile(
                  title: Text('Scan ${index + 1} - ${_formatTime(scanRecord.dateTime)}'),
                  children: [
                    ListTile(
                      title: Text(
                        'Freshness: ${scanRecord.freshness.toStringAsFixed(2)}%',
                        style: TextStyle(
                          color: _getFreshnessColor(scanRecord.freshness),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Date & Time: ${_formatDateTime(scanRecord.dateTime)}'),
                          Text('Scan Data:'),
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: _buildScanDataTable(scanRecord.scanData),
                          ),
                        ],
                      ),
                      trailing: ElevatedButton(
                        onPressed: () async {
                          await deleteScanRecord(index);
                          setState(() {
                            historyData = fetchHistoryData();
                          });
                        },
                        child: Text('Delete'),
                      ),
                    ),
                  ],
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, GraphPage.routeName);
        },
        child: Icon(Icons.insert_chart),
      ),
    );
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

  String _formatTime(String dateTime) {
    DateTime parsedDateTime = DateTime.parse(dateTime);
    String formattedTime = '${parsedDateTime.hour.toString().padLeft(2, '0')}:${parsedDateTime.minute.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  String _formatDateTime(String dateTime) {
    DateTime parsedDateTime = DateTime.parse(dateTime);
    String formattedDateTime = '${_formatTime(dateTime)}, ${parsedDateTime.day.toString().padLeft(2, '0')}-${parsedDateTime.month.toString().padLeft(2, '0')}-${parsedDateTime.year.toString()}';
    return formattedDateTime;
  }

  Widget _buildScanDataTable(String scanData) {
    Map<String, dynamic> jsonData = json.decode(scanData);

    return DataTable(
      columns: [
        DataColumn(label: Text('Attribute')),
        DataColumn(label: Text('Value')),
      ],
      rows: jsonData.entries.map((entry) {
        return DataRow(
          cells: [
            DataCell(Text(entry.key)),
            DataCell(Text(entry.value.toString())),
          ],
        );
      }).toList(),
    );
  }
}

class ScanRecord {
  final String dateTime;
  final String scanData;
  final double freshness;

  ScanRecord({
    required this.dateTime,
    required this.scanData,
    required this.freshness,
  });
}

Future<List<ScanRecord>> fetchHistoryData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? historyJsonList = prefs.getStringList('history');
  if (historyJsonList == null) {
    return [];
  } else {
    return historyJsonList.map((jsonString) {
      Map<String, dynamic> jsonData = Map<String, dynamic>.from(json.decode(jsonString));
      return ScanRecord(
        dateTime: jsonData['dateTime'],
        scanData: jsonData['scanData'],
        freshness: jsonData['freshness'],
      );
    }).toList();
  }
}

Future<void> saveScanRecord(ScanRecord scanRecord) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> historyJsonList = prefs.getStringList('history') ?? [];
  historyJsonList.add(json.encode({
    'dateTime': scanRecord.dateTime,
    'scanData': scanRecord.scanData,
    'freshness': scanRecord.freshness,
  }));
  await prefs.setStringList('history', historyJsonList);
}

Future<void> deleteScanRecord(int index) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? historyJsonList = prefs.getStringList('history');
  if (historyJsonList != null && index >= 0 && index < historyJsonList.length) {
    historyJsonList.removeAt(index);
    await prefs.setStringList('history', historyJsonList);
  }
}
