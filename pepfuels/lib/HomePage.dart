import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
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
        automaticallyImplyLeading:
            false, // To center title without a leading widget
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.asset(
              '../assets/images/headerall.jpg', // Ensure this path is correct
              width: double.infinity,
              height: 200, // Adjust height as needed
              fit: BoxFit.cover,
            ),
            SizedBox(height: 20), // Add spacing after the image
            Container(
              margin: const EdgeInsets.only(top: 10.0),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, 'login');
                      },
                      icon: Icon(Icons.login),
                      // label: Text('Go to Login Page'),
                      label: Padding(
                        padding: const EdgeInsets.all(
                            20.0), // Adjust padding as needed
                        child: Text('Go to Login Page'),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                            double.infinity, 50), // Make button take full width
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Add spacing between buttons
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, 'register');
                      },
                      icon: Icon(Icons.app_registration),
                      // label: Text('Go to Register Page'),
                      label: Padding(
                        padding: const EdgeInsets.all(
                            20.0), // Adjust padding as needed
                        child: Text('Go to Register Page'),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(
                            double.infinity, 50), // Make button take full width
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20), // Add spacing before the footer image
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: HomePage(),
    routes: {
      'login': (context) => LoginPage(), // Define your LoginPage here
      'register': (context) => RegisterPage(), // Define your RegisterPage here
    },
  ));
}

// Placeholder for LoginPage, replace with your actual LoginPage implementation
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login Page'),
      ),
      body: Center(
        child: Text('Login Page Content'),
      ),
    );
  }
}

// Placeholder for RegisterPage, replace with your actual RegisterPage implementation
class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register Page'),
      ),
      body: Center(
        child: Text('Register Page Content'),
      ),
    );
  }
}
