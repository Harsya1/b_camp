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
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get All Camps Status: ${response.statusCode}');
      print('Get All Camps Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        // Handle both old and new response formats
        if (data is List) {
          return List<Map<String, dynamic>>.from(data);
        } else if (data is Map && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        return [];
      } else {
        throw Exception('Failed to load camps: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching camps: $e');
      throw Exception('Error fetching camps: $e');
    }
  }

  // Get all kamars - Add this method for screen_booking_data.dart
  static Future<List<Map<String, dynamic>>> getAllKamars() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('$baseUrl/kamar'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get All Kamars Status: ${response.statusCode}');
      print('Get All Kamars Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        return [];
      } else {
        throw Exception('Failed to load kamars: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching kamars: $e');
      throw Exception('Error fetching kamars: $e');
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

  // Get all bookings
  static Future<List<Map<String, dynamic>>> getAllBookings() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('$baseUrl/booking-calendar'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get All Bookings Status: ${response.statusCode}');
      print('Get All Bookings Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        // Debug: Print data structure
        print('Response data structure: ${data.runtimeType}');
        print('Data keys: ${data.keys}');
        
        // Check if data has the expected structure
        if (data is Map && data['status'] == true && data['data'] != null) {
          final bookings = data['data'];
          print('Bookings type: ${bookings.runtimeType}');
          print('Bookings length: ${bookings.length}');
          
          if (bookings is List) {
            return List<Map<String, dynamic>>.from(bookings);
          } else {
            throw Exception('Data is not a list: ${bookings.runtimeType}');
          }
        } else if (data is Map && data['data'] != null) {
          // Alternative format
          return List<Map<String, dynamic>>.from(data['data']);
        } else {
          throw Exception('Invalid response structure: $data');
        }
      } else {
        throw Exception('Failed to load bookings: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllBookings: $e');
      throw Exception('Error fetching bookings: $e');
    }
  }

  // Get all bookings with kamar and camp relationships
  static Future<List<Map<String, dynamic>>> getAllBookingsWithDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('$baseUrl/booking-calendar?include=kamar,kamar.camp'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Bookings With Details Status: ${response.statusCode}');
      print('Get Bookings With Details Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        
        if (data is Map && data['status'] == true && data['data'] != null) {
          final bookings = data['data'];
          if (bookings is List) {
            return List<Map<String, dynamic>>.from(bookings);
          }
        } else if (data is Map && data['data'] != null) {
          return List<Map<String, dynamic>>.from(data['data']);
        }
        return [];
      } else {
        throw Exception('Failed to load bookings with details: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getAllBookingsWithDetails: $e');
      // Fallback to regular getAllBookings
      return await getAllBookings();
    }
  }

  // Get kamar detail for booking
  static Future<Map<String, dynamic>> getKamarDetail(int kamarId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/kamar/$kamarId'),
        headers: await _getHeaders(),
      );

      print('Get Kamar Detail Status: ${response.statusCode}');
      print('Get Kamar Detail Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load kamar detail: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching kamar detail: $e');
      throw Exception('Error fetching kamar detail: $e');
    }
  }

  // Update booking
  static Future<void> updateBooking(int bookingId, Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      print('=== BOOKING UPDATE REQUEST ===');
      print('Booking ID: $bookingId');
      print('Update data: $data');
      print('Token exists: ${token != null}');
      print('URL: $baseUrl/booking-calendar/$bookingId');

      if (token == null) throw Exception('Authentication required');

      final headers = {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      print('Headers: $headers');

      final response = await http.put(
        Uri.parse('$baseUrl/booking-calendar/$bookingId'),
        headers: headers,
        body: json.encode(data),
      );

      print('=== BOOKING UPDATE RESPONSE ===');
      print('Status Code: ${response.statusCode}');
      print('Response Headers: ${response.headers}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200) {
        print('✅ Booking updated successfully');
        final responseData = json.decode(response.body);
        print('Response data: $responseData');
      } else {
        print('❌ Update failed with status: ${response.statusCode}');
        final errorData = json.decode(response.body);
        print('Error data: $errorData');
        throw Exception(errorData['message'] ?? 'Failed to update booking: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Exception in updateBooking: $e');
      throw Exception('Error updating booking: $e');
    }
  }

  // Delete booking
  static Future<void> deleteBooking(int bookingId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/booking-calendar/$bookingId'),
        headers: await _getHeaders(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete booking');
      }
    } catch (e) {
      throw Exception('Error deleting booking: $e');
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
      print('\n=== Getting Camp Types for Calendar ===');
      
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

      // Get all camps first
      final camps = await getAllCamps();
      print('Got ${camps.length} camps for calendar');
      
      List<Map<String, dynamic>> result = [];

      // For each camp, get its types
      for (var camp in camps) {
        try {
          print('Getting types for camp: ${camp['nama_camp']}');
          final types = await getKamarTypesByCamp(camp['id']);
          print('Found ${types.length} types for camp ${camp['nama_camp']}');
          
          if (types.isNotEmpty) {
            result.add({
              'camp_id': camp['id'],
              'camp_name': camp['nama_camp'],
              'types': types
            });
          }
        } catch (e) {
          print('Error getting types for camp ${camp['id']}: $e');
          // Continue with next camp
        }
      }

      print('Final result: ${result.length} camps with types');
      return result;
    } catch (e) {
      print('Error in getAllCampTypesForCalendar: $e');
      return [];
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

  // Get booking detail with camp info
  static Future<Map<String, dynamic>> getBookingDetail(int bookingId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) throw Exception('Authentication required');

      final response = await http.get(
        Uri.parse('$baseUrl/booking-calendar/$bookingId'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get Booking Detail Status: ${response.statusCode}');
      print('Get Booking Detail Response: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['data'];
      } else {
        throw Exception('Failed to load booking detail: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching booking detail: $e');
      throw Exception('Error fetching booking detail: $e');
    }
  }

  static Future<Map<String, String>> _getHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    return {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }
}