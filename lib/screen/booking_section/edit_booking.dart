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
  late Booking booking;
  DateTime? selectedCheckIn;
  DateTime? selectedCheckOut;
  String kamarInfo = 'Loading...';
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    booking = ModalRoute.of(context)!.settings.arguments as Booking;
    selectedCheckIn = booking.checkIn;
    selectedCheckOut = booking.checkOut;
    _loadKamarInfo();
  }

  Future<void> _loadKamarInfo() async {
    try {
      final kamarData = await ItemBookingController.getKamarDetail(
        booking.kamarId,
      );
      if (mounted) {
        setState(() {
          kamarInfo = kamarData['nama_kamar'] ?? 'Unknown Room';
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          kamarInfo = 'Room ID: ${booking.kamarId}';
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? selectedCheckIn! : selectedCheckOut!,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          selectedCheckIn = picked;
          // If check-in is after check-out, update check-out
          if (selectedCheckOut!.isBefore(picked)) {
            selectedCheckOut = picked.add(const Duration(days: 1));
          }
        } else {
          selectedCheckOut = picked;
        }
      });
    }
  }

  Future<void> _updateBooking() async {
    if (selectedCheckIn == null || selectedCheckOut == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select both check-in and check-out dates'),
        ),
      );
      return;
    }

    if (selectedCheckOut!.isBefore(selectedCheckIn!) ||
        selectedCheckOut!.isAtSameMomentAs(selectedCheckIn!)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Check-out date must be after check-in date'),
        ),
      );
      return;
    }

    try {
      setState(() => isLoading = true);
      await ItemBookingController.updateBooking(booking.id, {
        'start_date': DateFormat('yyyy-MM-dd').format(selectedCheckIn!),
        'end_date': DateFormat('yyyy-MM-dd').format(selectedCheckOut!),
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Booking berhasil diupdate')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
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
          'Detail Data Booking',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Nama', booking.name),
            const SizedBox(height: 30),
            _buildInfoRow('Gender', booking.gender),
            const SizedBox(height: 30),
            _buildInfoRow('Nomor kamar', kamarInfo),
            const SizedBox(height: 30),
            _buildDateSelector(
              'Tanggal Masuk: ${DateFormat('dd/MM/yyyy').format(selectedCheckIn!)}',
              () => _selectDate(context, true),
            ),
            const SizedBox(height: 30),
            _buildDateSelector(
              'Tanggal Keluar: ${DateFormat('dd/MM/yyyy').format(selectedCheckOut!)}',
              () => _selectDate(context, false),
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

  Widget _buildDateSelector(String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Text(
              text,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            const Spacer(),
            const Icon(Icons.calendar_today, color: Colors.black),
          ],
        ),
      ),
    );
  }
}
