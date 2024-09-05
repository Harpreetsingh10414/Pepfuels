import 'package:flutter/material.dart';

class TrackingPage extends StatelessWidget {
  const TrackingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tracking'),
        backgroundColor: Colors.blue, // Adjust color as needed
      ),
      body: Center(
        child: Text('Tracking Page Content Goes Here'),
      ),
    );
  }
}
