import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> fetchProtectedResource() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('jwtToken');

  if (token == null) {
    print('No token found');
    return;
  }

  final response = await http.get(
    Uri.parse('http://localhost:5000/api/protected'),
    headers: {'Authorization': 'Bearer $token'},
  );

  if (response.statusCode == 200) {
    print('Protected resource: ${response.body}');
  } else {
    print('Failed to fetch protected resource');
  }
}
