import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PetrolPumpPage extends StatefulWidget {
  final int quantity;
  final double radius;
  final double latitude;
  final double longitude;

  const PetrolPumpPage({
    Key? key,
    required this.quantity,
    required this.radius,
    required this.latitude,
    required this.longitude,
  }) : super(key: key);

  @override
  _PetrolPumpPageState createState() => _PetrolPumpPageState();
}

class _PetrolPumpPageState extends State<PetrolPumpPage> {
  List<dynamic> _petrolPumps = [];

  @override
  void initState() {
    super.initState();
    _fetchPetrolPumps();
  }

  Future<void> _fetchPetrolPumps() async {
    final response = await http.get(
      Uri.parse(
        'http://localhost:5000/api/petrolPumps?latitude=${widget.latitude}&longitude=${widget.longitude}&radius=${widget.radius}',
      ),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _petrolPumps = data['results'] ?? [];
      });
    } else {
      // Handle the error here
      print('Failed to load petrol pumps');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Petrol Pumps'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display selected quantity and radius
            Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16.0),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Selected Fuel Quantity: ${widget.quantity} liters',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Search Radius: ${widget.radius} km',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const Text(
              'List of Petrol Pumps in this area:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Expanded(
              child: ListView.builder(
                itemCount: _petrolPumps.length,
                itemBuilder: (context, index) {
                  final pump = _petrolPumps[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 8.0),
                    child: ListTile(
                      leading: Image.network(pump['icon']),
                      title: Text(pump['name']),
                      subtitle: Text(pump['vicinity']),
                      trailing: Text(pump['rating'] != null ? '${pump['rating']} ⭐' : 'No rating'),
                      isThreeLine: true,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
