import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:b_camp/service/api_service.dart'; 


class ItemCampController {
  static const String baseUrl =
      'https://kampunginggrismu.com/api'; // Ganti dengan URL API Anda

  // Fungsi untuk GET data camp
  static Future<List<Map<String, dynamic>>> getCamps() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/kamar'), // Endpoint untuk mendapatkan data camp
        headers: {'Accept': 'application/json'},
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
        throw Exception('Failed to fetch camps: ${response.body}');
      }
    } catch (e) {
      print('Error fetching camps: $e');
      rethrow;
    }
  }
}
