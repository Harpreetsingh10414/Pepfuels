import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class TrackingPage extends StatefulWidget {
  const TrackingPage({super.key});

  @override
  _TrackingPageState createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  bool _isLoading = true;
  List<dynamic> _orders = [];
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  Future<void> _fetchOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken'); // Retrieve token from SharedPreferences
    String? userId = prefs.getString('userId');  // Retrieve userId

    if (token == null) {
      setState(() {
        _errorMessage = 'No token found. Please log in again.';
        _isLoading = false;
      });
      return;
    }

    // If userId is not found, fetch it from the profile API
    if (userId == null) {
      try {
        final profileResponse = await http.get(
          Uri.parse('http://184.168.120.64:5000/api/profile'),
          headers: {
            'Authorization': 'Bearer $token',
          },
        );

        if (profileResponse.statusCode == 200) {
          final profileData = json.decode(profileResponse.body);
          userId = profileData['userId'];
          if (userId != null) {
            await prefs.setString('userId', userId); // Save userId in SharedPreferences
          } else {
            setState(() {
              _errorMessage = 'User ID not found in profile response.';
              _isLoading = false;
            });
            return;
          }
        } else {
          setState(() {
            _errorMessage = 'Failed to fetch user profile. Status code: ${profileResponse.statusCode}';
            _isLoading = false;
          });
          return;
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Error fetching profile: ${e.toString()}';
          _isLoading = false;
        });
        return;
      }
    }

    // Debugging: Print the userId and URL to verify correctness
    print('Using User ID: $userId');
    print('Tracking API URL: http://184.168.120.64:5000/api/ordertrackings/user/$userId');

    try {
      final response = await http.get(
        Uri.parse('http://184.168.120.64:5000/api/ordertrackings/user/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          _orders = responseBody;
          _isLoading = false;
        });
      } else {
        // Add more details to the error message
        setState(() {
          _errorMessage = 'Failed to load orders. Status code: ${response.statusCode}, Response body: ${response.body}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'An error occurred: $e';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tracking'),
        backgroundColor: Colors.blue, // Adjust color as needed
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage, style: TextStyle(color: Colors.red)))
              : ListView.builder(
                  itemCount: _orders.length,
                  itemBuilder: (context, index) {
                    final order = _orders[index];
                    return ListTile(
                      title: Text('Order ID: ${order['_id']}'),
                      subtitle: Text('Details: ${order['details']}'), // Adjust according to your order data
                    );
                  },
                ),
    );
  }
}
