import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:b_camp/service/api_service.dart'; 

class AuthService {
  static const String baseUrl = 'https://kampunginggrismu.com/api'; // Update this with your Laravel domain

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      print('Attempting login with: email=${email.trim()}, passwordLength=${password.length}');
      
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email.trim(),
          'password': password,
        }),
      );

      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Full Response Body: ${response.body}');

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == 'success') {
          final token = responseData['data']?['token'];
          if (token != null) {
            
            final prefs = await SharedPreferences.getInstance();
            await prefs.setString('auth_token', token);
            
            ApiService.setToken(token);
            print('Token set successfully');
          } else {
            print('Warning: No token in success response');
          }
          return responseData;
        } else {
          throw Exception(responseData['message'] ?? 'Unknown error occurred');
        }
      } else {
        print('Error response: ${response.body}');
        throw Exception(responseData['message'] ?? 
            'Server returned status code: ${response.statusCode}');
      }
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