import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

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
  LocationData? currentLocation;
  final Location location = Location();

  @override
  void initState() {
    super.initState();
    _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check if the location service is enabled
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check for location permission
    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Fetch the current location
    currentLocation = await location.getLocation();
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    if (currentLocation != null) {
      mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(
              currentLocation!.latitude!,
              currentLocation!.longitude!,
            ),
            zoom: 14,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            'assets/images/logo.png',
            width: 200,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: currentLocation == null
          ? Center(child: CircularProgressIndicator())
          : GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  currentLocation!.latitude!,
                  currentLocation!.longitude!,
                ),
                zoom: 14,
              ),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
    );
  }
}
