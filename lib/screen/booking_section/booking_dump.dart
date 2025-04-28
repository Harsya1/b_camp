import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class DumpBooking extends StatefulWidget {
  const DumpBooking({super.key});

  @override
  State<DumpBooking> createState() => _DumpBookingState();
}

class _DumpBookingState extends State<DumpBooking> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#f2f2f2'.toColor(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Centered content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Illustration image
                        Image.asset(
                          'lib/assets/picture/img_dump_booking.png',
                          width: 180,
                          height: 200,
                          fit: BoxFit.contain,
                          semanticLabel:
                              'Illustration of a person standing and holding a phone, wearing black jacket and pants with sneakers',
                        ),
                        // const SizedBox(height: 12),
                        // Title
                        const Text(
                          'Belum Pesan Tempat di B-Camp?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Subtitle
                        const Text(
                          'Segera amankan tempat Anda di camp kami untuk pengalaman belajar yang lebih maksimal!\n'
                          'Nikmati kenyamanan dan suasana belajar yang mendukung di Brilliant English Course.\n'
                          'Daftarkan diri Anda sekarang dan pastikan Anda mendapatkan tempat terbaik.',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
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
