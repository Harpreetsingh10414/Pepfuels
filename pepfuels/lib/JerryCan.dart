import 'package:flutter/material.dart';

class JerryCan extends StatefulWidget {
  @override
  _JerryCanState createState() => _JerryCanState();
}

class _JerryCanState extends State<JerryCan> {
  int _selectedLiters = 0;
  int _totalAmount = 0;

  void _calculateAmount(int liters) {
    setState(() {
      _selectedLiters = liters;
      _totalAmount = liters * 100; // 100rs per liter
    });
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
              padding: const EdgeInsets.all(20.0),
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
                  Wrap(
                    spacing: 20,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton.icon(
                          onPressed: () => _calculateAmount(5),
                          icon: Icon(Icons.local_gas_station),
                          // label: Text('5 Liters'),
                          label: Padding(
                            padding: const EdgeInsets.all(
                                20.0), // Adjust padding as needed
                            child: Text('5 Liters'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton.icon(
                          onPressed: () => _calculateAmount(10),
                          icon: Icon(Icons.local_gas_station),
                          // label: Text('10 Liters'),
                          label: Padding(
                            padding: const EdgeInsets.all(
                                20.0), // Adjust padding as needed
                            child: Text('10 Liters'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton.icon(
                          onPressed: () => _calculateAmount(15),
                          icon: Icon(Icons.local_gas_station),
                          // label: Text('15 Liters'),
                          label: Padding(
                            padding: const EdgeInsets.all(
                                20.0), // Adjust padding as needed
                            child: Text('15 Liters'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton.icon(
                          onPressed: () => _calculateAmount(20),
                          icon: Icon(Icons.local_gas_station),
                          // label: Text('20 Liters'),
                          label: Padding(
                            padding: const EdgeInsets.all(
                                20.0), // Adjust padding as needed
                            child: Text('20 Liters'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton.icon(
                          onPressed: () => _calculateAmount(25),
                          icon: Icon(Icons.local_gas_station),
                          // label: Text('25 Liters'),
                          label: Padding(
                            padding: const EdgeInsets.all(
                                20.0), // Adjust padding as needed
                            child: Text('25 Liters'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton.icon(
                          onPressed: () => _calculateAmount(30),
                          icon: Icon(Icons.local_gas_station),
                          // label: Text('30 Liters'),
                          label: Padding(
                            padding: const EdgeInsets.all(
                                20.0), // Adjust padding as needed
                            child: Text('30 Liters'),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
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
                      // child: Text('Proceed to Payment'),
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
    home: JerryCan(),
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
