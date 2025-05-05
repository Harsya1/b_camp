import 'package:flutter/material.dart';

class ProfileDashboard extends StatelessWidget {
  const ProfileDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Column(
        children: [
          // Bagian atas: Profile info
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                // Foto profil
                const CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('lib/assets/profile_avatar.png'), // Ganti path sesuai gambar Anda
                ),
                const SizedBox(width: 16),
                // Info pengguna
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'hahahaha',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Xianzhou Pusat Blok 8\n+7 932 126 30 90\nLanang',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),

          // Pengaturan
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Pengaturan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // List Menu Pengaturan
          const MenuItem(
            icon: Icons.person_outline,
            title: 'Edit Profile',
          ),
          const MenuItem(
            icon: Icons.lock_outline,
            title: 'Ubah Password',
          ),
         

          const Spacer(),

          // Tombol keluar akun
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
            child: SizedBox(
              width: double.infinity,
              height: 35,
              child: ElevatedButton(
                onPressed: () {
                  // aksi logout
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Text(
                  'Keluar akun',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MenuItem extends StatelessWidget {
  final IconData icon;
  final String title;

  const MenuItem({super.key, required this.icon, required this.title});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, size: 26),
      title: Text(
        title,
        style: const TextStyle(fontSize: 15),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {
        // navigasi ke halaman terkait
      },
    );
  }
}