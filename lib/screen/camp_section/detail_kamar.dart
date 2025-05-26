import 'package:flutter/material.dart';
import 'package:b_camp/service/database/controller/itemKamarController.dart';

class DetailKamar extends StatefulWidget {
  final int kamarId;

  const DetailKamar({Key? key, required this.kamarId}) : super(key: key);

  @override
  State<DetailKamar> createState() => _DetailKamarState();
}

class _DetailKamarState extends State<DetailKamar> {
  bool isLoading = true;
  Map<String, dynamic>? kamarData;

  @override
  void initState() {
    super.initState();
    _loadKamarDetail();
  }

  Future<void> _loadKamarDetail() async {
    try {
      setState(() => isLoading = true);
      final data = await ItemKamarController.getKamarDetail(widget.kamarId);
      setState(() {
        kamarData = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : kamarData == null
              ? const Center(child: Text('Data tidak ditemukan'))
              : Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kamar Image
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                          child:
                              kamarData!['gambar'] != null
                                  ? Image.network(
                                    '${ItemKamarController.imageBaseUrl}/${kamarData!['gambar']}',
                                    width: double.infinity,
                                    height: 200,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        height: 200,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.broken_image,
                                          size: 50,
                                        ),
                                      );
                                    },
                                  )
                                  : Container(
                                    height: 200,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, size: 50),
                                  ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      kamarData!['nama_kamar'] ?? 'Unnamed',
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    'Rp ${kamarData!['harga']?.toString() ?? '0'}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildInfoSection(
                                'Tipe Kamar',
                                kamarData!['type_kamar'],
                              ),
                              _buildInfoSection(
                                'Kategori',
                                kamarData!['kategori'],
                              ),
                              _buildInfoSection('Gender', kamarData!['gender']),
                              _buildInfoSection(
                                'Jumlah Kasur',
                                kamarData!['jumlah_kasur']?.toString(),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Fasilitas',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                kamarData!['fasilitas'] ??
                                    'Tidak ada fasilitas',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text(
                                'Peraturan',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                kamarData!['peraturan'] ??
                                    'Tidak ada peraturan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[600],
                                ),
                              ),
                              if (kamarData!['catatan_tambahan'] != null) ...[
                                const SizedBox(height: 20),
                                const Text(
                                  'Catatan Tambahan',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  kamarData!['catatan_tambahan'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                              const SizedBox(height: 30),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/edit_kamar',
                                      arguments: {
                                        'kamar_data': kamarData,
                                        'camp_id': kamarData!['camp_id'],
                                      },
                                    ).then((value) {
                                      if (value == true) _loadKamarDetail();
                                    });
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 15,
                                    ),
                                  ),
                                  child: const Text(
                                    'Edit Kamar',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Back Button
                  Positioned(
                    top: 40,
                    left: 10,
                    child: Material(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(30),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                  ),
                ],
              ),
    );
  }

  Widget _buildInfoSection(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value ?? '-',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
