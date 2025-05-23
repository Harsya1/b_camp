import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:b_camp/screen/camp_section/camp_detail.dart';
import 'package:b_camp/service/database/controller/itemCampController.dart';
import 'package:b_camp/service/database/model/Kamar.dart';
import 'package:b_camp/screen/routes/app_drawer.dart';
// import 'package:b_camp/screen/booking_section/input_data.dart';

class DashboardCamp extends StatefulWidget {
  const DashboardCamp({super.key});

  @override
  State<DashboardCamp> createState() => _DashboardCamp();
}

class _DashboardCamp extends State<DashboardCamp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#f2f2f2'.toColor(), // Warna latar belakang abu-abu muda
      drawer: const AppDrawer(), // Side navigation bar
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan hanya sidebar navigasi dan textfield cari camp
            _buildHeader(),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_itemCamp()],
              ),
            ),
            const SizedBox(
              height: 20,
            ), // Jarak antara _itemCamp() dan section event
          ],
        ),
      ),
    );
  }

  // Widget untuk membangun header dengan hanya sidebar navigasi dan textfield cari camp
  Widget _buildHeader() {
    return Container(
      height:
          150, // Tetapkan tinggi untuk header agar tidak menyebabkan error layout
      color: '#f2f2f2'.toColor(), // Warna latar belakang abu-abu muda
      child: Stack(
        clipBehavior: Clip.none, // Pastikan widget di luar Stack tetap terlihat
        children: [
          // Tombol Menu di pojok kiri atas
          Positioned(
            left: 10,
            top: 20,
            child: Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () {
                      Scaffold.of(
                        context,
                      ).openDrawer(); // Buka side navigation bar
                    },
                  ),
            ),
          ),
          Positioned(
            top: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Booking Camp",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),

          // TextField pencarian di bawah header
          Positioned(
            bottom: 10,
            left: 25,
            right: 25,
            child: TextField(
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cari Camp!',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk side navigation bar
  // Widget _buildSideNavigationBar(BuildContext context) {
  //   return Drawer(
  //     child: Column(
  //       children: [
  //         const SizedBox(
  //           width: double.infinity,
  //           child: DrawerHeader(
  //             decoration: BoxDecoration(color: Colors.black),
  //             child: Text(
  //               'B-Camp Admin Menu',
  //               style: TextStyle(color: Colors.white, fontSize: 24),
  //             ),
  //           ),
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.home),
  //           title: const Text('Dashboard Camp'),
  //           onTap: () {
  //             Navigator.pushReplacement(
  //               context,
  //               MaterialPageRoute(
  //                 builder:
  //                     (context) =>
  //                         const DashboardCamp(), // Menggunakan DashboardCamp
  //               ),
  //             );
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.calendar_today, color: Colors.black),
  //           title: const Text(
  //             'Dashboard Calendar',
  //             style: TextStyle(color: Colors.black),
  //           ),
  //           onTap: () {
  //             Navigator.pop(context); // Kembali ke halaman utama
  //             Navigator.pushNamed(context, '/dashboard_calender');
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.add_circle, color: Colors.black),
  //           title: const Text(
  //             'Create Camp',
  //             style: TextStyle(color: Colors.black),
  //           ),
  //           onTap: () {
  //             Navigator.pop(context); // Kembali ke halaman utama
  //             Navigator.pushNamed(context, '/create_camp');
  //           },
  //         ),
  //         ListTile(
  //           leading: const Icon(Icons.edit, color: Colors.black),
  //           title: const Text(
  //             'Edit Camp',
  //             style: TextStyle(color: Colors.black),
  //           ),
  //           onTap: () {
  //             Navigator.pop(context); // Kembali ke halaman utama
  //             Navigator.pushNamed(context, '/edit_camp');
  //           },
  //         ),
  //         const Spacer(), // Jarak antara item menu dan bagian bawah
  //         Padding(
  //           padding: const EdgeInsets.only(
  //             top: 50,
  //             bottom: 20,
  //             left: 16,
  //             right: 16,
  //           ),
  //           child: SizedBox(
  //             width: double.infinity,
  //             child: ElevatedButton(
  //               style: ElevatedButton.styleFrom(
  //                 backgroundColor: Colors.black,
  //                 padding: const EdgeInsets.symmetric(vertical: 14),
  //                 shape: RoundedRectangleBorder(
  //                   borderRadius: BorderRadius.circular(30),
  //                 ),
  //               ),
  //               onPressed: () {
  //                 Navigator.pushNamed(context, '/login');
  //               },
  //               child: const Text(
  //                 'Logout',
  //                 style: TextStyle(color: Colors.white),
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget untuk menampilkan daftar tipe camp dalam bentuk grid
  Widget _itemCamp() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ItemCampController.getCamps(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print('Error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada data camp tersedia'));
        }

        var camps = snapshot.data!;
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 250,
          ),
          itemCount: camps.length,
          itemBuilder: (context, index) {
            final camp = camps[index];
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/placeholder_camp',
                  arguments: {'id': camp['id']},
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child:
                          camp['gambar_camp'] != null
                              ? Image.network(
                                camp['gambar_camp'],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 150,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 48,
                                    ),
                                  );
                                },
                              )
                              : Container(
                                height: 150,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image, size: 48),
                              ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            camp['nama_camp'] ?? 'Unnamed Camp',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            camp['alamat'] ?? 'No address',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
