import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectState extends StatefulWidget {
   const SelectState({super.key});
  @override
  _SelectStateState createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  List<String> states = [];
  String? selectedState;
  String dieselPrice = '';

  @override
  void initState() {
    super.initState();
    fetchStates();
  }

  Future<void> fetchStates() async {
    try {
      final response = await http.get(Uri.parse('http://184.168.120.64:5000/api/states'));
      if (response.statusCode == 200) {
        setState(() {
          states = List<String>.from(json.decode(response.body)); // Assuming API returns a list of state names
        });
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> fetchDieselPrice(String state) async {
    try {
      final response = await http.get(Uri.parse('http://184.168.120.64:5000/api/dieselPrices/$state'));
      if (response.statusCode == 200) {
        setState(() {
          dieselPrice = json.decode(response.body)['price'].toString(); // Assuming API returns {"price": value}
        });
      } else {
        // Handle error
      }
    } catch (e) {
      // Handle error
    }
  }

  void handleSubmit() {
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, String>;
    final navigateTo = args['navigateTo'] ?? '';

    if (dieselPrice.isNotEmpty) {
      Navigator.pushNamed(
        context,
        navigateTo,
        arguments: {'dieselPrice': dieselPrice},
      );
    }
  }

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
                          'Select State',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Choose a state to see the diesel price.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        DropdownButton<String>(
                          value: selectedState,
                          hint: Text('Select a state'),
                          dropdownColor: Colors.black, // Dropdown background color
                          style: TextStyle(color: Colors.white), // Dropdown text color
                          items: states.map((String state) {
                            return DropdownMenuItem<String>(
                              value: state,
                              child: Text(state),
                            );
                          }).toList(),
                          onChanged: (String? newState) {
                            setState(() {
                              selectedState = newState;
                              dieselPrice = ''; // Reset diesel price when state changes
                            });
                            if (newState != null) {
                              fetchDieselPrice(newState);
                            }
                          },
                        ),
                        SizedBox(height: 20),
                        if (dieselPrice.isNotEmpty)
                          Text(
                            'Diesel Price: $dieselPrice',
                            style: TextStyle(fontSize: 24, color: Colors.white),
                          ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: dieselPrice.isNotEmpty ? handleSubmit : null,
                          style: ElevatedButton.styleFrom(
                            
                          ),
                          child: Text('Submit'),
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
      bottomNavigationBar: BottomAppBar(
        child: Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(148, 217, 0, 255),
                Color.fromARGB(144, 243, 229, 245)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '© 2024 PepFuel',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
