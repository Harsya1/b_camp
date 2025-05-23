import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:b_camp/service/api_service.dart';

class AuthService {
  static const String baseUrl = 'https://kampunginggrismu.com/api';

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('Requesting token for: $email');

      // Request token only
      final tokenResponse = await http.post(
        Uri.parse('$baseUrl/token'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'email': email.trim(), 'password': password}),
      );

      print('Token Status Code: ${tokenResponse.statusCode}');
      print('Token Response: ${tokenResponse.body}');

      final tokenData = jsonDecode(tokenResponse.body);

      if (tokenResponse.statusCode != 200) {
        throw Exception(tokenData['message'] ?? 'Failed to get token');
      }

      final token = tokenData['token'];
      if (token == null) {
        throw Exception('No token received');
      }

      // Save token
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);
      ApiService.setToken(token);

      // Return success response
      return {
        'status': 'success',
        'message': 'Login successful',
        'data': {'token': token},
      };
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }
}
