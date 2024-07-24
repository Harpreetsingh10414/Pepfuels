import 'package:flutter/material.dart';
import 'package:pepfuels/HomePage.dart';
import 'package:pepfuels/LoginPage.dart' as login;
import 'package:pepfuels/registerPage.dart' as register;
import 'package:pepfuels/DoorStep.dart' as doorstep;
import 'package:pepfuels/JerryCan.dart' as jerrycan;
import 'package:pepfuels/BulkOrder.dart' as bulkorder;
import 'package:pepfuels/Fuel.dart' as fuel;

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
        '/': (context) => HomePage(),
        'login': (context) => login.LoginPage(),
        'register': (context) => register.RegisterPage(),
        'doorstep': (context) => doorstep.Doorstep(),
        'jerrycan': (context) => jerrycan.JerryCan(),
        'bulkorder': (context) => bulkorder.BulkOrder(),
        'fuel': (context) => fuel.Fuel(),

      },
    );
  }
}
