import 'package:flutter/material.dart';
import './Pumplocator.dart'; // Import the PumpLocator page

class BulkOrder extends StatefulWidget {
  const BulkOrder({super.key});

  @override
  _BulkOrderState createState() => _BulkOrderState();
}

class _BulkOrderState extends State<BulkOrder> {
  int _selectedLiters = 0; // Initialize to 0
  int _totalAmount = 0;

  void _calculateAmount(int liters) {
    setState(() {
      _selectedLiters = liters;
      _totalAmount = liters * 100; // 100rs per liter
    });
  }

  void _navigateToPumpLocator() {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PumpLocator(
        selectedLiters: _selectedLiters,
      ),
    ),
  );
}

  List<int> _generateLitersList() {
    List<int> litersList = [0]; // Add 0 as the default option
    for (int i = 100; i <= 6000; i += 100) {
      litersList.add(i);
    }
    return litersList;
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
                      'Bulk Order',
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
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: DropdownButton<int>(
                        value: _selectedLiters,
                        onChanged: (int? newValue) {
                          if (newValue != null) {
                            _calculateAmount(newValue);
                          }
                        },
                        items: _generateLitersList()
                            .map<DropdownMenuItem<int>>((int value) {
                          return DropdownMenuItem<int>(
                            value: value,
                            child: Text('$value Liters'),
                          );
                        }).toList(),
                        style: TextStyle(color: Colors.white), // Dropdown text color
                        dropdownColor: Colors.black, // Dropdown background color
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Total Amount: $_totalAmount Rs',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: _totalAmount > 0 ? _navigateToPumpLocator : null,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0), // Adjust padding as needed
                          child: Text('Proceed to Pump Locator'),
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
}

void main() {
  runApp(MaterialApp(
    home: BulkOrder(),
    routes: {
      'payment': (context) => PaymentPage(), // Define your PaymentPage here
    },
  ));
}

// Placeholder for PaymentPage, replace with your actual PaymentPage implementation
class PaymentPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Page'),
      ),
      body: Center(
        child: Text('Payment Gateway Integration Here'),
      ),
    );
  }
}
