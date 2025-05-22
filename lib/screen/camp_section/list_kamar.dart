import 'package:flutter/material.dart';
import 'package:b_camp/service/database/controller/itemKamarController.dart';

class ListKamar extends StatefulWidget {
  final int campId;
  final String type;
  
  const ListKamar({
    Key? key, 
    required this.campId,
    required this.type,
  }) : super(key: key);

  @override
  State<ListKamar> createState() => _ListKamarState();
}

class _ListKamarState extends State<ListKamar> {
  bool isLoading = true;
  List<Map<String, dynamic>> kamarList = [];

  @override
  void initState() {
    super.initState();
    _loadKamarList();
  }

  // Update _loadKamarList method
  Future<void> _loadKamarList() async {
    try {
      setState(() => isLoading = true);
      final data = await ItemKamarController.getKamarByType(
        widget.campId,
        widget.type,
      );
      setState(() {
        kamarList = data;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kamar Tipe ${widget.type}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/create_kamar',
                arguments: {
                  'camp_id': widget.campId,
                  'type': widget.type,
                },
              ).then((value) {
                if (value == true) _loadKamarList();
              });
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : kamarList.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Belum ada kamar untuk tipe ${widget.type}',
                        style: TextStyle(color: Colors.grey[600]),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushNamed(
                            context,
                            '/create_kamar',
                            arguments: {
                              'camp_id': widget.campId,
                              'type': widget.type,
                            },
                          ).then((value) {
                            if (value == true) _loadKamarList();
                          });
                        },
                        child: const Text('Tambah Kamar Baru'),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.75,
                  ),
                  itemCount: kamarList.length,
                  itemBuilder: (context, index) => _buildKamarCard(kamarList[index]),
                ),
    );
  }

  Widget _buildKamarCard(Map<String, dynamic> kamar) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detail_kamar',
          arguments: {'kamar_id': kamar['id']},
        ).then((value) {
          if (value == true) _loadKamarList();
        });
      },
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: kamar['gambar'] != null
                  ? Image.network(
                      '${ItemKamarController.imageBaseUrl}/${kamar['gambar']}',
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
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${kamar['harga']?.toString() ?? '0'}',
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
