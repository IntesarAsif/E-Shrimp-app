import 'package:flutter/material.dart';
import 'scanner_page.dart';

class DetailsPage extends StatelessWidget {
  final Map<String, dynamic> scanData;
  final double freshness;

  DetailsPage({required this.scanData, required this.freshness});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Details'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Table(
              children: [
                TableRow(
                  children: [
                    TableCell(child: Text('Temperature')),
                    TableCell(child: Text('${scanData['temperature']}')),
                  ],
                ),
                // Add similar rows for other fields
              ],
            ),
            SizedBox(height: 20),
            Text('Freshness: ${freshness.toStringAsFixed(2)}%'),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
