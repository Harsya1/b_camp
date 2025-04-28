import 'package:flutter/material.dart';
import 'register_action.dart'; // Import halaman register

class LoginPage extends StatelessWidget {
  final VoidCallback onLogin;

  const LoginPage({Key? key, required this.onLogin}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 242, 242, 242),
      body: SingleChildScrollView(
        // Agar konten bisa bergulir saat keyboard muncul
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                Image.asset(
                  'lib/assets/background/login_logo.png',
                  height: 300,
                  width: 300,
                ),
                const SizedBox(height: 20),
                // Selamat Datang
                Container(
                  width: 290,
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Selamat Datang Kembali',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                // Deskripsi
                Container(
                  width: 290,
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Silahkan login untuk pengalaman yang lebih baik',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                // TextField Email
                SizedBox(
                  width: 290,
                  child: TextField(
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
                ),
                const SizedBox(height: 20),
                // TextField Password
                SizedBox(
                  width: 290,
                  child: TextField(
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
                ),
                const SizedBox(height: 30),
                // Tombol Login
                SizedBox(
                  width: 290,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    onPressed: () {
                      // Saat tombol login ditekan
                      print("Login ditekan");
                      onLogin(); // Panggil callback ke main
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Belum punya akun? Ayo Daftar Sekarang!
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Belum punya akun? ',
                      style: TextStyle(fontSize: 12, color: Colors.black),
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigasi ke halaman register
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const register_section(),
                          ),
                        );
                      },
                      child: const Text(
                        'Ayo Daftar Sekarang!',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
