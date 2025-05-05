import 'package:flutter/material.dart';
import 'package:b_camp/service/database/controller/UserAplikasiController.dart';

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
                            onPressed: () async {
                              try {
                                if (_emailController.text.isEmpty || 
                                    _passwordController.text.isEmpty || 
                                    _confirmPasswordController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Mohon isi semua data yang diperlukan'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  return;
                                }

                                if (_passwordController.text != _confirmPasswordController.text) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Password tidak sama'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  return;
                                }

                                if (_passwordController.text.length < 8) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Password minimal 8 karakter'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                  return;
                                }

                                final response = await AuthService.register(
                                  name: _emailController.text.split('@')[0],
                                  email: _emailController.text,
                                  password: _passwordController.text,
                                );

                                if (response['status'] == 'success') {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Pendaftaran berhasil! Silakan login'),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                } else {
                                  String errorMessage;
                                  
                                  // Simplified error handling with switch
                                  switch (response['message']) {
                                    case 'The email has already been taken':
                                      errorMessage = 'Email sudah terdaftar';
                                      break;
                                    case 'The email field is required':
                                      errorMessage = 'Email harus diisi';
                                      break;
                                    case 'The email must be a valid email address':
                                      errorMessage = 'Format email tidak valid';
                                      break;
                                    default:
                                      errorMessage = 'Gagal mendaftar';
                                  }
                                  
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(errorMessage),
                                      duration: const Duration(seconds: 2),
                                    ),
                                  );
                                }
                              } catch (e) {
                                String errorMessage = 'Gagal mendaftar';
                                if (e.toString().contains('SocketException')) {
                                  errorMessage = 'Gagal terhubung ke server, cek koneksi internet anda';
                                }
                                
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(errorMessage),
                                    duration: const Duration(seconds: 2),
                                  ),
                                );
                              }
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
