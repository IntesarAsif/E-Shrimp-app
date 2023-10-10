import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart' as qr_code;
import 'dart:convert';
import 'consumer_dashboard.dart';
import 'history_page.dart';
import 'package:flutter/services.dart';

class ScannerPage extends StatelessWidget {
  static const routeName = '/scanner';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner'),
      ),
      body: ScannerWidget(),
    );
  }
}

class ScannerWidget extends StatefulWidget {
  @override
  _ScannerWidgetState createState() => _ScannerWidgetState();
}

class _ScannerWidgetState extends State<ScannerWidget> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  qr_code.QRViewController? controller;

  void _handleScanData(qr_code.Barcode scanData) {
    if (scanData.code != null) {
      Map<String, dynamic> jsonData = json.decode(scanData.code!);
      double freshness = calculateFreshness(jsonData);

      HapticFeedback.vibrate();

      _saveScanRecord(jsonData, freshness);
      _showFreshnessDialog(freshness);

      // Dispose the controller to stop scanning
      controller?.dispose();
    }
  }

  void _saveScanRecord(Map<String, dynamic> jsonData, double freshness) async {
    // Save the scan record to history
    ScanRecord scanRecord = ScanRecord(
      dateTime: DateTime.now().toString(),
      scanData: json.encode(jsonData),
      freshness: freshness,
    );
    await saveScanRecord(scanRecord);
  }

  void _showFreshnessDialog(double freshness) {
    Color color;
    if (freshness >= 80) {
      color = Colors.green;
    } else if (freshness >= 60) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Freshness'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '${freshness.toStringAsFixed(2)}%',
                style: TextStyle(
                  color: color,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, ConsumerDashboard.routeName);
                },
                child: Text('Back'),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        color: Colors.black,
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.width * 0.8,
          child: Stack(
            children: [
              qr_code.QRView(
                key: qrKey,
                onQRViewCreated: _onQRViewCreated,
              ),
              Center(
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.green,
                      width: 2,
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

  void _onQRViewCreated(qr_code.QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(_handleScanData);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  double calculateFreshness(Map<String, dynamic> jsonData) {
    // Implement your algorithm to calculate freshness here
    // Example calculation:
    double wTemperature = 1.4;
    double wPh = 0.25;
    double wOxygenLevel = 0.8;
    double wCO2Level = 0.8;
    double wAmmonia = 0.15;
    double wHumidity = 0.5;
    double wColorChanges = 0.1;
    double wTextureChanges = 0.1;
    double wTimeSinceHarvest = 0.4;

    double temperature = jsonData['temperature']?.toDouble();
    double ph = jsonData['ph_level']?.toDouble();
    double oxygenLevel = jsonData['oxygen_level']?.toDouble();
    double co2Level = jsonData['CO2_level']?.toDouble();
    double ammonia = jsonData['ammonia_content']?.toDouble();
    double colorChanges = jsonData['color_changes']?.toDouble();
    double textureChanges = jsonData['texture_changes']?.toDouble();
    double humidity = jsonData['humidity']?.toDouble();
    int timeSinceHarvest = jsonData['time_since_harvest']?.toInt() ?? 1;

    double freshnessPercentage = (wTemperature * temperature) +
        (wPh * ph) +
        (wOxygenLevel * oxygenLevel) +
        (wCO2Level * co2Level) +
        (wAmmonia * ammonia) +
        (wColorChanges * colorChanges) +
        (wTextureChanges * textureChanges) +
        (wHumidity * humidity) +
        (wTimeSinceHarvest * timeSinceHarvest);

    return freshnessPercentage;
  }
}
