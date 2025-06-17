import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:intl/intl.dart';
import 'screen_booking_data.dart';
import 'package:b_camp/service/database/controller/itemBookingController.dart';

class DetailBooking extends StatefulWidget {
  const DetailBooking({super.key});

  @override
  State<DetailBooking> createState() => _DetailBookingState();
}

class _DetailBookingState extends State<DetailBooking> {
  late Booking booking;
  String kamarInfo = 'Loading...';
  String campInfo = 'Loading...';
  bool isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    booking = ModalRoute.of(context)!.settings.arguments as Booking;
    _loadBookingInfo();
  }

  Future<void> _loadBookingInfo() async {
    try {
      final bookingDetail = await ItemBookingController.getBookingDetail(
        booking.id,
      );
      if (mounted) {
        setState(() {
          // Set kamar info
          if (bookingDetail['kamar_info'] != null) {
            kamarInfo =
                bookingDetail['kamar_info']['nama_kamar'] ?? 'Unknown Room';
          } else {
            kamarInfo = 'Room ID: ${booking.kamarId}';
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
          kamarInfo = 'Room ID: ${booking.kamarId}';
          campInfo = 'Unknown Camp';
        });
      }
    }
  }

  // Add method to calculate duration
  int _calculateDuration() {
    return booking.checkOut.difference(booking.checkIn).inDays;
  }

  // Add duration widget
  Widget _buildDurationWidget() {
    final duration = _calculateDuration();
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Text(
            'Durasi Menginap',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Text(
              '$duration hari',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteBooking() async {
    try {
      setState(() => isLoading = true);
      await ItemBookingController.deleteBooking(booking.id);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Booking berhasil dihapus')),
        );
        Navigator.pop(context, true); // Return true to indicate deletion
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
            _buildInfoRow('Nama camp', campInfo),
            const SizedBox(height: 30),
            _buildInfoRow('Nama kamar', kamarInfo),
            const SizedBox(height: 30),
            _buildInfoRow(
              'Tanggal Masuk',
              DateFormat('dd/MM/yyyy').format(booking.checkIn),
            ),
            const SizedBox(height: 30),
            _buildInfoRow(
              'Tanggal Keluar',
              DateFormat('dd/MM/yyyy').format(booking.checkOut),
            ),
            // Add duration widget here
            _buildDurationWidget(),
            const Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () async {
                              final result = await Navigator.pushNamed(
                                context,
                                '/edit_booking',
                                arguments: booking,
                              );

                              if (result == true) {
                                // Refresh detail booking jika diperlukan
                                _loadBookingInfo();
                                Navigator.pop(
                                  context,
                                  true,
                                ); // Pass result to parent
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: const Text(
                      'Edit data',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed:
                        isLoading
                            ? null
                            : () async {
                              final confirm = await showDialog<bool>(
                                context: context,
                                builder:
                                    (context) => AlertDialog(
                                      title: const Text('Konfirmasi'),
                                      content: const Text(
                                        'Apakah Anda yakin ingin menghapus data booking ini?',
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, false),
                                          child: const Text('Batal'),
                                        ),
                                        TextButton(
                                          onPressed:
                                              () =>
                                                  Navigator.pop(context, true),
                                          child: const Text('Hapus'),
                                        ),
                                      ],
                                    ),
                              );
                              if (confirm == true) {
                                _deleteBooking();
                              }
                            },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child:
                        isLoading
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text(
                              'Hapus Data',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                  ),
                ),
              ],
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
