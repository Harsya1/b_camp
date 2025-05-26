import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ItemKamarController {
  static const String baseUrl = 'https://kampunginggrismu.com/api';
  static const String imageBaseUrl = 'https://kampunginggrismu.com';

  // Get kamar types by camp
  static Future<List<String>> getKamarTypesByCamp(int campId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('$baseUrl/kamar/types/$campId'),
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
        throw Exception('Failed to load kamar types');
      }
    } catch (e) {
      print('Error getting kamar types: $e');
      rethrow;
    }
  }

  // Get kamar by type
  static Future<List<Map<String, dynamic>>> getKamarByType(int campId, String type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('$baseUrl/kamar/by-type/$campId/$type'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Kamar By Type Status: ${response.statusCode}');
      print('Get Kamar By Type Response: ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        return List<Map<String, dynamic>>.from(data);
      } else {
        throw Exception('Failed to load kamar list');
      }
    } catch (e) {
      print('Error getting kamar list: $e');
      rethrow;
    }
  }

  // Get kamar detail
  static Future<Map<String, dynamic>> getKamarDetail(int kamarId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.get(
        Uri.parse('$baseUrl/kamar/$kamarId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Kamar Detail Status: ${response.statusCode}');
      print('Get Kamar Detail Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load kamar detail');
      }
    } catch (e) {
      print('Error getting kamar detail: $e');
      rethrow;
    }
  }

  // Create kamar
  static Future<bool> createKamar({
    required int campId,
    required String namaKamar,
    required String typeKamar,
    required String kategori,
    required String gender,
    required int jumlahKasur,
    String? fasilitas,
    String? peraturan,
    File? gambar,
    required double harga,
    String? catatanTambahan,
  }) async {
    try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');

        if (token == null) throw Exception('Authentication required');

        var request = http.MultipartRequest(
            'POST',
            Uri.parse('$baseUrl/kamar'),
        );

        request.headers.addAll({
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
        });

        request.fields.addAll({
            'camp_id': campId.toString(),
            'nama_kamar': namaKamar,
            'type_kamar': typeKamar,
            'kategori': kategori,
            'gender': gender,
            'jumlah_kasur': jumlahKasur.toString(),
            'harga': harga.toString(),
        });

        if (fasilitas != null) request.fields['fasilitas'] = fasilitas;
        if (peraturan != null) request.fields['peraturan'] = peraturan;
        if (catatanTambahan != null) request.fields['catatan_tambahan'] = catatanTambahan;

        if (gambar != null) {
            request.files.add(await http.MultipartFile.fromPath(
                'gambar',
                gambar.path,
            ));
        }

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        print('Create Kamar Status: ${response.statusCode}');
        print('Create Kamar Response: ${response.body}');

        return response.statusCode == 201;
    } catch (e) {
        print('Error creating kamar: $e');
        rethrow;
    }
  }

  // Update kamar
  static Future<bool> updateKamar({
    required int id,
    String? namaKamar,
    String? typeKamar,
    String? kategori,
    String? gender,
    int? jumlahKasur,
    String? fasilitas,
    String? peraturan,
    File? gambar,
    double? harga,
    String? catatanTambahan,
  }) async {
    try {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('auth_token');

        if (token == null) throw Exception('Authentication required');

        var request = http.MultipartRequest(
            'POST',
            Uri.parse('$baseUrl/kamar/$id'),
        );

        request.fields['_method'] = 'PUT';

        request.headers.addAll({
            'Accept': 'application/json',
            'Authorization': 'Bearer $token',
        });

        if (namaKamar != null) request.fields['nama_kamar'] = namaKamar;
        if (typeKamar != null) request.fields['type_kamar'] = typeKamar;
        if (kategori != null) request.fields['kategori'] = kategori;
        if (gender != null) request.fields['gender'] = gender;
        if (jumlahKasur != null) request.fields['jumlah_kasur'] = jumlahKasur.toString();
        if (fasilitas != null) request.fields['fasilitas'] = fasilitas;
        if (peraturan != null) request.fields['peraturan'] = peraturan;
        if (harga != null) request.fields['harga'] = harga.toString();
        if (catatanTambahan != null) request.fields['catatan_tambahan'] = catatanTambahan;

        if (gambar != null) {
            request.files.add(await http.MultipartFile.fromPath(
                'gambar',
                gambar.path,
            ));
        }

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        print('Update Kamar Status: ${response.statusCode}');
        print('Update Kamar Response: ${response.body}');

        return response.statusCode == 200;
    } catch (e) {
        print('Error updating kamar: $e');
        rethrow;
    }
  }

  // Delete kamar
  static Future<bool> deleteKamar(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      final response = await http.delete(
        Uri.parse('$baseUrl/kamar/$id'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      return response.statusCode == 200;
    } catch (e) {
      print('Error deleting kamar: $e');
      rethrow;
    }
  }
}