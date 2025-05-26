import 'package:flutter/material.dart';

class ListBookingKamar extends StatefulWidget {
  const ListBookingKamar({Key? key}) : super(key: key);

  @override
  State<ListBookingKamar> createState() => _ListBookingKamarState();
}

class _ListBookingKamarState extends State<ListBookingKamar> {
  // Dummy data untuk contoh layout
  final List<Map<String, dynamic>> bookingList = [
    {
      'nama_kamar': 'Kamar 101',
      'gender': 'Laki-laki',
      'harga': 250000,
      'gambar': null,
    },
    {
      'nama_kamar': 'Kamar 102',
      'gender': 'Perempuan',
      'harga': 275000,
      'gambar': null,
    },
    // Tambahkan data dummy lain jika perlu
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Daftar Booking Kamar')),
      body:
          bookingList.isEmpty
              ? Center(
                child: Text(
                  'Belum ada booking kamar',
                  style: TextStyle(color: Colors.grey[600]),
                ),
              )
              : GridView.builder(
                padding: const EdgeInsets.all(16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  mainAxisExtent: 250,
                ),
                itemCount: bookingList.length,
                itemBuilder:
                    (context, index) => _buildBookingCard(bookingList[index]),
              ),
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    return GestureDetector(
      onTap: () {
        // Navigasi ke detail booking jika diperlukan
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child:
                  booking['gambar'] != null
                      ? Image.network(
                        booking['gambar'],
                        height: 120,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 120,
                            color: Colors.grey[300],
                            child: const Icon(Icons.broken_image),
                          );
                        },
                      )
                      : Container(
                        height: 120,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image),
                      ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    booking['nama_kamar'] ?? 'Unnamed',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gender: ${booking['gender'] ?? '-'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${booking['harga']?.toString() ?? '0'}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
