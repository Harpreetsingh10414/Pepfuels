import 'package:flutter/material.dart';
import './SubmitFormPagejeery.dart'; // Import the SubmitFormPagejeery page

class JerryCan extends StatefulWidget {
  const JerryCan({Key? key}) : super(key: key);

  @override
  _JerryCanState createState() => _JerryCanState();
}

class _JerryCanState extends State<JerryCan> {
  int _selectedLiters = 0;
  int _totalAmount = 0;
  String _dieselPrice = '';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    _dieselPrice = arguments['dieselPrice'] ?? '100'; // Default price if not available
  }

  void _calculateAmount(int liters) {
    setState(() {
      final pricePerLiter = int.tryParse(_dieselPrice) ?? 100; // Default to 100 if parsing fails
      _selectedLiters = liters;
      _totalAmount = liters * pricePerLiter; // Ensure result is an integer
    });
  }

  void _navigateToSubmitForm() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitFormPagejeery(
          dieselPrice: _dieselPrice,
          quantity: _selectedLiters,
          totalAmount: _totalAmount,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Image.asset(
            '../assets/images/logo.png', // Ensure this path is correct
            width: 200,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // To center title without a leading widget
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Container(
            color: Colors.black.withOpacity(0.7),
            height: 40,
            child: Center(
              child: Text(
                'Diesel Price: $_dieselPrice Rs/L',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: <Widget>[
          Image.asset(
            '../assets/images/background-img-for-all-internal.jpg', // Ensure this path is correct
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5), // Overlay shade
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Jerry Can',
                      style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        'Select Quantity (in liters):',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: <Widget>[
                            _buildQuantityButton(10),
                            SizedBox(height: 10), // Space between buttons
                            _buildQuantityButton(15),
                          ],
                        ),
                        SizedBox(width: 20), // Space between columns
                        Column(
                          children: <Widget>[
                            _buildQuantityButton(20),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: _totalAmount > 0 ? _navigateToSubmitForm : null,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Proceed to Submit Form'),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50), // Make button take full width
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuantityButton(int liters) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ElevatedButton.icon(
        onPressed: () => _calculateAmount(liters),
        icon: Icon(Icons.local_gas_station),
        label: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text('$liters Liters'),
        ),
        style: ElevatedButton.styleFrom(
          minimumSize: Size(150, 50), // Adjust size to fit in column
        ),
      ),
    );
  }
}
