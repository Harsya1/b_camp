import 'package:b_camp/screen/routes/app_drawer.dart';
import 'package:b_camp/service/database/controller/itemBookingController.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:intl/intl.dart';

class Booking {
  final int id;
  final int kamarId;
  final String name;
  final String gender;
  final DateTime checkIn;
  final DateTime checkOut;
  final int quantity;

  Booking({
    required this.id,
    required this.kamarId,
    required this.name,
    required this.gender,
    required this.checkIn,
    required this.checkOut,
    required this.quantity,
  });

  factory Booking.fromJson(Map<String, dynamic> json) {
    return Booking(
      id: int.parse(json['id'].toString()), // Safe parsing
      kamarId: int.parse(json['kamar_id'].toString()), // Safe parsing
      name: json['nama'].toString(),
      gender: json['gender'].toString(),
      checkIn: DateTime.parse(json['start_date'].toString()),
      checkOut: DateTime.parse(json['end_date'].toString()),
      quantity: int.parse(json['quantity'].toString()), // Safe parsing
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
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      setState(() => isLoading = true);
      final bookingData = await ItemBookingController.getAllBookings();
      if (mounted) {
        setState(() {
          bookings = bookingData.map((data) {
            print('Booking data: $data'); // Debug print
            return Booking.fromJson(data);
          }).toList();
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        print('Error loading bookings: $e'); // Debug print
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading bookings: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#f2f2f2'.toColor(),
      appBar: AppBar(title: const Text('List Data Booking')),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : bookings.isEmpty
                  ? const Center(child: Text('No bookings found'))
                  : ListView.builder(
                      itemCount: bookings.length,
                      itemBuilder: (context, index) {
                        final booking = bookings[index];
                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              '/detail_booking',
                              arguments: booking,
                            ).then((_) => _loadBookings()); // Refresh after returning
                          },
                          child: Container(
                            width: double.infinity,
                            height: 100,
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
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    booking.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Masuk: ${DateFormat('dd MMM yyyy').format(booking.checkIn)}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                      Text(
                                        'Keluar: ${DateFormat('dd MMM yyyy').format(booking.checkOut)}',
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ),
    );
  }
}
