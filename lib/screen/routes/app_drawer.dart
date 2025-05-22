import 'package:flutter/material.dart';
import '../dashboard_camp.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const SizedBox(
            width: double.infinity,
            child: DrawerHeader(
              decoration: BoxDecoration(color: Colors.black),
              child: Text(
                'B-Camp Admin Menu',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Dashboard Camp'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const DashboardCamp()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.black),
            title: const Text(
              'Dashboard Calendar',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/dashboard_calender');
            },
          ),
          ListTile(
            leading: const Icon(Icons.add_circle, color: Colors.black),
            title: const Text(
              'Create Camp',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, '/create_kamar');
            },
          ),
          ListTile(
            leading: const Icon(Icons.edit, color: Colors.black),
            title: const Text(
              'Edit Camp',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context); // Kembali ke halaman utama
              Navigator.pushNamed(context, '/crud_camp');
            },
          ),

          const Spacer(),

          Padding(
            padding: const EdgeInsets.only(
              top: 50,
              bottom: 20,
              left: 16,
              right: 16,
            ),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text(
                  'Logout',
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
