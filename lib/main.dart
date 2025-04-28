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
  int selectedIndex = 2; // Set ke halaman profil saat start

  final List<Widget> pages = [
    dashboard_main(),
    Center(child: Text('Booking Page')),
    const ProfilePage(),
  ];

  final List<Widget> navIcons = [
    ImageIcon(AssetImage('assets/icon/icnHome.png'), size: 24),
    ImageIcon(AssetImage('assets/icon/icnBooking.png'), size: 24),
    ImageIcon(AssetImage('assets/icon/icnProfile.png'), size: 24),
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
                selectedIndex = index;
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
