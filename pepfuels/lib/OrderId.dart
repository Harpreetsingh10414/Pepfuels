import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class OrderId extends StatefulWidget {
  final int selectedLiters;
  final String fuelType;

  const OrderId({
    Key? key,
    required this.selectedLiters,
    required this.fuelType,
  }) : super(key: key);

  @override
  _OrderIdState createState() => _OrderIdState();
}

class _OrderIdState extends State<OrderId> {
  bool _isLoading = false;
  String? _orderResponse;

  Future<void> _createOrder() async {
    setState(() {
      _isLoading = true;
    });

    final url = Uri.parse('http://localhost:5000/api/jerrycanOrders');
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'fuelType': widget.fuelType,
        'quantity': widget.selectedLiters,
      }),
    );

    if (response.statusCode == 200) {
      setState(() {
        _orderResponse = 'Order placed successfully!';
      });
    } else {
      setState(() {
        _orderResponse = 'Failed to place order. Please try again.';
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            '../assets/images/logo.png',
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
            '../assets/images/background-all-img.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Order Details',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Quantity: ${widget.selectedLiters} Liters',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Fuel Type: ${widget.fuelType}',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                            onPressed: _createOrder,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Text('Place Order'),
                            ),
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(double.infinity, 50),
                            ),
                          ),
                    SizedBox(height: 20),
                    if (_orderResponse != null)
                      Text(
                        _orderResponse!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
