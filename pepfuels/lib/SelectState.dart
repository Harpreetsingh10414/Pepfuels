import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectState extends StatefulWidget {
  const SelectState({super.key});

  @override
  _SelectStateState createState() => _SelectStateState();
}

class _SelectStateState extends State<SelectState> {
  List<Map<String, dynamic>> cities = [];
  String? selectedCity;
  String dieselPrice = '';
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;
  String errorMessage = '';
  FocusNode focusNode = FocusNode();  // FocusNode to track focus state

  @override
  void initState() {
    super.initState();
    fetchCities();

    // Add listener to the searchController
    searchController.addListener(() {
      setState(() {
        selectedCity = searchController.text;
      });
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    focusNode.dispose();  // Dispose of focusNode
    super.dispose();
  }

  Future<void> fetchCities() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('jwtToken');

    if (token == null) {
      setState(() {
        errorMessage = 'No token found. Please log in again.';
        isLoading = false;
      });
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('http://184.168.120.64:5000/api/cities'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        setState(() {
          cities = (responseBody as List).map((city) {
            return {
              'name': city['name'],
              'dieselPrice': city['dieselPrice'] is int
                  ? (city['dieselPrice'] as int).toDouble()
                  : city['dieselPrice'] as double,
            };
          }).toList();
          isLoading = false;
        });
      } else {
        setState(() {
          errorMessage = 'Failed to load cities. Status code: ${response.statusCode}';
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'An error occurred: $e';
        isLoading = false;
      });
    }
  }

  void fetchDieselPrice(String cityName) {
    final selectedCityData = cities.firstWhere(
      (city) => city['name'] == cityName,
      orElse: () => {'dieselPrice': 0.0},
    );
    setState(() {
      dieselPrice = selectedCityData['dieselPrice'].toString();
    });
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
                          'Select City',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Choose a city to see the diesel price.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        isLoading
                            ? Center(child: CircularProgressIndicator())
                            : DropdownSearch<String>(
                                items: cities.map((city) => city['name'] as String).toList(),
                                selectedItem: selectedCity,
                                onChanged: (String? newCity) {
                                  setState(() {
                                    selectedCity = newCity;
                                    dieselPrice = '';
                                    searchController.text = newCity ?? ''; // Update the text field with the selected city
                                  });
                                  if (newCity != null) {
                                    fetchDieselPrice(newCity);
                                  }
                                },
                                dropdownDecoratorProps: DropDownDecoratorProps(
                                  dropdownSearchDecoration: InputDecoration(
                                    labelText: focusNode.hasFocus ? null : "Select a city", // Hide label when focused
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelStyle: TextStyle(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                ),
                                popupProps: PopupProps.menu(
                                  showSearchBox: true,
                                  searchFieldProps: TextFieldProps(
                                    controller: searchController,
                                    focusNode: focusNode,  // Attach the focusNode
                                    autofocus: true,
                                    decoration: InputDecoration(
                                      hintText: "Search or enter a city",
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
