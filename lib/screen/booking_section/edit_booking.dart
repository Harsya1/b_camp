import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:intl/intl.dart';
import 'screen_booking_data.dart';
import 'package:b_camp/service/database/controller/itemBookingController.dart';

class EditBooking extends StatefulWidget {
  const EditBooking({super.key});

  @override
  State<EditBooking> createState() => _EditBookingState();
}

class _EditBookingState extends State<EditBooking> {
  Booking? booking;
  DateTime? selectedCheckIn;
  DateTime? selectedCheckOut;
  String kamarInfo = 'Loading...';
  String campInfo = 'Loading...';
  bool isLoading = false;
  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Only initialize once
    if (!_isInitialized) {
      booking = ModalRoute.of(context)!.settings.arguments as Booking;
      selectedCheckIn = booking!.checkIn;
      selectedCheckOut = booking!.checkOut;
      print('=== INITIAL SETUP ===');
      print('Initial selectedCheckIn: $selectedCheckIn');
      print('Initial selectedCheckOut: $selectedCheckOut');
      _loadBookingInfo();
      _isInitialized = true;
    }
  }

  Future<void> _loadBookingInfo() async {
    try {
      final bookingDetail = await ItemBookingController.getBookingDetail(
        booking!.id,
      );
      if (mounted) {
        setState(() {
          // Set kamar info
          if (bookingDetail['kamar_info'] != null) {
            kamarInfo =
                bookingDetail['kamar_info']['nama_kamar'] ?? 'Unknown Room';
          } else {
            kamarInfo = 'Room ID: ${booking!.kamarId}';
          }

          // Set camp info
          if (bookingDetail['camp_info'] != null) {
            campInfo =
                bookingDetail['camp_info']['nama_camp'] ?? 'Unknown Camp';
          } else {
            campInfo = 'Unknown Camp';
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          kamarInfo = 'Room ID: ${booking!.kamarId}';
          campInfo = 'Unknown Camp';
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    print('=== DATE PICKER OPENED ===');
    print('Current selectedCheckIn: $selectedCheckIn');
    print('Current selectedCheckOut: $selectedCheckOut');

    final DateTime initialDate =
        isCheckIn ? selectedCheckIn! : selectedCheckOut!;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      print('=== DATE PICKED ===');
      print('Picked date: $picked for ${isCheckIn ? "check-in" : "check-out"}');

      setState(() {
        if (isCheckIn) {
          selectedCheckIn = picked;
          print('NEW selectedCheckIn: $selectedCheckIn');
          // If check-in is after check-out, update check-out
          if (selectedCheckOut!.isBefore(picked)) {
            selectedCheckOut = picked.add(const Duration(days: 1));
            print('Auto-updated selectedCheckOut: $selectedCheckOut');
          }
        } else {
          selectedCheckOut = picked;
          print('NEW selectedCheckOut: $selectedCheckOut');
        }
      });

      print('=== AFTER setState ===');
      print('Final selectedCheckIn: $selectedCheckIn');
      print('Final selectedCheckOut: $selectedCheckOut');
    } else {
      print('No date was picked');
    }
  }

  Future<void> _updateBooking() async {
    print('=== UPDATE BOOKING DEBUG ===');
    print('selectedCheckIn: $selectedCheckIn');
    print('selectedCheckOut: $selectedCheckOut');
    print('booking.checkIn (original): ${booking!.checkIn}');
    print('booking.checkOut (original): ${booking!.checkOut}');

    if (selectedCheckIn == null || selectedCheckOut == null) {
      print('ERROR: One of the dates is null');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both check-in and check-out dates'),
        ),
      );
      return;
    }

    if (selectedCheckOut!.isBefore(selectedCheckIn!) ||
        selectedCheckOut!.isAtSameMomentAs(selectedCheckIn!)) {
      print('ERROR: Invalid date range');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check-out date must be after check-in date'),
        ),
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      final updateData = {
        'start_date': DateFormat('yyyy-MM-dd').format(selectedCheckIn!),
        'end_date': DateFormat('yyyy-MM-dd').format(selectedCheckOut!),
      };

      print('Update data to send: $updateData');
      print('Booking ID: ${booking!.id}');

      await ItemBookingController.updateBooking(booking!.id, updateData);

      print('Update request completed successfully');

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking berhasil diupdate')),
        );
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      print('Error in _updateBooking: $e');
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (booking == null ||
        selectedCheckIn == null ||
        selectedCheckOut == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: '#f2f2f2'.toColor(),
      appBar: AppBar(
        backgroundColor: '#f2f2f2'.toColor(),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Data Booking',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Nama', booking!.name),
            const SizedBox(height: 30),
            _buildInfoRow('Gender', booking!.gender),
            const SizedBox(height: 30),
            _buildInfoRow('Nama camp', campInfo),
            const SizedBox(height: 30),
            _buildInfoRow('Nomor kamar', kamarInfo),
            const SizedBox(height: 30),

            // Check-in date selector
            GestureDetector(
              onTap: () {
                print('Check-in date selector tapped');
                _selectDate(context, true);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Text(
                      'Tanggal Masuk: ${DateFormat('dd/MM/yyyy').format(selectedCheckIn!)}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const Spacer(),
                    const Icon(Icons.calendar_today, color: Colors.black),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),

            // Check-out date selector
            GestureDetector(
              onTap: () {
                print('Check-out date selector tapped');
                _selectDate(context, false);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 15,
                ),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    Text(
                      'Tanggal Keluar: ${DateFormat('dd/MM/yyyy').format(selectedCheckOut!)}',
                      style: const TextStyle(fontSize: 16, color: Colors.black),
                    ),
                    const Spacer(),
                    const Icon(Icons.calendar_today, color: Colors.black),
                  ],
                ),
              ),
            ),

            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : _updateBooking,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child:
                    isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Simpan Data',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(value, style: const TextStyle(fontSize: 16, color: Colors.grey)),
      ],
    );
  }
}
