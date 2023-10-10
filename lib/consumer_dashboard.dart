import 'package:flutter/material.dart';
import 'history_page.dart'; // Import the HistoryPage class
import 'scanner_page.dart'; // Import the ScannerPage class

class ConsumerDashboard extends StatelessWidget {
  static const routeName = '/consumer_dashboard';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumer Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ScannerPage.routeName);
              },
              child: Text('Open Scanner'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, HistoryPage.routeName);
              },
              child: Text('History'),
            ),
          ],
        ),
      ),
    );
  }
}
