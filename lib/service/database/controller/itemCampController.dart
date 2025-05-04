import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:b_camp/service/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ItemCampController {
  static const String baseUrl =
      'https://kampunginggrismu.com/api'; // Ganti dengan URL API Anda

  // Fungsi untuk GET data camp
  static Future<List<Map<String, dynamic>>> getCamps() async {
    try {
      // Ambil token dari SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        throw Exception('Token not found. Please log in again.');
      }

      final response = await http.get(
        Uri.parse('$baseUrl/kamar'), // Endpoint untuk mendapatkan data camp
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // Tambahkan token ke header
        },
      );

      // Debugging: Print response
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> responseData = jsonDecode(response.body);
        return responseData.map((item) => item as Map<String, dynamic>).toList();
      } else {
        throw Exception('Failed to fetch camps: ${response.body}');
      }
    } catch (e) {
      print('Error fetching camps: $e');
      rethrow;
    }
  }
}
