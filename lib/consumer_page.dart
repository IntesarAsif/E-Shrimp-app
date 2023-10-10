import 'package:flutter/material.dart';
import 'scanner_page.dart';

class ConsumerPage extends StatelessWidget {
  static const routeName = '/consumer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Consumer Page'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(context, ScannerPage.routeName);
          },
          child: Text('Scanner'),
        ),
      ),
    );
  }
}
