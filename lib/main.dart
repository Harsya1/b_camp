import 'package:b_camp/screen/booking_section/booking.dart';
import 'package:flutter/material.dart';
import 'screen/home_dashboard.dart';
import 'screen/profile_section/profile_dashboard.dart';

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

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const dashboard_main(), // Halaman Dashboard
      const BookingSection(), // Halaman Booking
      const ProfileDashboard(), // Halaman Profile
    ];

    final List<Widget> navIcons = [
      Image.asset('lib/assets/icon/icnHome.png', width: 24, height: 24),
      Image.asset('lib/assets/icon/icnBooking.png', width: 24, height: 24),
      Image.asset('lib/assets/icon/icnProfile.png', width: 24, height: 24),
    ];

    final List<String> navTitles = ['Ayo Cari', 'Booking', 'Profile'];

    return MaterialApp(
      title: 'B-Camp',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: Scaffold(
        extendBody: true,
        body: pages[selectedIndex], // Menampilkan halaman berdasarkan selectedIndex
        bottomNavigationBar: _navbar(navIcons, navTitles), // Navigasi bawah
      ),
    );
  }

  Widget _navbar(List<Widget> navIcons, List<String> navTitles) {
    return Container(
      height: 65,
      margin: const EdgeInsets.only(left: 24, right: 24, bottom: 24),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.8),
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 20,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(navIcons.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                selectedIndex = index; // Ubah halaman aktif
              });
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Opacity(
                  opacity: selectedIndex == index ? 1 : 0.5,
                  child: navIcons[index],
                ),
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