import 'package:flutter/material.dart';
import 'package:shrimpapp/consumer_page.dart';
import 'package:shrimpapp/scanner_page.dart';
import 'package:shrimpapp/consumer_dashboard.dart'; // Import the ConsumerDashboard class

class LoginPage extends StatefulWidget {
  static const routeName = '/login';

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedUserType = 'Consumer';

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (_selectedUserType == 'Consumer' && email == 'consumer@gmail.com' && password == '123456') {
      Navigator.of(context).pushReplacementNamed(ConsumerDashboard.routeName); // Navigate to ConsumerDashboard
    } else if (_selectedUserType == 'Admin' && email == 'admin@gmail.com' && password == '123456') {
      // Handle admin login, if needed
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Login Failed'),
            content: Text('Invalid email or password. Please try again.'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            DropdownButton<String>(
              value: _selectedUserType,
              onChanged: (newValue) {
                setState(() {
                  _selectedUserType = newValue!;
                });
              },
              items: <String>['Consumer', 'Regulator', 'Admin', 'Distributor']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
