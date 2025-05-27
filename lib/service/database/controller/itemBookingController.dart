import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ItemBookingController {
  static const String baseUrl = 'https://kampunginggrismu.com/api';
  static const String imageBaseUrl = 'https://kampunginggrismu.com';

  static String getImageUrl(String? imagePath) {
    if (imagePath == null) return '';
    // Remove any escaped slashes and ensure proper path construction
    final cleanPath = imagePath.replaceAll('\\/', '/');
    return '$imageBaseUrl/storage/$cleanPath';
  }

  // Get all camps for booking list
  static Future<List<Map<String, dynamic>>> getAllCamps() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

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

  // Get camp detail with kamar types
  static Future<Map<String, dynamic>> getCampDetail(int campId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('$baseUrl/camp/$campId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Camp Detail Status: ${response.statusCode}');
      print('Get Camp Detail Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to get camp detail');
      }
    } catch (e) {
      print('Error getting camp detail: $e');
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
        return List<String>.from(data['data']);
      } else {
        throw Exception('Failed to get kamar types');
      }
    } catch (e) {
      print('Error getting kamar types: $e');
      rethrow;
    }
  }

  // Get kamar detail for booking
  static Future<Map<String, dynamic>> getKamarDetail(int kamarId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('$baseUrl/booking-calendar/kamar/$kamarId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Kamar Detail Status: ${response.statusCode}');
      print('Get Kamar Detail Response: ${response.body}');

      if (response.statusCode == 200) {
        return jsonDecode(response.body)['data'];
      } else {
        throw Exception('Failed to get kamar detail');
      }
    } catch (e) {
      print('Error getting kamar detail: $e');
      rethrow;
    }
  }

  // Create booking
  static Future<bool> createBooking({
    required int kamarId,
    required String nama,
    required String gender,
    required DateTime startDate,
    required DateTime endDate,
    required int quantity,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

      final response = await http.post(
        Uri.parse('$baseUrl/booking-calendar'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'kamar_id': kamarId,
          'nama': nama,
          'gender': gender,
          'start_date': startDate.toString().split(' ')[0],
          'end_date': endDate.toString().split(' ')[0],
          'quantity': quantity,
        }),
      );

      print('Create Booking Status: ${response.statusCode}');
      print('Create Booking Response: ${response.body}');

      return response.statusCode == 201;
    } catch (e) {
      print('Error creating booking: $e');
      rethrow;
    }
  }

  // Get kamar by type
  static Future<List<Map<String, dynamic>>> getKamarByType(int campId, String type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

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
        throw Exception('Failed to get kamar list');
      }
    } catch (e) {
      print('Error getting kamar list: $e');
      rethrow;
    }
  }

  // Get all camp types with rooms for calendar view
  static Future<List<Map<String, dynamic>>> getAllCampTypesForCalendar() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

      // Get all camps first
      final camps = await getAllCamps();
      List<Map<String, dynamic>> result = [];

      // For each camp, get its types
      for (var camp in camps) {
        final types = await getKamarTypesByCamp(camp['id']);
        if (types.isNotEmpty) {
          result.add({
            'camp_id': camp['id'],
            'camp_name': camp['nama_camp'],
            'types': types
          });
        }
      }

      print('Loaded calendar data: ${result.length} camps');
      return result;
    } catch (e) {
      print('Error getting camp types for calendar: $e');
      rethrow;
    }
  }

  // Get bookings for calendar view by room ID
  static Future<List<Map<String, dynamic>>> getBookingsForCalendar(int kamarId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('$baseUrl/booking-calendar/kamar/$kamarId'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Calendar Bookings Status: ${response.statusCode}');
      print('Bookings Response: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        // Access the bookings array from the nested structure
        final bookings = responseData['data']['bookings'];
        if (bookings == null) return [];
        
        return List<Map<String, dynamic>>.from(bookings);
      } else {
        throw Exception('Failed to get bookings');
      }
    } catch (e) {
      print('Error getting calendar bookings: $e');
      return []; // Return empty list instead of rethrowing
    }
  }

  // Get rooms by camp ID and type with availability check
  static Future<List<Map<String, dynamic>>> getRoomsForType(int campId, String type) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

      // First get all rooms of this type
      final response = await http.get(
        Uri.parse('$baseUrl/kamar/by-type/$campId/$type'),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Rooms Status: ${response.statusCode}');
      print('Rooms Response: ${response.body}');

      if (response.statusCode == 200) {
        final roomsData = jsonDecode(response.body)['data'];
        final List<Map<String, dynamic>> rooms = List<Map<String, dynamic>>.from(roomsData);

        // For each room, check its bookings
        final List<Map<String, dynamic>> roomsWithStatus = [];
        for (var room in rooms) {
          final bookingsResponse = await http.get(
            Uri.parse('$baseUrl/booking-calendar/check/${room['id']}'),
            headers: {
              'Accept': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );

          if (bookingsResponse.statusCode == 200) {
            final bookingData = jsonDecode(bookingsResponse.body)['data'];
            room['bookings'] = bookingData;
            roomsWithStatus.add(room);
          }
        }

        return roomsWithStatus;
      } else {
        throw Exception('Failed to get rooms');
      }
    } catch (e) {
      print('Error getting rooms with availability: $e');
      rethrow;
    }
  }
}