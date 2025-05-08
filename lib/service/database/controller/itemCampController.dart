import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:b_camp/service/database/model/Kamar.dart';

class ItemCampController {
  static const String baseUrl = 'https://kampunginggrismu.com/api';

  static Future<List<Kamar>> getCamps() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/kamar'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        final List<dynamic> kamarData = responseData['data'] ?? responseData;
        return kamarData.map((json) => Kamar.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch camps: ${response.body}');
      }
    } catch (e) {
      print('Error fetching camps: $e');
      rethrow;
    }
  }

  static Future<Kamar> getCampDetail(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/kamar/$id'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        return Kamar.fromJson(responseData['data'] ?? responseData);
      } else {
        throw Exception('Failed to fetch camp details: ${response.body}');
      }
    } catch (e) {
      print('Error fetching camp details: $e');
      rethrow;
    }
  }
}
