import 'package:flutter/material.dart';

class CommonLayout extends StatefulWidget {
  final Widget child;
  final int currentIndex;

  const CommonLayout({required this.child, required this.currentIndex, Key? key}) : super(key: key);

  @override
  _CommonLayoutState createState() => _CommonLayoutState();
}

class _CommonLayoutState extends State<CommonLayout> {
  void _onItemTapped(int index) {
    if (index != widget.currentIndex) {
      switch (index) {
        case 0:
          // Reset the navigation stack when going to Home
          Navigator.pushNamedAndRemoveUntil(context, 'fuel', (route) => false);
          break;
        case 1:
          Navigator.pushReplacementNamed(context, 'selectState', arguments: {'navigateTo': 'jerrycan'});
          break;
        case 2:
          Navigator.pushReplacementNamed(context, 'selectState', arguments: {'navigateTo': 'bulkorder'});
          break;
        case 3:
          Navigator.pushReplacementNamed(context, 'profile');
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.black,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_gas_station),
            label: 'Jerry Can',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_shipping),
            label: 'Bulk Order',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: widget.currentIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}
