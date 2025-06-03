import 'package:b_camp/screen/routes/app_drawer.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:intl/intl.dart';

class Booking {
  final String name;
  final DateTime checkIn;
  final DateTime checkOut;

  Booking({required this.name, required this.checkIn, required this.checkOut});
}

class ScreenBooking extends StatefulWidget {
  const ScreenBooking({super.key});

  @override
  State<ScreenBooking> createState() => _ScreenBookingState();
}

class _ScreenBookingState extends State<ScreenBooking> {
  List<Booking> dummyBookings = List.generate(
    10,
    (index) => Booking(
      name: 'Booking ${index + 1}',
      checkIn: DateTime(2025, 6, 1 + index),
      checkOut: DateTime(2025, 6, 5 + index),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#f2f2f2'.toColor(),
      appBar: AppBar(title: const Text('List Data Booking')),
      drawer: const AppDrawer(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: ListView.builder(
            itemCount: dummyBookings.length,
            itemBuilder: (context, index) {
              final booking = dummyBookings[index];
              return Container(
                width: double.infinity,
                height: 100,
                margin: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Masuk: ${DateFormat('dd MMM yyyy').format(booking.checkIn)}',
                            style: TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Keluar: ${DateFormat('dd MMM yyyy').format(booking.checkOut)}',
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ],
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
