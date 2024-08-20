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
import 'SubmitFormPage.dart'; // Import SubmitFormPage
import 'CommonLayout.dart';

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
        'bulkorder': (context) =>
            CommonLayout(child: const bulkorder.BulkOrder(), currentIndex: 2),
        'profile': (context) =>
            CommonLayout(child: const profile.ProfilePage(), currentIndex: 3),
        'fuel': (context) =>
            CommonLayout(child: const fuel.Fuel(), currentIndex: 0),
        'pumplocator': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, int>;
          final selectedLiters = args?['selectedLiters'] ?? 0;

          return CommonLayout(
            child: pumplocator.PumpLocator(selectedLiters: selectedLiters),
            currentIndex: 0,
          );
        },
        'orderid': (context) {
          final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>;
          final selectedLiters = args['selectedLiters'] ?? 0;
          final fuelType = args['fuelType'] ?? 'petrol';
          
          return CommonLayout(
            child: orderid.OrderId(selectedLiters: selectedLiters, fuelType: fuelType),
            currentIndex: 0,
          );
        },
        'submitForm': (context) => const SubmitFormPage(), // Add SubmitFormPage route
      },
    );
  }
}
