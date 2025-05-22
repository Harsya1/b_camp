import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:b_camp/screen/booking_section/input_data.dart';

class BookingSection extends StatefulWidget {
  const BookingSection({super.key});

  @override
  State<BookingSection> createState() => _BookingSectionPlace();
}

class _BookingSectionPlace extends State<BookingSection> {
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
                // Gambar header
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
                // Judul, deskripsi, alamat, dan list booking
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
                      // Container untuk list booking yang bisa discroll
                      Container(
                        height: 400, // atur tinggi sesuai kebutuhan
                        decoration: BoxDecoration(
                          color: 'f2f2f2'.toColor(),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: 3, // jumlah item contoh
                          separatorBuilder: (context, index) => const Divider(),
                          itemBuilder:
                              (context, index) => ListTile(
                                leading: const Icon(Icons.bed_rounded),
                                title: Text('Tipe Kamar #${index + 1}'),
                                subtitle: const Text('Detail booking'),
                                trailing: const Icon(
                                  Icons.arrow_forward_ios,
                                  size: 16,
                                ),
                                onTap:
                                    index == 0
                                        ? () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const InputData(),
                                            ),
                                          );
                                        }
                                        : null,
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
