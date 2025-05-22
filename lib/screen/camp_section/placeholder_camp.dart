import 'package:flutter/material.dart';
import 'package:b_camp/screen/camp_section/list_kamar.dart';

class PlaceholderCamp extends StatelessWidget {
  const PlaceholderCamp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar tanpa padding
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    'lib/assets/background/background_home_dashboard.jpg',
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                // Nama Camp, deskripsi, alamat, dan list
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nama Camp",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        "Deskripsi singkat camp ini. Bisa diisi dengan info fasilitas, keunggulan, dsb.",
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: const [
                          Icon(Icons.location_on, size: 18, color: Colors.grey),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              "Jl. Contoh Alamat No. 123, Pare, Kediri",
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Baris Edit data (kiri) dan Tambah data kamar (kanan)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Edit data (kiri)
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, "/edit_camp");
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.edit, color: Colors.black, size: 18),
                                SizedBox(width: 4),
                                Text(
                                  "Edit data",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // Tambah data kamar (kanan)
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/create_kamar');
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.add, color: Colors.black, size: 18),
                                SizedBox(width: 4),
                                Text(
                                  "Tambah data kamar",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // Container untuk list item yang bisa discroll
                      Container(
                        height: 400, // atur tinggi sesuai kebutuhan
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: 3, // jumlah item contoh
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder:
                              (context, index) => ListTile(
                                leading: const Icon(Icons.bed),
                                title: Text('Tipe Kamar ${index + 1}'),
                                subtitle: const Text('Deskripsi item'),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onTap: () {
                                  // Navigasi ke ListKamar saat item ditekan
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const ListKamar(),
                                    ),
                                  );
                                },
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tombol back di atas gambar, menempel di pojok kiri atas
          Positioned(
            top: 32,
            left: 16,
            child: Material(
              color: Colors.transparent,
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Colors.black,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
