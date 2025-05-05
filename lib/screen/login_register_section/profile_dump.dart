import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class ProfileDump extends StatefulWidget {
  const ProfileDump({super.key});

  @override
  State<ProfileDump> createState() => _ProfileDumpState();
}

class _ProfileDumpState extends State<ProfileDump> {
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
              // Back button
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    size: 28,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Navigator.pop(context); // Handle back action
                  },
                ),
              ),
              // Centered content
              Expanded(
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Illustration image
                        Image.asset(
                          'lib/assets/picture/sapiens_dump_notlogin.png',
                          width: 150,
                          height: 200,
                          fit: BoxFit.contain,
                          semanticLabel:
                              'Illustration of a person standing and holding a phone, wearing black jacket and pants with sneakers',
                        ),
                        const SizedBox(height: 32),
                        // Title
                        const Text(
                          'Belum Masuk?',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Description
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Akses fitur lengkap dan kelola akun Anda dengan mudah. Masuk sekarang untuk menikmati pengalaman yang lebih personal di aplikasi kami. Jika Anda belum memiliki akun, daftarkan diri Anda sekarang untuk memulai!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: Colors.black,
                              height: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                        // Log in button
                        SizedBox(
                          width: 160,
                          height: 42,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle login action
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              padding: EdgeInsets.zero,
                            ),
                            child: const Text(
                              'Log in',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                          ),
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
