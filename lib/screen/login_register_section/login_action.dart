import 'package:flutter/material.dart';
import 'package:b_camp/service/database/controller/UserAplikasiController.dart';
import 'package:b_camp/service/auth/session_manager.dart';

class LoginPage extends StatefulWidget {
  final VoidCallback onLogin;

  const LoginPage({super.key, required this.onLogin});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible =
      false; // Variabel untuk melacak visibilitas password

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 242, 242, 242),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
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
                    'Silahkan login melakukan pengelolaan data camp',
                    style: TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 20),
                // TextField Email
                SizedBox(
                  width: 290,
                  child: TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
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
                    controller: _passwordController,
                    obscureText:
                        !_isPasswordVisible, // Kontrol visibilitas password
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
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible =
                                !_isPasswordVisible; // Toggle status
                          });
                        },
                      ),
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
                    onPressed: () async {
                      try {
                        if (_emailController.text.isEmpty ||
                            _passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Mohon isi email dan password'),
                            ),
                          );
                          return;
                        }

                        // Show loading
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        final response = await AuthService.login(
                          email: _emailController.text.trim(),
                          password: _passwordController.text,
                        );

                        // Hide loading
                        if (mounted) {
                          Navigator.pop(context);
                        }

                        if (response['status'] == 'success' &&
                            response['data'] != null) {
                          final token = response['data']['token'];
                          await SessionManager.saveLoginSession(token);

                          if (mounted) {
                            Navigator.pushReplacementNamed(
                              context,
                              '/dashboard_calender',
                            );
                          }
                        } else {
                          throw Exception(
                            'Login failed: Invalid response format',
                          );
                        }
                      } catch (e) {
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                e.toString().contains('Invalid credentials')
                                    ? 'Email atau password salah'
                                    : 'Gagal masuk ke aplikasi',
                              ),
                            ),
                          );
                        }
                      }
                    },
                    child: const Text(
                      'Log In',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
