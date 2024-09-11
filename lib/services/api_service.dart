import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService(this.baseUrl);

  Future<void> createVolunteer(String name, String email, String phone) async {
    final url = Uri.parse('$baseUrl/volunteers');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': name,
        'email': email,
        'phone': phone,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to create volunteer');
    }
  }

  Future<void> allocateTrip(String firebaseTripId) async {
    final url = Uri.parse('$baseUrl/allocate_trip');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'firebase_trip_id': firebaseTripId}),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to allocate trip');
    }
  }
}
