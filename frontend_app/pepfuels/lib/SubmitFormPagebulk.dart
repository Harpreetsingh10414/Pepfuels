import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import './Constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http; 

class SubmitFormPagebulk extends StatefulWidget {
  final String dieselPrice;
  final double quantity; // Updated to double
  final int totalAmount;

  const SubmitFormPagebulk({
    Key? key,
    required this.dieselPrice,
    required this.quantity, // Updated to double
    required this.totalAmount,
  }) : super(key: key);

  @override
  _SubmitFormPagebulkState createState() => _SubmitFormPagebulkState();
}

class _SubmitFormPagebulkState extends State<SubmitFormPagebulk> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  Future<void> _fetchUserProfile() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('jwtToken');

      if (token == null) {
        setState(() {
          _errorMessage = 'No token found. Please log in again.';
          _isLoading = false;
        });
        return;
      }

      final response = await http.get(
        Uri.parse('$BASE_URL/Profile'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final profileData = json.decode(response.body);
        _nameController.text = profileData['name'] ?? '';
        _addressController.text = profileData['address'] ?? '';
        _mobileController.text = profileData['phone'] ?? '';
        _emailController.text = profileData['email'] ?? '';
      } else {
        setState(() {
          _errorMessage =
              'Failed to fetch user profile. Status code: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching profile: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      // Collect form data
      final name = _nameController.text;
      final address = _addressController.text;
      final mobile = _mobileController.text;
      final email = _emailController.text;

      // Calculate total amount
      final dieselPrice = double.tryParse(widget.dieselPrice) ?? 0.0;
      final baseAmount =
          dieselPrice * widget.quantity; // Using double for quantity
      final deliveryCharge = 100;
      final totalAmount = baseAmount + deliveryCharge;

      // Prepare the payload for the API request
      final payload = {
        'fuelType': 'diesel',
        'quantity': widget.quantity, // Send quantity as double
        'deliveryAddress': address,
        'mobile': mobile,
        'name': name,
        'email': email,
        'totalAmount': totalAmount,
      };

      try {
        // Retrieve the token from SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('jwtToken');

        if (token == null) {
          setState(() {
            _errorMessage = 'No token found. Please log in again.';
            _isLoading = false;
          });
          return;
        }

        // Make the POST request
        final response = await http.post(
          Uri.parse('$BASE_URL/bulkOrders'),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token',
          },
          body: jsonEncode(payload),
        );

        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order submitted successfully!')),
          );

          // Navigate to OrderId page with the full response
          Navigator.pushNamed(
            context,
            'orderid',
            arguments: responseData,
          );
        } else {
          final errorResponse = jsonDecode(response.body);
          setState(() {
            _errorMessage =
                errorResponse['errors']?.join(', ') ?? 'Something went wrong';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'Network error: ${e.toString()}';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dieselPrice = double.tryParse(widget.dieselPrice) ?? 0.0;
    final baseAmount =
        dieselPrice * widget.quantity; // Using double for quantity
    final deliveryCharge = 100;
    final totalAmount = baseAmount + deliveryCharge;

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logo.png', // Ensure this path is correct
            height: 50,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
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
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Submit Form',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Diesel Price: ${widget.dieselPrice} Rs/L',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Quantity: ${widget.quantity} Liters', // Display quantity as double
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Delivery Charge: $deliveryCharge Rs', // Display delivery charge
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Total Amount: $totalAmount Rs', // Display calculated total amount
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 20),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _addressController,
                        decoration: InputDecoration(
                          labelText: 'Address',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _mobileController,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your mobile number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 15),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          fillColor: Colors.white,
                          filled: true,
                          border: OutlineInputBorder(),
                          floatingLabelBehavior: FloatingLabelBehavior.never,
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 10),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ElevatedButton(
                        onPressed: _submitForm,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              vertical: 15, horizontal: 30),
                          backgroundColor: Colors
                              .blue, // Use backgroundColor instead of primary
                        ),
                        child: _isLoading
                            ? CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : Text('Submit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
