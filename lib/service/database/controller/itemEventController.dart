import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ItemEventController {
  static const String baseUrl =
      'https://kampunginggrismu.com/api'; // Ganti dengan URL API Anda

  // Fungsi untuk GET data event
  static Future<List<Map<String, dynamic>>> getEvents() async {
    try {
      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token not found. Please log in again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/aplikasi_event'), // Endpoint untuk mendapatkan data event
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Tambahkan token ke header
        },
      );

      // Debugging: Print response
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Pastikan responseData adalah list
        if (responseData is List) {
          return List<Map<String, dynamic>>.from(responseData);
        } else {
          throw Exception('Unexpected response format');
        }
      } else {
        throw Exception('Failed to fetch events: ${response.body}');
      }
    } catch (e) {
      print('Error fetching events: $e');
      rethrow;
    }
  }
}
