import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SelectState extends StatefulWidget {
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
      appBar: AppBar(title: Text('Select State')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedState,
              hint: Text('Select a state'),
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
                style: TextStyle(fontSize: 24),
              ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: dieselPrice.isNotEmpty ? handleSubmit : null,
              child: Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }
}
