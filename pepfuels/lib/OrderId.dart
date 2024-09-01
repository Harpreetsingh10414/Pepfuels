import 'package:flutter/material.dart';

class OrderId extends StatelessWidget {
  final String orderID;
  final double quantity;
  final String fuelType;
  final double totalAmount;
  final String deliveryAddress;
  final String mobile;
  final String name;
  final String email;

  const OrderId({
    Key? key,
    required this.orderID,
    required this.quantity,
    required this.fuelType,
    required this.totalAmount,
    required this.deliveryAddress,
    required this.mobile,
    required this.name,
    required this.email,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Debugging information to ensure data is passed correctly
    print("Order ID: $orderID");
    print("Quantity: $quantity");
    print("Fuel Type: $fuelType");
    print("Total Amount: $totalAmount");
    print("Delivery Address: $deliveryAddress");
    print("Mobile: $mobile");
    print("Name: $name");
    print("Email: $email");

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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  'Order Details',
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                buildOrderDetail('Order ID', orderID),
                buildOrderDetail('Quantity', '$quantity Liters'),
                buildOrderDetail('Fuel Type', fuelType),
                buildOrderDetail('Total Amount', '$totalAmount Rs'),
                buildOrderDetail('Delivery Address', deliveryAddress),
                buildOrderDetail('Mobile', mobile),
                buildOrderDetail('Name', name),
                buildOrderDetail('Email', email),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.popUntil(
                      context,
                      ModalRoute.withName('fuel'),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Text('Back to Home'),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildOrderDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 20,
          color: Colors.white,
        ),
      ),
    );
  }
}
