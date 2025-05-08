import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:supercharged/supercharged.dart';
import 'package:b_camp/screen/camp_section/camp_detail.dart';
import 'package:b_camp/service/database/controller/itemCampController.dart';
import 'dashboard_calender.dart';

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
      drawer: _buildSideNavigationBar(context), // Side navigation bar
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan hanya sidebar navigasi dan textfield cari camp
            _buildHeader(),
            const SizedBox(height: 50),
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
  Widget _buildSideNavigationBar(BuildContext context) {
    return Drawer(
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
            leading: const Icon(Icons.home, color: Colors.black),
            title: const Text(
              'Dashboard Camp',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context); // Kembali ke halaman utama
              Navigator.pushNamed(context, '/dashboard_camp');
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today, color: Colors.black),
            title: const Text(
              'Dashboard Calendar',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pop(context); // Kembali ke halaman utama
              Navigator.pushNamed(context, '/dashboard_calender');
            },
          ),
        ],
      ),
    );
  }

  // Widget untuk menampilkan daftar tipe camp dalam bentuk horizontal scroll
  Widget _itemCamp() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ItemCampController.getCamps(), // Panggil API dari controller
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Tampilkan indikator loading saat data sedang dimuat
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // Tampilkan pesan error jika terjadi kesalahan
          print('Error: ${snapshot.error}');
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          // Jika data tersedia
          var data = snapshot.data!;
          if (data.isEmpty) {
            // Jika data kosong
            return const Center(child: Text('Tidak ada data camp tersedia'));
          }

          return SizedBox(
            height: 250, // Tinggi kontainer untuk item camp
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Scroll secara horizontal
              itemCount: data.length,
              itemBuilder: (context, index) {
                final camp = data[index];
                return GestureDetector(
                  onTap: () {
                    // Navigasi ke halaman detail camp
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CampDetail()),
                    );
                  },
                  child: Container(
                    width:
                        MediaQuery.of(context).size.width *
                        0.8, // Lebar responsif
                    margin: const EdgeInsets.only(right: 10),
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
                    child: Stack(
                      children: [
                        // Placeholder untuk gambar (warna abu-abu)
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                          ),
                        ),
                        // Nama tipe camp di pojok kiri bawah
                        Positioned(
                          bottom: 10,
                          left: 10,
                          child: Text(
                            camp['nama_kamar'] ?? 'Nama tidak tersedia',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          // Jika tidak ada data
          return const Center(child: Text('Tidak ada data camp tersedia'));
        }
      },
    );
  }
}
