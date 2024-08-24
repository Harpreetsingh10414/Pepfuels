import 'package:flutter/material.dart';

class DoorStep extends StatelessWidget {
  const DoorStep({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFD3D3D3), // Light gray color for consistency
        title: Center(
          child: Image.asset(
            '../assets/images/logo.png', // Ensure this path is correct
            width: 200,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
        automaticallyImplyLeading: false, // To center title without a leading widget
      ),
      body: Stack(
        children: <Widget>[
          // Background image
          Image.asset(
            '../assets/images/background-img-for-all-internal.jpg', // Adjust path as needed
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.3), // Overlay for text visibility
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
                          'Doorstep',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Fuel delivered to your doorstep, anytime, anywhere.",
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
                            // Jerry Can Button
                            _buildGradientSquareButton(
                              icon: Icons.local_gas_station,
                              label: 'Jerry Can',
                              onPressed: () {
                                Navigator.pushNamed(context, 'jerrycan');
                              },
                            ),
                            // Bulk Order Button
                            _buildGradientSquareButton(
                              icon: Icons.shopping_cart,
                              label: 'Bulk Order',
                              onPressed: () {
                                Navigator.pushNamed(context, 'bulkorder');
                              },
                            ),
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
    home: DoorStep(),
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
