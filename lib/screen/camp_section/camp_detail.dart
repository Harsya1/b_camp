import 'package:flutter/material.dart';
import 'package:b_camp/service/database/controller/itemCampController.dart';

class CampDetail extends StatelessWidget {
  final int kamarId;

  const CampDetail({Key? key, required this.kamarId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          FutureBuilder<Map<String, dynamic>>(
            future: ItemCampController.getCampDetail(kamarId),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData) {
                return const Center(child: Text('Data tidak ditemukan'));
              }

              final camp = snapshot.data!;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Gambar camp
                    camp['gambar_camp'] != null
                        ? Image.network(
                          camp['gambar_camp'],
                          width: double.infinity,
                          height: 250,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 250,
                              color: Colors.grey[300],
                              child: const Icon(Icons.broken_image, size: 48),
                            );
                          },
                        )
                        : Container(
                          height: 250,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 48),
                        ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            camp['nama_camp'] ?? 'Unnamed Camp',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Deskripsi:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            camp['deskripsi'] ?? 'Tidak ada deskripsi',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 16),
                          _buildDetailRow('Alamat', camp['alamat'] ?? 'No address'),
                          _buildDetailRow('Jumlah Maksimal Kamar', 
                            camp['jumlah_maksimal_kamar']?.toString() ?? '0'),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          // Back button
          Positioned(
            top: 20,
            left: 20,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.black,
              onPressed: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }
}
