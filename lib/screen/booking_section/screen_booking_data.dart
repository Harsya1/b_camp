import 'package:b_camp/screen/routes/app_drawer.dart';
import 'package:b_camp/service/database/controller/itemBookingController.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:intl/intl.dart';
import 'dart:async';

class Booking {
  final int id;
  final int kamarId;
  final String name;
  final String gender;
  final DateTime checkIn;
  final DateTime checkOut;
  final int quantity;
  // Tambah data relationship
  final String? kamarName;
  final String? campName;

  Booking({
    required this.id,
    required this.kamarId,
    required this.name,
    required this.gender,
    required this.checkIn,
    required this.checkOut,
    required this.quantity,
    this.kamarName,
    this.campName,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    // Extract kamar and camp data from relationships
    String? kamarName;
    String? campName;

    // Check if kamar relationship exists
    if (json['kamar'] != null) {
      final kamarData = json['kamar'];
      kamarName = kamarData['nama_kamar']?.toString();
      
      // Check if camp relationship exists within kamar
      if (kamarData['camp'] != null) {
        final campData = kamarData['camp'];
        campName = campData['nama_camp']?.toString();
      }
    }

    return Booking(
      id: int.parse(json['id'].toString()),
      kamarId: int.parse(json['kamar_id'].toString()),
      name: json['nama'].toString(),
      gender: json['gender'].toString(),
      checkIn: DateTime.parse(json['start_date'].toString()),
      checkOut: DateTime.parse(json['end_date'].toString()),
      quantity: int.parse(json['quantity'].toString()),
      kamarName: kamarName,
      campName: campName,
    );
  }
}

class ScreenBooking extends StatefulWidget {
  const ScreenBooking({super.key});

  @override
  State<ScreenBooking> createState() => _ScreenBookingState();
}

class _ScreenBookingState extends State<ScreenBooking> {
  List<Booking> bookings = [];
  List<Booking> filteredBookings = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
    _loadAllData();
  }

  @override
  void dispose() {
    searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  Future<void> _loadAllData() async {
    try {
      setState(() => isLoading = true);
      
      // Try to get bookings with relationships first
      List<Map<String, dynamic>> bookingData = [];
      
      try {
        bookingData = await ItemBookingController.getAllBookingsWithDetails();
        print('Loaded bookings with details: ${bookingData.length}');
      } catch (e) {
        print('Could not load bookings with details: $e');
        // Fallback to regular bookings
        bookingData = await ItemBookingController.getAllBookings();
        print('Loaded regular bookings: ${bookingData.length}');
      }
      
      if (mounted) {
        setState(() {
          bookings = bookingData.map((data) {
            if (data is! Map<String, dynamic>) {
              throw Exception('Invalid booking data format');
            }
            return Booking.fromJson(data);
          }).toList();
          
          filteredBookings = bookings;
          isLoading = false;
        });
        print('Loaded ${bookings.length} bookings total');
        
        // Debug: Print sample booking with relationships
        if (bookings.isNotEmpty) {
          final sampleBooking = bookings.first;
          print('Sample booking:');
          print('- Name: ${sampleBooking.name}');
          print('- Kamar: ${sampleBooking.kamarName ?? "Not loaded"}');
          print('- Camp: ${sampleBooking.campName ?? "Not loaded"}');
        }
      }
    } catch (e, stackTrace) {
      if (mounted) {
        setState(() => isLoading = false);
        print('Error loading data: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading data: $e')),
        );
      }
    }
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _filterBookings(searchController.text);
    });
  }

  void _filterBookings(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredBookings = bookings;
      } else {
        final lowercaseQuery = query.toLowerCase();
        filteredBookings = bookings.where((booking) {
          // Search criteria
          final matchesName = booking.name.toLowerCase().contains(lowercaseQuery);
          final matchesGender = booking.gender.toLowerCase().contains(lowercaseQuery);
          final matchesKamar = (booking.kamarName?.toLowerCase() ?? '').contains(lowercaseQuery);
          final matchesCamp = (booking.campName?.toLowerCase() ?? '').contains(lowercaseQuery);
          final matchesCheckIn = DateFormat('yyyy-MM-dd').format(booking.checkIn).contains(lowercaseQuery);
          final matchesCheckOut = DateFormat('yyyy-MM-dd').format(booking.checkOut).contains(lowercaseQuery);
          final matchesCheckInFormatted = DateFormat('dd MMM yyyy').format(booking.checkIn).toLowerCase().contains(lowercaseQuery);
          final matchesCheckOutFormatted = DateFormat('dd MMM yyyy').format(booking.checkOut).toLowerCase().contains(lowercaseQuery);

          return matchesName || 
                 matchesGender || 
                 matchesKamar || 
                 matchesCamp || 
                 matchesCheckIn || 
                 matchesCheckOut ||
                 matchesCheckInFormatted ||
                 matchesCheckOutFormatted;
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#f2f2f2'.toColor(),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  _buildBookingList(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 150,
      color: '#f2f2f2'.toColor(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 10,
            top: 20,
            child: Builder(
              builder: (context) => IconButton(
                icon: const Icon(Icons.menu, color: Colors.black),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            ),
          ),
          Positioned(
            top: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "List Data Booking",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 25,
            right: 25,
            child: TextField(
              controller: searchController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cari nama, camp, kamar, atau tanggal...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: searchController.text.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        searchController.clear();
                      },
                    )
                  : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingList() {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(50.0),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (filteredBookings.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(50.0),
          child: Column(
            children: [
              Icon(
                searchController.text.isNotEmpty ? Icons.search_off : Icons.event_busy,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 16),
              Text(
                searchController.text.isNotEmpty 
                  ? 'No bookings found for "${searchController.text}"'
                  : 'No bookings found',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredBookings.length,
      itemBuilder: (context, index) {
        final booking = filteredBookings[index];
        return GestureDetector(
          onTap: () async {
            final result = await Navigator.pushNamed(
              context,
              '/detail_booking',
              arguments: booking,
            );
            
            if (result == true) {
              _loadAllData();
            }
          },
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.blue,
                        child: Text(
                          booking.name.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking.name,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              booking.gender,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Camp and Kamar info dari relationship
                  Text(
                    'Camp: ${booking.campName ?? "Loading..."}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    'Kamar: ${booking.kamarName ?? "Loading..."}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey[700],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Check-in',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(booking.checkIn),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Check-out',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              DateFormat('dd MMM yyyy').format(booking.checkOut),
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
