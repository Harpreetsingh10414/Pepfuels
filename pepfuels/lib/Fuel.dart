import 'package:flutter/material.dart';

class Fuel extends StatefulWidget {
  const Fuel({super.key});

  @override
  _FuelState createState() => _FuelState();
}

class _FuelState extends State<Fuel> {
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
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Fuel',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 20), // Add spacing after the heading
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, 'doorstep');
                      },
                      icon: Icon(Icons.local_gas_station),
                      label: Padding(
                        padding: const EdgeInsets.all(20.0), // Adjust padding as needed
                        child: Text('Fuel at Doorstep'),
                      ),
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50), // Make button take full width
                      ),
                    ),
                  ),
                  SizedBox(height: 10), // Add spacing between buttons
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, '#');
                      },
                      icon: Icon(Icons.local_gas_station),
                      label: Padding(
                        padding: const EdgeInsets.all(20.0), // Adjust padding as needed
                        child: Text('Fuel at Ro'),
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
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Fuel(),
    routes: {
      'jerrycan': (context) => JerryCanPage(), // Define your JerryCanPage here
      'bulkorder': (context) => BulkOrderPage(), // Define your BulkOrderPage here
    },
  ));
}

// Placeholder for JerryCanPage, replace with your actual JerryCanPage implementation
class JerryCanPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jerry Can'),
      ),
      body: Center(
        child: Text('Jerry Can Page Content'),
      ),
    );
  }
}

// Placeholder for BulkOrderPage, replace with your actual BulkOrderPage implementation
class BulkOrderPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bulk Order'),
      ),
      body: Center(
        child: Text('Bulk Order Page Content'),
      ),
    );
  }
}
