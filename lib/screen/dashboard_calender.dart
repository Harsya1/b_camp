import 'package:flutter/material.dart';
import 'dashboard_camp.dart';

class DashboardCalender extends StatefulWidget {
  const DashboardCalender({super.key});

  @override
  State<DashboardCalender> createState() => _DashboardCalenderState();
}

class _DashboardCalenderState extends State<DashboardCalender> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard Calendar')),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: const Text(
                'B-Camp Admin Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Dashboard Camp'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const DashboardCamp(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.calendar_today),
              title: const Text('Dashboard Calendar'),
              onTap: () {
                Navigator.pop(context); // Tetap di halaman ini
              },
            ),
          ],
        ),
      ),
      body: const Center(child: Text('Halaman Kalender')),
    );
  }
}
