import 'package:flutter/material.dart';
import 'package:pepfuels/OrderId.dart'; // Import the OrderId page

class JerryCan extends StatefulWidget {
  const JerryCan({Key? key}) : super(key: key);

  @override
  _JerryCanState createState() => _JerryCanState();
}

class _JerryCanState extends State<JerryCan> {
  int _selectedLiters = 0;
  int _totalAmount = 0;
  String _fuelType = 'Petrol'; // Default fuel type

  void _calculateAmount(int liters) {
    setState(() {
      _selectedLiters = liters;
      _totalAmount = liters * 100; // 100 Rs per liter
    });
  }

  void _navigateToOrderId() {
    Navigator.pushNamed(
      context,
      'orderid',
      arguments: {
        'selectedLiters': _selectedLiters,
        'fuelType': _fuelType,
      },
    );
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
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // To center title without a leading widget
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            '../assets/images/background-all-img.jpg', // Ensure this path is correct
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Jerry Can',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Select Quantity (in liters):',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    Wrap(
                      spacing: 20,
                      children: <Widget>[
                        _buildQuantityButton(5),
                        _buildQuantityButton(10),
                        _buildQuantityButton(15),
                        _buildQuantityButton(20),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: _totalAmount > 0 ? _navigateToOrderId : null,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Proceed to Order'),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50), // Make button take full width
                        ),
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

  Widget _buildQuantityButton(int liters) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton.icon(
        onPressed: () => _calculateAmount(liters),
        icon: Icon(Icons.local_gas_station),
        label: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('$liters Liters'),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 50),
        ),
      ),
    );
  }
}
