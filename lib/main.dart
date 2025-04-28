import 'package:flutter/material.dart';
import 'screen/home_dashboard.dart';

import 'screen/profile_section/profile_dashboard.dart';

import 'screen/login_register_section/login_action.dart'; 

import 'screen/login_register_section/register_action.dart';
import 'screen/login_register_section/profile_dump.dart';
import 'screen/booking_section/booking_dump.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  int selectedIndex = 2; // Set ke halaman profil saat start

  final List<Widget> pages = [
    dashboard_main(),
    Center(child: Text('Booking Page')),
    const ProfilePage(),

  int selectedIndex = 0;
  bool isLoggedIn = false;

  final List<Widget> pages = [

    dashboard_main(), // Menggunakan navbar dari dashboard_main
    DumpBooking(), // Placeholder untuk halaman Booking
    register_section(), // Placeholder untuk halaman Profile

  ];

  final List<Widget> navIcons = [
    Image.asset('lib/assets/icon/icnHome.png', width: 24, height: 24),
    Image.asset('lib/assets/icon/icnBooking.png', width: 24, height: 24),
    Image.asset('lib/assets/icon/icnProfile.png', width: 24, height: 24),
  ];

  final List<String> navTitles = ['Ayo Cari', 'Booking', 'Profile'];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'B-Camp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
      ),

      home: Scaffold(

        body: pages[selectedIndex],

        extendBody: true,
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
        color: Colors.black.withOpacity(
          0.8,
        ), // Warna navbar dengan transparansi
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(
              0.2,
            ), // Bayangan dengan transparansi
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
                selectedIndex = index;
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
