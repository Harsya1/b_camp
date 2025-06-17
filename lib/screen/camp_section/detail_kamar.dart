import 'package:flutter/material.dart';
import 'package:b_camp/service/database/controller/itemKamarController.dart';
import 'package:intl/intl.dart';

class DetailKamar extends StatefulWidget {
  final int kamarId;

  const DetailKamar({Key? key, required this.kamarId}) : super(key: key);

  @override
  State<DetailKamar> createState() => _DetailKamarState();
}

class _DetailKamarState extends State<DetailKamar> {
  bool isLoading = true;
  bool isDeleting = false;
  Map<String, dynamic>? kamarData;
  final _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

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

  Future<void> _deleteKamar() async {
    try {
      setState(() => isDeleting = true);
      final success = await ItemKamarController.deleteKamar(widget.kamarId);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Kamar berhasil dihapus')),
          );
          Navigator.pop(context, true); // Return true to indicate deletion
        } else {
          throw Exception('Failed to delete kamar');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isDeleting = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error menghapus kamar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
                                  ? InteractiveViewer(
                                    minScale: 1.0,
                                    maxScale: 5.0,
                                    child: Image.network(
                                      '${ItemKamarController.imageBaseUrl}/${kamarData!['gambar']}',
                                      width: double.infinity,
                                      height: 300,
                                      fit: BoxFit.cover,
                                      errorBuilder: (
                                        context,
                                        error,
                                        stackTrace,
                                      ) {
                                        return Container(
                                          height: 200,
                                          color: Colors.grey[300],
                                          child: const Icon(
                                            Icons.broken_image,
                                            size: 50,
                                          ),
                                        );
                                      },
                                    ),
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
                                    _currencyFormatter.format(
                                      double.tryParse(
                                            kamarData!['harga'] ?? '0',
                                          ) ??
                                          0,
                                    ),
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
                              // Add bottom padding to prevent overlap with bottom buttons
                              const SizedBox(height: 150),
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
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Edit Button
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
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Edit Kamar',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Delete Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed:
                    isDeleting
                        ? null
                        : () async {
                          final confirm = await showDialog<bool>(
                            context: context,
                            builder:
                                (context) => AlertDialog(
                                  title: const Text('Konfirmasi'),
                                  content: const Text(
                                    'Apakah anda yakin ingin menghapus data kamar ini ?',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, false),
                                      child: const Text('Batal'),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.pop(context, true),
                                      child: const Text('Hapus'),
                                    ),
                                  ],
                                ),
                          );
                          if (confirm == true) {
                            _deleteKamar();
                          }
                        },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child:
                    isDeleting
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                          'Hapus Kamar',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
              ),
            ),
          ],
        ),
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
