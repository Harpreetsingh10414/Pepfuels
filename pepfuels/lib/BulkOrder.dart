import 'package:flutter/material.dart';
import './SubmitFormPagebulk.dart'; // Import the SubmitFormPage

class BulkOrder extends StatefulWidget {
  final String dieselPrice;

  const BulkOrder({Key? key, required this.dieselPrice}) : super(key: key);

  @override
  _BulkOrderState createState() => _BulkOrderState();
}

class _BulkOrderState extends State<BulkOrder> {
  final TextEditingController _litersController = TextEditingController();
  String _errorText = '';
  int _totalAmount = 0;

  void _calculateAmount() {
    final double pricePerLiter = double.tryParse(widget.dieselPrice) ?? 100.0; // Default to 100 if parsing fails
    final int selectedLiters = int.tryParse(_litersController.text) ?? 0;

    if (selectedLiters < 500 || selectedLiters > 12000) {
      setState(() {
        _errorText = 'Please enter a quantity between 500 and 12,000 liters.';
        _totalAmount = 0;
      });
    } else {
      setState(() {
        _errorText = '';
        _totalAmount = ((selectedLiters * pricePerLiter) + 100).toInt(); // Convert to int for display
      });
    }
  }

  void _submit() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SubmitFormPagebulk(
          dieselPrice: widget.dieselPrice,
          quantity: int.tryParse(_litersController.text) ?? 0,
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
            '../assets/images/logo.png',
            width: 200,
            height: 50,
            fit: BoxFit.contain,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Container(
            color: Colors.black.withOpacity(0.7),
            height: 40,
            child: Center(
              child: Text(
                'Diesel Price: ${widget.dieselPrice} Rs/L',
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
            '../assets/images/background-img-for-all-internal.jpg',
            width: double.infinity,
            height: double.infinity,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black.withOpacity(0.5),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      'Bulk Order',
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
                        'Enter Quantity (in liters):',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: _litersController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.white,
                        hintText: 'Enter liters',
                        errorText: _errorText.isEmpty ? null : _errorText,
                      ),
                      onChanged: (value) => _calculateAmount(),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Total Amount: $_totalAmount Rs',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: ElevatedButton(
                        onPressed: _totalAmount > 0 ? _submit : null,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text('Proceed to Submit Form'),
                        ),
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
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
}
