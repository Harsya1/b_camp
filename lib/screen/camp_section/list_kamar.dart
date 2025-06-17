import 'package:flutter/material.dart';
import 'package:b_camp/service/database/controller/itemKamarController.dart';
import 'package:intl/intl.dart';

class ListKamar extends StatefulWidget {
  final int campId;
  final String type;

  const ListKamar({Key? key, required this.campId, required this.type})
      : super(key: key);

  @override
  State<ListKamar> createState() => _ListKamarState();
}

class _ListKamarState extends State<ListKamar> {
  bool isLoading = true;
  List<Map<String, dynamic>> kamarList = [];
  final _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  late bool vipOverride;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ambil flag vip_override dari arguments
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    vipOverride = args != null && args['vip_override'] == true;
  }

  @override
  void initState() {
    super.initState();
    _loadKamarList();
  }

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
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Judul menyesuaikan flag VIP
    final String tipeJudul = vipOverride ? 'VIP' : widget.type;

    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        title: Text('Kamar Tipe $tipeJudul'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.pushNamed(
                context,
                '/create_kamar',
                arguments: {'camp_id': widget.campId, 'type': widget.type},
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
                        'Belum ada kamar untuk tipe $tipeJudul',
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
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    mainAxisExtent: 250,
                  ),
                  itemCount: kamarList.length,
                  itemBuilder: (context, index) =>
                      _buildKamarCard(kamarList[index]),
                ),
    );
  }

  Widget _buildKamarCard(Map<String, dynamic> kamar) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/detail_kamar',
          arguments: {
            'kamar_id': kamar['id'],
            'vip_override': vipOverride, // Kirim juga ke detail jika perlu
          },
        ).then((value) {
          if (value == true) _loadKamarList();
        });
      },
      child: Card(
        elevation: 3,
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
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
                  // Tampilkan tipe kamar sesuai flag VIP
                  Text(
                    'Tipe Kamar: ${vipOverride ? 'VIP' : (kamar['tipe'] ?? '-')}', // <--- ini
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
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