import 'package:flutter/material.dart';
import 'package:b_camp/main.dart';

// import 'package:http/http.dart' as http;

// Halaman untuk registrasi user baru
class register_section extends StatefulWidget {
  const register_section({super.key});

  @override
  State<register_section> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<register_section> {
  // Controller untuk input teks
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  // Membersihkan controller saat widget dihapus dari tree
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      resizeToAvoidBottomInset: true, // Menyesuaikan konten dengan keyboard
      body: Center(
        child: SingleChildScrollView(
          // Agar tampilan bisa digulir saat keyboard muncul
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Gambar ilustrasi registrasi
                Image.asset(
                  'lib/assets/picture/sapiens_register.png',
                  width: 300,
                  height: 300,
                  fit: BoxFit.contain,
                  semanticLabel: 'Illustration for registration',
                ),

                // Judul form
                const Text(
                  'Ayo Daftar Sekarang',
                  style: TextStyle(
                    color: Color(0xFFF2F2F2),
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 8),

                // Deskripsi
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Daftarkan diri Anda dan mulai perjalanan baru bersama kami. Dapatkan akses ke berbagai fitur eksklusif dan nikmati pengalaman yang lebih maksimal.',
                    style: TextStyle(
                      color: Color(0xFFF2F2F2),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),

                // Container untuk form input
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 14),

                        // Input email
                        TextField(
                          controller: _emailController,
                          keyboardType:
                              TextInputType
                                  .emailAddress, // Mengatur jenis input sebagai email
                          decoration: InputDecoration(
                            hintText: 'Email',
                            filled: true,
                            fillColor: const Color(0xFFF0F0F0),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 16),

                        // Input password
                        TextField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            filled: true,
                            fillColor: const Color(0xFFF0F0F0),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 16),

                        // Input konfirmasi password
                        TextField(
                          controller: _confirmPasswordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            hintText: 'Konfirmasi Password',
                            filled: true,
                            fillColor: const Color(0xFFF0F0F0),
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 20,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(color: Colors.grey),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(50),
                              borderSide: const BorderSide(
                                color: Colors.black,
                                width: 2,
                              ),
                            ),
                            hintStyle: TextStyle(color: Colors.grey[500]),
                          ),
                          style: const TextStyle(color: Colors.black),
                        ),
                        const SizedBox(height: 24),

                        // Tombol registrasi
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // TODO: Tambahkan logika registrasi di sini
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const MyApp(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            // Tombol untuk registrasi
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
