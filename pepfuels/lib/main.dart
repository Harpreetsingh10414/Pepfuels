import 'package:flutter/material.dart';
import 'package:pepfuels/HomePage.dart';
import 'package:pepfuels/LoginPage.dart' as login;
import 'package:pepfuels/registerPage.dart' as register;
import 'package:pepfuels/DoorStep.dart' as doorstep;
import 'package:pepfuels/JerryCan.dart' as jerrycan;
import 'package:pepfuels/BulkOrder.dart' as bulkorder;
import 'package:pepfuels/ProfilePage.dart' as profile;
import 'package:pepfuels/Fuel.dart' as fuel;
import 'package:pepfuels/PumpLocator.dart' as pumplocator;
import 'package:pepfuels/OrderId.dart' as orderid;
import 'SubmitFormPagebulk.dart'; // Import the updated SubmitFormPagebulk
import 'SubmitFormPagejeery.dart'; // Import SubmitFormPagejeery
import 'CommonLayout.dart';
import 'SelectState.dart' as selectState; // Import SelectState page
import 'Tracking.dart'; // Import the Tracking page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        'login': (context) => const login.LoginPage(),
        'register': (context) => register.RegisterPage(),
        'doorstep': (context) =>
            CommonLayout(child: const doorstep.DoorStep(), currentIndex: 0),
        'jerrycan': (context) =>
            CommonLayout(child: const jerrycan.JerryCan(), currentIndex: 1),
        'bulkorder': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final dieselPrice = args?['dieselPrice'] as String? ?? '0';
          return CommonLayout(
            child: bulkorder.BulkOrder(dieselPrice: dieselPrice),
            currentIndex: 2,
          );
        },
        'profile': (context) =>
            CommonLayout(child: const profile.ProfilePage(), currentIndex: 3),
        'fuel': (context) =>
            CommonLayout(child: const fuel.Fuel(), currentIndex: 0),
        'pumplocator': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final selectedLiters = args?['selectedLiters'] ?? 0;

          return CommonLayout(
            child: pumplocator.PumpLocator(selectedLiters: selectedLiters),
            currentIndex: 0,
          );
        },
        'orderid': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final orderId = args?['orderId'] as String? ?? '';

          return CommonLayout(
            child: orderid.OrderId(orderId: orderId),
            currentIndex: 0,
          );
        },
        'submitFormBulk': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final dieselPrice = args?['dieselPrice'] as String? ?? '0';
          final quantity = args?['quantity'] as double? ?? 0;
          final totalAmount = args?['totalAmount'] as int? ?? 0;

          return SubmitFormPagebulk(
            dieselPrice: dieselPrice,
            quantity: quantity,
            totalAmount: totalAmount,
          );
        },
        'submitFormJerry': (context) {
          final args = ModalRoute.of(context)?.settings.arguments
              as Map<String, dynamic>?;
          final dieselPrice = args?['dieselPrice'] as String? ?? '0';
          final quantity = args?['quantity'] as int? ?? 0;
          final totalAmount = args?['totalAmount'] as int? ?? 0;

          return SubmitFormPagejeery(
            dieselPrice: dieselPrice,
            quantity: quantity,
            totalAmount: totalAmount,
          );
        },
        'selectState': (context) => CommonLayout(child: const selectState.SelectState(), currentIndex: 0), // Add SelectState route
        'tracking': (context) => CommonLayout(child: const TrackingPage(), currentIndex: 0), // Add Tracking route with CommonLayout
      },
    );
  }
}
