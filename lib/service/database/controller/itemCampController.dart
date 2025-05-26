import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';

class ItemCampController {
  static const String baseUrl = 'https://kampunginggrismu.com/api';
  static const String imageBaseUrl = 'https://kampunginggrismu.com';

  // Get all camps
  static Future<List<Map<String, dynamic>>> getCamps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('$baseUrl/camp'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Camps Status: ${response.statusCode}');
      print('Get Camps Response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load camps');
      }
    } catch (e) {
      print('Error getting camps: $e');
      rethrow;
    }
  }

  // Get camp detail
  static Future<Map<String, dynamic>> getCampDetail(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('$baseUrl/camp/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception('Failed to load camp detail');
      }
    } catch (e) {
      print('Error getting camp detail: $e');
      rethrow;
    }
  }

  // Create camp
  static Future<bool> createCamp({
    required String namaCamp,
    String? deskripsi,
    File? gambarCamp,
    required String alamat,
    required int jumlahMaksimalKamar,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/camp'));

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields.addAll({
        'nama_camp': namaCamp,
        if (deskripsi != null) 'deskripsi': deskripsi,
        'alamat': alamat,
        'jumlah_maksimal_kamar': jumlahMaksimalKamar.toString(),
      });

      if (gambarCamp != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'gambar_camp',
            gambarCamp.path,
            filename: path.basename(gambarCamp.path),
          ),
        );
      }

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      print('Create Camp Status: ${response.statusCode}');
      print('Create Camp Response: $responseData');

      return response.statusCode == 201;
    } catch (e) {
      print('Error creating camp: $e');
      rethrow;
    }
  }

  // Update camp
  static Future<bool> updateCamp({
    required int id,
    String? namaCamp,
    String? deskripsi,
    File? gambarCamp,
    String? alamat,
    int? jumlahMaksimalKamar,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/camp/$id'),
      );

      // Add method spoofing for Laravel
      request.fields['_method'] = 'PUT';

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      // Add text fields if they exist
      if (namaCamp != null) request.fields['nama_camp'] = namaCamp;
      if (deskripsi != null) request.fields['deskripsi'] = deskripsi;
      if (alamat != null) request.fields['alamat'] = alamat;
      if (jumlahMaksimalKamar != null) {
        request.fields['jumlah_maksimal_kamar'] =
            jumlahMaksimalKamar.toString();
      }

      // Add image if selected
      if (gambarCamp != null) {
        request.files.add(
          await http.MultipartFile.fromPath('gambar_camp', gambarCamp.path),
        );
      }

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      print('Update Camp Status: ${response.statusCode}');
      print('Update Camp Response: ${response.body}');

      return response.statusCode == 200;
    } catch (e) {
      print('Error updating camp: $e');
      rethrow;
    }
  }

  // Delete camp
  static Future<bool> deleteCamp(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.delete(
        Uri.parse('$baseUrl/camp/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting camp: $e');
      rethrow;
    }
  }

  // Get kamar types by camp
  static Future<List<String>> getKamarTypesByCamp(int campId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('$baseUrl/camp/$campId/kamar-types'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Kamar Types Status: ${response.statusCode}');
      print('Get Kamar Types Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return List<String>.from(data['data'] ?? []);
      } else {
        throw Exception('Failed to load kamar types: ${response.body}');
      }
    } catch (e) {
      print('Error getting kamar types: $e');
      rethrow;
    }
  }
}
