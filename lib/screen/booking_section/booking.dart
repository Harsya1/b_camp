import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class BookingSection extends StatefulWidget {
  const BookingSection({super.key});

  @override
  State<BookingSection> createState() => _BookingSection();
}

class _BookingSection extends State<BookingSection> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: 'f2f2f2'.toColor(), // Warna abu-abu muda
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(
            16.0,
          ), // Padding agar isi tidak mepet ke tepi layar
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Posisi teks di sisi kiri
            children: [
              const Text(
                'Booking Activity',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16), // Jarak antara judul dan konten
              // Tambahkan elemen lain seperti list booking, form, tombol, dll
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: "f2f2f2".toColor(), // Warna latar belakang
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'isi konten',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
