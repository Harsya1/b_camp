import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Profile Section
            Container(
              color: Colors.black,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(radius: 30, backgroundColor: Colors.white),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'King Yuan',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Xianzhou Pusat Blok 8',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text(
                        '+7 932 126 30 90',
                        style: TextStyle(color: Colors.white),
                      ),
                      Text('Lanang', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ],
              ),
            ),

            // Settings Section
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Pengaturan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildMenuItem(Icons.person, 'Edit Profil'),
                    _buildMenuItem(Icons.lock, 'Ubah Password'),
                    _buildMenuItem(Icons.book, 'Riwayat Booking'),
                  ],
                ),
              ),
            ),

            // Logout Button
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: SizedBox(
                width: 200,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    // Logout logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        Colors.black, // Warna latar belakang tombol
                    foregroundColor: Colors.white, // Warna teks tombol (PUTIH)
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text('Keluar akun'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        // Navigate to respective page
      },
    );
  }
}
