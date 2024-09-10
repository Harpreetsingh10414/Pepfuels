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

    try {
      final response = await http.get(
        Uri.parse('http://184.168.120.64:5000/api/orderByUserId/user/$userId'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          _orders = responseBody;
          _isLoading = false;
        });
      } else {
        setState(() {
          // _errorMessage = 'Failed to load orders. Status code: ${response.statusCode}, Response body: ${response.body}';
          _errorMessage = 'Your Order Will be Update Shortly Please Wait For a While  Thankyou!';
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
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/background-img-for-all-internal.jpg'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _errorMessage.isNotEmpty
                  ? Center(
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _orders.length,
                      itemBuilder: (context, index) {
                        final order = _orders[index];

                        return Card(
                          elevation: 5,
                          margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [Colors.purpleAccent, Colors.deepPurple],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Order ID: ${order['orderID']}',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Status: ${order['status']}',
                                  style: TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Delivery Date: ${order['deliveryDate']}',
                                  style: TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Fuel Type: ${order['fuelType']}',
                                  style: TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Quantity: ${order['quantity']} liters',
                                  style: TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Total Amount: ${order['totalAmount']}',
                                  style: TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Delivery Address: ${order['deliveryAddress']}',
                                  style: TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Tracking Details: ${order['trackingDetails']}',
                                  style: TextStyle(fontSize: 16, color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ],
      ),
    );
  }
}
