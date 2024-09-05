import 'package:flutter/material.dart';

class OrderId extends StatelessWidget {
  const OrderId({Key? key}) : super(key: key);

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
                    'Your order is successfully placed',
                    style: TextStyle(
                      fontSize: 24,
                      color: const Color.fromARGB(255, 0, 0, 0),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 40), // Space between the message and button
                  ElevatedButton(
                    onPressed: () {
                      Navigator.popUntil(
                        context,
                        ModalRoute.withName('fuel'), // Navigate back to the home page
                      );
                    },
                    child: Text('Back to Home'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50), // Full-width button
                      backgroundColor: Colors.green, // Button color
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
