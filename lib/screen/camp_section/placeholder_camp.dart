import 'package:flutter/material.dart';
import 'package:b_camp/service/database/controller/itemCampController.dart';
import 'package:b_camp/service/database/controller/itemKamarController.dart';
import 'package:url_launcher/url_launcher.dart';

class PlaceholderCamp extends StatefulWidget {
  final int campId;
  const PlaceholderCamp({Key? key, required this.campId}) : super(key: key);

  @override
  State<PlaceholderCamp> createState() => _PlaceholderCampState();
}

class _PlaceholderCampState extends State<PlaceholderCamp> {
  bool isLoading = true;
  bool isDeleting = false;
  bool isVipUpgraded = false; // Untuk upgrade VIP tampilan
  Map<String, dynamic>? campData;
  List<String> kamarTypes = [];

  @override
  void initState() {
    super.initState();
    _loadCampData();
  }

  Future<void> _loadCampData() async {
    try {
      setState(() => isLoading = true);
      final camp = await ItemCampController.getCampDetail(widget.campId);
      final types = await ItemKamarController.getKamarTypesByCamp(widget.campId);

      setState(() {
        campData = camp;
        kamarTypes = types;
        isLoading = false;
        isVipUpgraded = false; // Reset upgrade jika reload
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

  Future<void> _deleteCamp() async {
    try {
      setState(() => isDeleting = true);
      final success = await ItemCampController.deleteCamp(widget.campId);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Camp berhasil dihapus')),
          );
          Navigator.pop(context, true);
        } else {
          throw Exception('Failed to delete camp');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isDeleting = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error menghapus camp: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : campData == null
              ? const Center(child: Text('Data tidak ditemukan'))
              : Stack(
                  children: [
                    SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              child: campData!['gambar_camp'] != null
                                  ? InteractiveViewer(
                                      minScale: 1.0,
                                      maxScale: 5.0,
                                      child: Image.network(
                                        '${ItemCampController.imageBaseUrl}/${campData!['gambar_camp']}',
                                        width: double.infinity,
                                        height: 300,
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
                                      ),
                                    )
                                  : Container(
                                      height: 200,
                                      color: Colors.grey[300],
                                      child: const Icon(Icons.image, size: 50),
                                    ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              campData!['nama_camp'] ?? 'Unnamed Camp',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              campData!['deskripsi'] ?? 'No description',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 18,
                                  color: Colors.grey,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () async {
                                      final alamat = campData!['alamat'] ?? '';
                                      if (alamat.isEmpty || alamat == 'No address') {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Alamat tidak tersedia')),
                                        );
                                        return;
                                      }
                                      final url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(alamat)}');
                                      if (await canLaunchUrl(url)) {
                                        await launchUrl(url);
                                      } else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Tidak dapat membuka Google Maps')),
                                        );
                                      }
                                    },
                                    child: Text(
                                      campData!['alamat'] ?? 'No address',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blue,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 20),
                            // Tambahkan widget Edit Camp dan Tambah Kamar yang hilang
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Edit Camp Button
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/edit_camp',
                                      arguments: campData,
                                    ).then((value) {
                                      if (value == true) _loadCampData();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.edit,
                                    color: Colors.black,
                                  ),
                                  label: const Text(
                                    'Edit Camp',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),

                                // Add Kamar Button
                                TextButton.icon(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                      context,
                                      '/create_kamar',
                                      arguments: {'camp_id': widget.campId},
                                    ).then((value) {
                                      if (value == true) _loadCampData();
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                  label: const Text(
                                    'Tambah Kamar',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Tipe Kamar Tersedia',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                ElevatedButton.icon(
                                  onPressed: isLoading
                                      ? null
                                      : () async {
                                          // Konfirmasi pertama
                                          final confirm1 = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Konfirmasi'),
                                              content: const Text(
                                                'Apakah anda yakin ingin melakukan upgrade tipe kamar? Ini akan mengubah semua tipe kamar di camp tersebut saat ini',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, true),
                                                  child: const Text('Ya, Upgrade'),
                                                ),
                                              ],
                                            ),
                                          );

                                          // Hentikan jika konfirmasi pertama dibatalkan
                                          if (confirm1 != true) return;

                                          // Konfirmasi kedua dengan styling berbeda
                                          final confirm2 = await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('Konfirmasi'),
                                              content: const Text(
                                                'Apakah anda benar benar yakin? Tipe kamar yang diubah saat ini tidak bisa dikembalikan secara serentak',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, false),
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.blue,
                                                  ),
                                                  child: const Text('Batal'),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, true),
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.red,
                                                  ),
                                                  child: const Text('Ya, Saya Yakin'),
                                                ),
                                              ],
                                            ),
                                          );

                                          // Hanya lanjutkan jika kedua konfirmasi disetujui
                                          if (confirm2 != true) return;

                                          setState(() => isLoading = true);
                                          try {
                                            // 1. Ambil semua kamar camp ini
                                            final kamarList = await ItemKamarController.getKamarByType(
                                              widget.campId,
                                              'Regular', // Ganti ini jika ingin upgrade semua tipe, bukan hanya Regular
                                            );
                                            // 2. Update semua tipe kamar menjadi VIP
                                            for (var kamar in kamarList) {
                                              await ItemKamarController.updateKamar(
                                                id: kamar['id'],
                                                typeKamar: 'VIP',
                                              );
                                            }
                                            // 3. Reload data
                                            await _loadCampData();
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              const SnackBar(content: Text('Semua kamar berhasil di-upgrade ke VIP')),
                                            );
                                          } catch (e) {
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(content: Text('Gagal upgrade VIP: $e')),
                                            );
                                          }
                                          setState(() => isLoading = false);
                                        },
                                  icon: const Icon(Icons.star, color: Colors.amber),
                                  label: const Text(
                                    'Upgrade VIP',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.amber,
                                    ),
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.amber[50],
                                    foregroundColor: Colors.amber[900],
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            if (kamarTypes.isEmpty)
                              Center(
                                child: Text(
                                  'Belum ada tipe kamar',
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              )
                            else
                              ListView.separated(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: kamarTypes.length,
                                separatorBuilder: (_, __) => const Divider(),
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    leading: const Icon(Icons.bed_rounded, color: Colors.black),
                                    title: Text(
                                      isVipUpgraded ? 'VIP' : kamarTypes[index], // TAMPILAN SAJA YANG DIUBAH
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.black),
                                    onTap: () {
                                      Navigator.pushNamed(
                                        context,
                                        '/list_kamar',
                                        arguments: {
                                          'camp_id': widget.campId,
                                          'type': kamarTypes[index], // Tetap kirim type ASLI!
                                          'vip_override': isVipUpgraded, // <-- tambahkan flag ini
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                            const SizedBox(height: 100),
                          ],
                        ),
                      ),
                    ),
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
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isDeleting
                ? null
                : () async {
                    final confirm = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Konfirmasi'),
                        content: const Text(
                          'Menghapus camp juga akan menghapus seluruh data kamar yang tersedia\nApakah anda yakin ingin menghapusnya?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('Batal'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) {
                      _deleteCamp();
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
            child: isDeleting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Text(
                    'Hapus Camp',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}