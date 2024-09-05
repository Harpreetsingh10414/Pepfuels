import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';

class SelectState extends StatefulWidget {
  const SelectState({super.key});

  @override
  _SelectStateState createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  List<String> states = [];
  String? selectedState;
  String dieselPrice = '';
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchStates();

    // Add listener to the searchController
    searchController.addListener(() {
      setState(() {
        selectedState = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchStates() async {
    try {
      final response = await http.get(Uri.parse('http://184.168.120.64:5000/api/states'));
      if (response.statusCode == 200) {
        setState(() {
          states = List<String>.from(json.decode(response.body));
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
          dieselPrice = json.decode(response.body)['price'].toString();
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
        backgroundColor: const Color(0xFFD3D3D3),
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 200,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            'assets/images/background-img-for-all-internal.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.3),
          ),
          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
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
                        DropdownSearch<String>(
                          items: states,
                          selectedItem: selectedState,
                          onChanged: (String? newState) {
                            setState(() {
                              selectedState = newState;
                              dieselPrice = '';
                              searchController.text = newState ?? ''; // Update the text field with the selected state
                            });
                            if (newState != null) {
                              fetchDieselPrice(newState);
                            }
                          },
                          dropdownDecoratorProps: DropDownDecoratorProps(
                            dropdownSearchDecoration: InputDecoration(
                              labelText: "Select a state",
                              fillColor: Colors.white,
                              filled: true,
                              labelStyle: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          popupProps: PopupProps.menu(
                            showSearchBox: true,
                            searchFieldProps: TextFieldProps(
                              controller: searchController, // Attach the controller
                              autofocus: true,
                              decoration: InputDecoration(
                                hintText: "Search or enter a state",
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
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
                            backgroundColor: Colors.purpleAccent,
                            foregroundColor: Colors.white,
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
     
    );
  }
}
