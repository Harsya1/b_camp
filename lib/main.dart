import 'package:flutter/material.dart';
import 'screen/home_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int selectedIndex = 0;

  // Daftar halaman untuk navigasi
  final List<Widget> pages = [
    dashboard_main(), // Menggunakan navbar dari dashboard_main
    Center(child: Text('Booking Page')), // Placeholder untuk halaman Booking
    Center(child: Text('Profile Page')), // Placeholder untuk halaman Profile
  ];

  // Daftar ikon navigasi
  final List<Widget> navIcons = [
    ImageIcon(AssetImage('assets/icon/icnHome.png'), size: 24),
    ImageIcon(AssetImage('assets/icon/icnBooking.png'), size: 24),
    ImageIcon(AssetImage('assets/icon/icnProfile.png'), size: 24),
  ];

  // Daftar judul navigasi
  final List<String> navTitles = ['Ayo Cari', 'Booking', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B-Camp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        body: pages[selectedIndex], // Menampilkan halaman berdasarkan indeks
        bottomNavigationBar: _navbar(),
      ),
    );
  }

  Widget _navbar() {
    return Container(
      height: 65,
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withAlpha(20),
            blurRadius: 20,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navIcons.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index; // Ubah halaman berdasarkan indeks
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                navIcons[index],
                Text(
                  navTitles[index],
                  style: TextStyle(
                    color: selectedIndex == index ? Colors.white : Colors.grey,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
