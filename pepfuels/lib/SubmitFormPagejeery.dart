import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared preferences for token retrieval

class SubmitFormPagejeery extends StatefulWidget {
  final String dieselPrice;
  final int quantity;
  final int totalAmount;

  const SubmitFormPagejeery({
    Key? key,
    required this.dieselPrice,
    required this.quantity,
    required this.totalAmount,
  }) : super(key: key);

  @override
  _SubmitFormPagejeeryState createState() => _SubmitFormPagejeeryState();
}

class _SubmitFormPagejeeryState extends State<SubmitFormPagejeery> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String _errorMessage = '';

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

      // Prepare the payload for the API request
      final payload = {
        'fuelType': 'diesel',
        'quantity': widget.quantity,
        'deliveryAddress': address,
        'mobile': mobile,
        'name': name,
        'email': email,
      };

      print('Payload: $payload');
      print('Total Amount: ${widget.totalAmount}');

      try {
        // Retrieve the token from shared preferences
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('jwtToken');
        // Make the POST request
        final response = await http.post(
          Uri.parse('http://184.168.120.64:5000/api/jerrycanOrders'), // Ensure this endpoint is correct
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer $token', // Use the retrieved token
          },
          body: jsonEncode(payload),
        );

        print('Response Status: ${response.statusCode}');
        print('Response Body: ${response.body}');

        if (response.statusCode == 201) {
          // Order created successfully
          final responseData = jsonDecode(response.body);

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Order submitted successfully!')),
          );

          // Navigate to the OrderId page after successful submission
          Navigator.pushNamed(
            context,
            'orderid',
            arguments: responseData, // Pass the entire response data
          );
        } else {
          // Handle error response
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
    // Calculate the total amount with delivery charge
    final int deliveryCharge = 100;
    final int totalAmountWithCharge = widget.totalAmount + deliveryCharge;

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
                        'Quantity: ${widget.quantity} Liters',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Delivery Charge: 100 Rs',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Total Amount: ${totalAmountWithCharge} Rs',
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
                      SizedBox(height: 10),
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
                      SizedBox(height: 10),
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
                          if (!RegExp(r'^\+?[0-9]{10,15}$').hasMatch(value)) {
                            return 'Please enter a valid mobile number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 10),
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
                          if (!RegExp(r'^[^@]+@[^@]+\.[^@]+$')
                              .hasMatch(value)) {
                            return 'Please enter a valid email address';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 20),
                      _isLoading
                          ? CircularProgressIndicator()
                          : ElevatedButton(
                              onPressed: _submitForm,
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Text('Submit'),
                              ),
                              style: ElevatedButton.styleFrom(
                                minimumSize: Size(double.infinity, 50),
                              ),
                            ),
                      if (_errorMessage.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red),
                          ),
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