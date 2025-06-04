import 'package:flutter/material.dart';
import 'package:b_camp/service/database/controller/itemBookingController.dart';
import 'package:b_camp/screen/booking_section/input_data.dart';
import 'package:intl/intl.dart';

class ListBookingKamar extends StatefulWidget {
  final int campId;
  final String kamarType;

  const ListBookingKamar({
    Key? key,
    required this.campId,
    required this.kamarType,
  }) : super(key: key);

  @override
  State<ListBookingKamar> createState() => _ListBookingKamarState();
}

class _ListBookingKamarState extends State<ListBookingKamar> {
  List<Map<String, dynamic>> kamarList = [];
  bool isLoading = true;
  final _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  @override
  void initState() {
    super.initState();
    _loadKamarList();
  }

  Future<void> _loadKamarList() async {
    try {
      setState(() => isLoading = true);
      final data = await ItemBookingController.getKamarByType(
        widget.campId,
        widget.kamarType,
      );

      if (mounted) {
        setState(() {
          kamarList = data;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kamar ${widget.kamarType}'),
        backgroundColor: Colors.white,
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : kamarList.isEmpty
              ? Center(
                child: Text(
                  'Belum ada kamar tersedia',
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
                itemCount: kamarList.length,
                itemBuilder:
                    (context, index) => _buildKamarCard(kamarList[index]),
              ),
    );
  }

  Widget _buildKamarCard(Map<String, dynamic> kamar) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) =>
                    InputData(kamarId: kamar['id'], kamarDetail: kamar),
          ),
        );
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
                  kamar['gambar'] != null
                      ? Image.network(
                        '${ItemBookingController.imageBaseUrl}/${kamar['gambar']}',
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
                    kamar['nama_kamar'] ?? 'Unnamed',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Gender: ${kamar['gender'] ?? '-'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _currencyFormatter.format(
                      double.tryParse(kamar['harga'] ?? '0') ?? 0,
                    ),
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
