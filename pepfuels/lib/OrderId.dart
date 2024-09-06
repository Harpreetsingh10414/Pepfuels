import 'package:flutter/material.dart';

class OrderId extends StatelessWidget {
  final String orderId;

  // Constructor
  const OrderId({Key? key, required this.orderId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debugging print to ensure that the orderId is received
    print('Order ID received: $orderId');

    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 200,
            height: 50,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Text(
                'Order Details',
                style: TextStyle(color: Colors.white, fontSize: 20),
              );
            },
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/background-loginn-pg.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(color: Colors.black);
            },
          ),
          Container(
            color: Colors.black.withOpacity(0.1),
          ),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    Icons.check_circle,
                    color: Colors.green,
                    size: 100,
                  ),
                  SizedBox(height: 20),
                  Text(
                    'Order Placed Successfully Check your  order ',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  // Display the order ID here or show a default message if it's empty
                  // Text(
                  //   orderId.isNotEmpty ? orderId : 'Order ID not found',
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     color: Colors.white,
                  //   ),
                  //   textAlign: TextAlign.center,
                  // ),
                  SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to the 'TrackingPage' when the button is pressed
                      Navigator.pushNamed(
                        context,
                        'tracking', // Ensure this route is defined in your route settings
                        arguments: orderId, // Pass the orderId to TrackingPage if needed
                      );
                    },
                    child: Text('Track Your Order'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50),
                      backgroundColor: Colors.green,
                      
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
