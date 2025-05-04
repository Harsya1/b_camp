import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:b_camp/screen/search_section.dart';
import 'package:supercharged/supercharged.dart';
import 'package:b_camp/service/database/controller/itemCampController.dart';
import 'package:b_camp/service/database/controller/itemEventController.dart';

class DashboardMain extends StatefulWidget {
  const DashboardMain({super.key});

  final String url = 'https://kampunginggrismu.com/api'; // URL API Laravel

  Future<List<dynamic>> getItemCamp() async {
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  State<DashboardMain> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<DashboardMain> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#f2f2f2'.toColor(), // Warna latar belakang abu-abu muda
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header dengan gambar latar belakang dan teks selamat datang
            _buildHeader(),
            const SizedBox(height: 50),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul "Tipe Camp Kami"
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Tipe Camp Kami',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          // Navigasi ke halaman search_section
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SearchSection(),
                            ),
                          );
                        },
                        child: const Text(
                          'Lihat Selengkapnya',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Daftar tipe camp dengan data dari API
                  _itemCamp(),
                ],
              ),
            ),
            // Tambahkan di bawah _itemCamp() pada line 83
            const SizedBox(
              height: 20,
            ), // Jarak antara _itemCamp() dan section event
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Judul "Event Kami"
                  const Text(
                    'Event Kami',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Roboto',
                    ),
                  ),
                  const SizedBox(height: 10),
                  // Konten event (placeholder untuk sekarang)
                  _itemEvent(),
                ],
              ),
            ),
            const SizedBox(
              height: 150,
            ), // Jarak antara event dan konten lainnya
          ],
        ),
      ),
    );
  }

  // Widget untuk membangun header dengan gambar latar belakang
  Widget _buildHeader() {
    return Stack(
      children: [
        Container(
          color: '#f2f2f2'.toColor(),
          child: Stack(
            clipBehavior:
                Clip.none, // Pastikan widget di luar Stack tetap terlihat
            children: [
              // Gambar latar belakang dengan teks selamat datang
              Container(
                width: double.infinity,
                height: 220,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  image: DecorationImage(
                    image: const AssetImage(
                      'lib/assets/background/background_home_dashboard.jpg',
                    ),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20, top: 36),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Hi Nameless!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Welcome to B-Camp',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Tombol notifikasi di kanan atas
              Positioned(
                right: 20,
                top: 20,
                child: IconButton(
                  icon: const Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    // Tambahkan logika untuk notifikasi di sini
                    print('Notifikasi button pressed');
                  },
                ),
              ),
              // Tombol pencarian di bawah header
              Positioned(
                bottom: -25,
                left: 25,
                right: 25,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigasi ke halaman search_section
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchSection(),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 50,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.search, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              'Ayo cari camp yang kamu inginkan!',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget untuk menampilkan daftar tipe camp dalam bentuk horizontal scroll
  Widget _itemCamp() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ItemCampController.getCamps(), // Panggil API dari controller
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData) {
          var data = snapshot.data!;
          return SizedBox(
            height: 250, // Tinggi kontainer untuk item camp
            child: ListView.builder(
              scrollDirection: Axis.horizontal, // Scroll secara horizontal
              itemCount: data.length,
              itemBuilder: (context, index) {
                final camp = data[index];
                return Container(
                  width: 300, // Lebar kontainer
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
                      // Nama tipe camp di pojok kiri bawah
                      Positioned(
                        bottom: 10,
                        left: 10,
                        child: Text(
                          camp['nama_kamar'], // Nama tipe camp dari API
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
                );
              },
            ),
          );
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  // Widget untuk menampilkan daftar event dalam bentuk dua item berjajar
  Widget _itemEvent() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: ItemEventController.getEvents(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Tidak ada event tersedia'));
        }

        var events = snapshot.data!;
        return SizedBox(
          height: 260,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: events.length,
            itemBuilder: (context, index) {
              final event = events[index];
              return Container(
                width: 180,
                margin: const EdgeInsets.only(right: 15),
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
                    // Event Image
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Image.network(
                        event['gambar'] ?? 'https://via.placeholder.com/300x120',
                        height: 80,
                        width: 180,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 80,
                            color: Colors.grey[300],
                            child: const Icon(Icons.event, size: 48),
                          );
                        },
                      ),
                    ),
                    // Event Details
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            event['nama_event'] ?? 'Event tidak tersedia',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            event['lokasi'] ?? 'Lokasi tidak tersedia',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, 
                                  size: 16, color: Colors.blue[700]),
                              const SizedBox(width: 4),
                              Text(
                                _formatDate(event['tanggal_mulai']),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.blue,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // Add this helper method for date formatting
  String _formatDate(String? dateString) {
    if (dateString == null) return 'Tanggal tidak tersedia';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return 'Invalid date';
    }
  }
}
