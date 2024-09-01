import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _isLoading = true;
  String _name = '';
  String _email = '';
  String _phone = '';
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');

    print('Token retrieved: $token'); // Debugging line

    if (token == null) {
      setState(() {
        _errorMessage = 'No token found. Please log in again.';
        _isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://184.168.120.64:5000/api/profile'), // Update with your backend URL
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json', // Ensure Content-Type is set
        },
      );

      print('Response status: ${response.statusCode}'); // Debugging line
      print('Response body: ${response.body}'); // Debugging line

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          _name = responseBody['name'] ?? 'No name';
          _email = responseBody['email'] ?? 'No email';
          _phone = responseBody['phone'] ?? 'No phone';
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'Failed to load profile. Status code: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
      print('Error occurred during profile fetch: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logo.png', // Ensure this path is correct
            width: 200,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/background-img-for-all-internal.jpg', // Ensure this path is correct
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Overlay shade
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.white.withOpacity(0.5),
                        child: Text(
                          _name.isNotEmpty ? _name[0] : '',
                          style: TextStyle(
                              fontSize: 40,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        _name.isEmpty ? 'Loading...' : _name,
                        style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _email.isEmpty ? '' : _email,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        _phone.isEmpty ? '' : _phone,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      ListTile(
                        leading: Icon(Icons.person, color: Colors.white),
                        title:
                            Text('Edit Profile', style: TextStyle(color: Colors.white)),
                        onTap: () {
                          // Navigate to Edit Profile Page
                        },
                      ),
                      // ListTile(
                      //   leading: Icon(Icons.settings, color: Colors.white),
                      //   title: Text('Settings', style: TextStyle(color: Colors.white)),
                      //   onTap: () {
                      //     // Navigate to Settings Page
                      //   },
                      // ),
                      ListTile(
                        leading: Icon(Icons.logout, color: Colors.white),
                        title: Text('Logout', style: TextStyle(color: Colors.white)),
                        onTap: () async {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('jwtToken');
                          Navigator.pushReplacementNamed(context, '/');
                        },
                      ),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
