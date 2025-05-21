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
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
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
        'data': {
          'token': token
        }
      };
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    String? phoneNumber,
    String? address,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/register'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'name': name,
          'email': email,
          'password': password,
          'phone_number': phoneNumber,
          'address': address,
        }),
      );

      // Print response for debugging
      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 201) {
        return jsonDecode(response.body);
      } else {
        throw Exception('Failed to register: ${response.body}');
      }
    } catch (e) {
      print('Registration error: $e'); // Debug error
      throw Exception('Registration error: $e');
    }
  }
}