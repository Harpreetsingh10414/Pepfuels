import 'package:flutter/material.dart';

class BulkOrder extends StatefulWidget {
  @override
  _BulkOrderState createState() => _BulkOrderState();
}

class _BulkOrderState extends State<BulkOrder> {
  int _selectedLiters = 0;  // Initialize to 0
  int _totalAmount = 0;

  void _calculateAmount(int liters) {
    setState(() {
      _selectedLiters = liters;
      _totalAmount = liters * 100; // 100rs per liter
    });
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
                    padding: const EdgeInsets.all(20.0),
                    child: Text(
                      'Select Quantity (in liters):',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      'Total Amount: $_totalAmount Rs',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton(
                      onPressed: _totalAmount > 0
                          ? () {
                              // Add your payment gateway integration here
                              Navigator.pushNamed(context, 'payment');
                            }
                          : null,
                      child: Padding(
                        padding: const EdgeInsets.all(
                            20.0), // Adjust padding as needed
                        child: Text('Proceed to Payment'),
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
          ],
        ),
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
