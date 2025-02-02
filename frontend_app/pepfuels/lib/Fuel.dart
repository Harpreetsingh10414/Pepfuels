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
        backgroundColor: Color(0xFFD3D3D3), // Light gray color for the header
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // Replace with your logo image path
              height: 50, // Adjust the height of the logo as needed
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          Image.asset(
            'assets/images/background-img-for-all-internal.jpg', // Adjust path as needed
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.3), // Adjust overlay for better text visibility
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gradient content container
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0),
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(148, 217, 0, 255),
                          Color.fromARGB(144, 243, 229, 245)
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Say goodbye to a fuel station!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "We're an on-demand fuel delivery application that allows users to order fuel for their  Equipments & Heavy fleets  anytime, anywhere.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 30), // Space between text and buttons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            // Fuel at Doorstep Button
                            _buildGradientSquareButton(
                              icon: Icons.local_gas_station,
                              label: 'Doorstep',
                              onPressed: () {
                                Navigator.pushNamed(context, 'doorstep');
                              },
                            ),
                            // Fuel at Ro Button
                            // _buildGradientSquareButton(
                            //   icon: Icons.local_gas_station,
                            //   label: 'Outlet',
                            //   onPressed: () {
                            //     Navigator.pushNamed(context, 'ro');
                            //   },
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGradientSquareButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [const Color.fromARGB(255, 255, 255, 255), const Color.fromARGB(255, 255, 255, 255)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: Size(120, 120), // Ensure square shape
          backgroundColor: Colors.transparent, // Transparent background for gradient
          shadowColor: Colors.transparent, // No shadow
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.black,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              label,
              style: TextStyle(fontSize: 16, color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Fuel(),
    routes: {
      'doorstep': (context) => DoorstepPage(),
      'ro': (context) => RoPage(),
    },
  ));
}

class DoorstepPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fuel at Doorstep'),
      ),
      body: Center(
        child: Text('Fuel at Doorstep Page Content'),
      ),
    );
  }
}

class RoPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fuel at Ro'),
      ),
      body: Center(
        child: Text('Fuel at Ro Page Content'),
      ),
    );
  }
}
