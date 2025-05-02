import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'https://kampunginggrismu.com/api'; // Replace with your API URL
  static String? _token;

  // Set token after login
  static void setToken(String token) {
    _token = token;
  }

  // Get request headers
  static Map<String, String> get _headers {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (_token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }
    return headers;
  }

  // GET method
  static Future<Map<String, dynamic>> get(String endpoint) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform GET request: $e');
    }
  }

  // POST method
  static Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform POST request: $e');
    }
  }

  // PUT method
  static Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
        body: jsonEncode(data),
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform PUT request: $e');
    }
  }

  // DELETE method
  static Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/$endpoint'),
        headers: _headers,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to perform DELETE request: $e');
    }
  }

  // Upload file with multipart request
  static Future<Map<String, dynamic>> uploadFile(String endpoint, String filePath, {Map<String, String>? additionalFields}) async {
    try {
      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/$endpoint'));
      
      // Add headers
      request.headers.addAll(_headers);

      // Add file
      request.files.add(await http.MultipartFile.fromPath('file', filePath));

      // Add additional fields if any
      if (additionalFields != null) {
        request.fields.addAll(additionalFields);
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);
      
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Failed to upload file: $e');
    }
  }

  // Handle API response
  static Map<String, dynamic> _handleResponse(http.Response response) {
    try {
      // Check if response is HTML
      if (response.body.trim().startsWith('<!DOCTYPE html>')) {
        throw Exception('Invalid server response - received HTML instead of JSON');
      }

      final body = jsonDecode(response.body);
      
      if (response.statusCode >= 200 && response.statusCode < 300) {
        return body;
      } else {
        throw Exception(body['message'] ?? 'Request failed with status: ${response.statusCode}');
      }
    } catch (e) {
      if (e is FormatException) {
        throw Exception('Invalid response format: ${response.body.substring(0, 100)}...');
      }
      throw Exception('Error processing response: $e');
    }
  }
}