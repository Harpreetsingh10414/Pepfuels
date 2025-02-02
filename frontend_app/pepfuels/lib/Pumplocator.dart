import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:geolocator/geolocator.dart';
import 'petrol_pump_page.dart'; // Import the PetrolPumpPage class
import './Constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class PumpLocator extends StatefulWidget {
  final int selectedLiters;

  const PumpLocator({
    Key? key,
    required this.selectedLiters,
  }) : super(key: key);

  @override
  _PumpLocatorState createState() => _PumpLocatorState();
}

class _PumpLocatorState extends State<PumpLocator> {
  GoogleMapController? mapController;
  LatLng? currentLocation;
  LatLng? selectedLocationCoordinates;
  Set<Marker> markers = {};
  double _sliderValue = 100.0;
  String? selectedLocation;
  List<String> _locations = [];
  Map<String, LatLng> _locationCoordinates = {
    'Kochi': LatLng(9.9312, 76.2673),
    'Delhi': LatLng(28.6139, 77.2090),
    'Mumbai': LatLng(19.0760, 72.8777),
    // Add more locations and their coordinates
  };

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
    _fetchLocationsFromBackend();
  }

  Future<void> _fetchCurrentLocation() async {
  try {
    print('Fetching current location...');

    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      print('Location services are disabled.');
      return;
    }

    // Check for location permissions.
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        print('Location permissions are denied.');
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      print('Location permissions are permanently denied.');
      return;
    }

    // Get the current location.
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    setState(() {
      currentLocation = LatLng(
        position.latitude,
        position.longitude,
      );
      markers.add(
        Marker(
          markerId: MarkerId("currentLocation"),
          position: currentLocation!,
          infoWindow: InfoWindow(title: "You are here"),
        ),
      );
      print('Current location: $currentLocation');
      if (mapController != null) {
        mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentLocation!, 14),
        );
      }
    });
  } catch (e) {
    print('Error: $e');
  }
}


  Future<void> _fetchLocationsFromBackend() async {
    print('Fetching locations from backend...');
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/google-places/search?query=cities+in+india'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Data received from backend: $data');

        if (data['results'] != null && data['results'] is List) {
          setState(() {
            _locations = List<String>.from(data['results'].map((item) {
              return item['name'] ?? item['formatted_address'] ?? 'Unknown Location';
            }));
            print('Locations populated: $_locations');
          });
        } else {
          print('Unexpected data format: ${data.toString()}');
        }
      } else {
        print('Failed to load locations from backend: ${response.statusCode}');
      }
    } catch (error) {
      print('Error fetching locations from backend: $error');
    }
  }

  void _updateLocation(LatLng newLocation) {
    print('Updating location to: $newLocation');
    setState(() {
      selectedLocationCoordinates = newLocation;
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId("selectedLocation"),
          position: newLocation,
          infoWindow: InfoWindow(title: "New Location"),
        ),
      );
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(newLocation, 14),
      );
    });
  }

  void _updateZoom(double radius) {
    print('Updating zoom level based on radius: $radius');
    double zoomLevel = 16 - (radius / 100); // Example calculation; adjust as needed
    if (selectedLocationCoordinates != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(selectedLocationCoordinates!, zoomLevel),
      );
    } else if (currentLocation != null) {
      mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation!, zoomLevel),
      );
    }
  }

  Future<void> _onLocationSelected(String? location) async {
    if (location != null) {
      print('Location selected: $location');
      
      LatLng? newLocation = await _getCoordinatesFromApi(location);
      
      if (newLocation == null) {
        print('Coordinates not found for location: $location');
        newLocation = _getFallbackCoordinatesForLocation(location);
      }
      
      if (newLocation != null) {
        _updateLocation(newLocation);
      }
    }
  }

  Future<LatLng?> _getCoordinatesFromApi(String location) async {
    try {
      final response = await http.get(
        Uri.parse('$BASE_URL/get-coordinates?location=$location'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['lat'] != null && data['lng'] != null) {
          return LatLng(data['lat'], data['lng']);
        }
      }
    } catch (error) {
      print('Error fetching coordinates from API: $error');
    }
    
    return null;
  }

  LatLng _getFallbackCoordinatesForLocation(String location) {
    const fallbackCoordinates = {
      'Delhi': LatLng(28.6139, 77.2090),
      'Mumbai': LatLng(19.0760, 72.8777),
      'Kolkata': LatLng(22.5726, 88.3639),
      'Chennai': LatLng(13.0827, 80.2707),
    };

    return fallbackCoordinates[location] ?? LatLng(20.5937, 78.9629);
  }

  void _goToNextPage() {
    if (selectedLocationCoordinates != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PetrolPumpPage(
            quantity: widget.selectedLiters, // Pass the quantity here
            latitude: selectedLocationCoordinates!.latitude,
            longitude: selectedLocationCoordinates!.longitude,
            radius: _sliderValue,
          ),
        ),
      );
    } else {
      print("Please select a location first.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            '../assets/images/logo.png',
            width: 200,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Text(
                  'Tap on the location on map to change the location',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                height: 300,
                child: currentLocation == null
                    ? const Center(child: CircularProgressIndicator())
                    : GoogleMap(
                        onMapCreated: (controller) {
                          mapController = controller;
                          if (currentLocation != null) {
                            mapController!.animateCamera(
                              CameraUpdate.newLatLngZoom(currentLocation!, 14),
                            );
                          }
                        },
                        initialCameraPosition: CameraPosition(
                          target: currentLocation ?? const LatLng(0.0, 0.0),
                          zoom: 14,
                        ),
                        markers: markers,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: true,
                        onTap: (LatLng newLocation) {
                          _updateLocation(newLocation);
                        },
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Select the radius to search',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            if (currentLocation != null) {
                              _updateLocation(currentLocation!);
                            }
                          },
                          child: const Text('Use Current Location'),
                        ),
                        Expanded(
                          child: Slider(
                            value: _sliderValue,
                            min: 50,
                            max: 500,
                            divisions: 9,
                            label: 'Radius: ${_sliderValue.toStringAsFixed(0)} km',
                            onChanged: (value) {
                              setState(() {
                                _sliderValue = value;
                              });
                              _updateZoom(_sliderValue);
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8.0),
                    const Padding(
                      padding: EdgeInsets.only(bottom: 8.0),
                      child: Text(
                        'Select Location',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedLocation,
                      items: _locations.map((String location) {
                        return DropdownMenuItem<String>(
                          value: location,
                          child: Text(location),
                        );
                      }).toList(),
                      onChanged: _onLocationSelected,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: _goToNextPage,
                      child: const Text('Find Petrol Pumps'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
