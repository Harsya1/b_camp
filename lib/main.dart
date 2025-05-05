import 'package:flutter/material.dart';
import 'screen/home_dashboard.dart';
import 'screen/login_register_section/login_action.dart'; 
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
  bool isLoggedIn = false;

  final List<Widget> pages = [
    dashboard_main(),
    Center(child: Text('Booking Page')),
    Center(child: Text('Profile Page')),
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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      home: isLoggedIn
          ? Scaffold(
              body: pages[selectedIndex],
              bottomNavigationBar: _navbar(),
            )
          : LoginPage(
              onLogin: () {
                setState(() {
                  isLoggedIn = true;
                });
              },
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
