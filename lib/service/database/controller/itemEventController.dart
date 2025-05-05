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
      print('Event Status Code: ${response.statusCode}');
      print('Event Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        
        if (responseData['status'] == 'success' && responseData['data'] is List) {
          return List<Map<String, dynamic>>.from(responseData['data']);
        } else {
          throw Exception('Invalid response format');
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
