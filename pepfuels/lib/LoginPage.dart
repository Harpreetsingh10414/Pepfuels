import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _loginFormKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    print('Step 1: Starting login process');
    print('Email: ${_emailController.text}');
    print('Password: ${_passwordController.text}');

    try {
      print('Step 2: Sending HTTP POST request');
      final response = await http.post(
        Uri.parse('http://localhost:5000/api/auth/login'), // Replace with your API URL
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      print('Step 3: Received response');
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Assuming a successful login
        print('Step 4: Login successful, navigating to home page');
        setState(() {
          _isLoading = false;
        });
        Navigator.pushReplacementNamed(context, 'home'); // Navigate to home page
      } else {
        print('Step 4: Login failed, displaying error message');
        setState(() {
          _isLoading = false;
          _errorMessage = 'Login failed. Please try again.';
        });
      }
    } catch (error) {
      print('Step 5: Error during login');
      print('Error: $error');
      setState(() {
        _isLoading = false;
        _errorMessage = 'An error occurred. Please try again.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            '../assets/images/logo.png', // Ensure this path is correct
            width: 200,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 187, 187, 187),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              children: <Widget>[
                Image.asset(
                  '../assets/images/headerall.jpg', // Ensure this path is correct
                  width: double.infinity,
                  height: 200.0, // Adjust height as needed
                  fit: BoxFit.cover,
                ),
                Positioned(
                  bottom: 75, // Adjust vertical position as needed
                  left: 16, // Adjust horizontal position as needed
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    // color: Colors.black.withOpacity(0.5), // Semi-transparent background
                    child: Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 24, // Adjust font size as needed
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Text color
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0), // Add padding around the form
              child: Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(labelText: 'Email'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _passwordController,
                      decoration: InputDecoration(labelText: 'Password'),
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20), // Add some spacing before the button
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: () {
                              if (_loginFormKey.currentState?.validate() ?? false) {
                                print('Step 6: Form validated, calling _login');
                                _login();
                              } else {
                                print('Step 6: Form validation failed');
                              }
                            },
                            child: Text('Login'),
                          ),
                    if (_errorMessage.isNotEmpty) ...[
                      SizedBox(height: 20),
                      Text(
                        _errorMessage,
                        style: TextStyle(color: Colors.red),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}

void main() {
  runApp(MaterialApp(
    home: LoginPage(),
    routes: {
      'home': (context) => HomePage(), // Define your HomePage here
    },
  ));
}

// Placeholder for HomePage, replace with your actual HomePage implementation
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text('Welcome to the Home Page'),
      ),
    );
  }
}
