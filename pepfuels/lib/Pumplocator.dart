import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PumpLocator extends StatefulWidget {
  final int selectedLiters;

  const PumpLocator({Key? key, required this.selectedLiters}) : super(key: key);

  @override
  _PumpLocatorState createState() => _PumpLocatorState();
}

class _PumpLocatorState extends State<PumpLocator> {
  String location = 'Delhi, India'; // Default location
  String fuelType = 'Petrol'; // Default fuel type
  double radius = 5; // Default radius in Km
  GoogleMapController? mapController; // Nullable GoogleMapController

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            '../assets/images/logo.png', // Ensure this path is correct and matches your pubspec.yaml
            width: 200,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextField(
                        decoration: InputDecoration(
                          labelText: 'Location',
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          setState(() {
                            location = value;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      DropdownButtonFormField<String>(
                        value: fuelType,
                        decoration: InputDecoration(
                          labelText: 'Fuel Type',
                          border: OutlineInputBorder(),
                        ),
                        items: ['Petrol', 'Diesel'].map((String type) {
                          return DropdownMenuItem<String>(
                            value: type,
                            child: Text(type),
                          );
                        }).toList(),
                        onChanged: (newValue) {
                          setState(() {
                            fuelType = newValue!;
                          });
                        },
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              'Search Radius (${radius.toInt()} Km)',
                              style: TextStyle(fontSize: 16),
                            ),
                          ),
                          Expanded(
                            child: Slider(
                              value: radius,
                              min: 1,
                              max: 50,
                              divisions: 49,
                              onChanged: (value) {
                                setState(() {
                                  radius = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Selected Quantity: ${widget.selectedLiters} Liters',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 20),
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        // Add logic to locate petrol pumps on map
                      },
                      child: Text('Locate Petrol Pump on Map'),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        // Add logic to show list of petrol pumps
                      },
                      child: Text('List of Petrol Pumps'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(28.7041, 77.1025), // Centered at Delhi, India
                zoom: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
