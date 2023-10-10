import 'package:flutter/material.dart';
import 'package:shrimpapp/login_page.dart'; // Import the login page
import 'package:shrimpapp/consumer_page.dart'; // Import the ConsumerPage
import 'package:shrimpapp/scanner_page.dart'; // Import the ScannerPage
import 'package:shrimpapp/consumer_dashboard.dart';
import 'package:shrimpapp/history_page.dart';
import 'package:shrimpapp/graph_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shrimp App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: WelcomePage(), // Set WelcomePage as the initial page
      routes: {
        LoginPage.routeName: (context) => LoginPage(),
        ConsumerPage.routeName: (context) => ConsumerPage(),
        ScannerPage.routeName: (context) => ScannerPage(),
        ConsumerDashboard.routeName: (context) => ConsumerDashboard(),
        HistoryPage.routeName: (context) => HistoryPage(),
        GraphPage.routeName: (context) => GraphPage(),
      },
    );
  }
}

class WelcomePage extends StatelessWidget {
  double imageSize = 300.0; // Initial image size

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to Shrimp-E',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Image.asset(
              'assets/logo.jpeg',
              width: imageSize,
              height: imageSize,
            ),
            SizedBox(height: 16),
            Text(
              'From the sea to your home, we believe in complete transparency of what you eat!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20, // Adjust the font size here
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Powered by Blockchain',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20, // Adjust the font size here
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, LoginPage.routeName);
              },
              child: Text('Get started'),
            ),
          ],
        ),
      ),
    );
  }
}
