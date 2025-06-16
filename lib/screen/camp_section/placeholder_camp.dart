import 'package:flutter/material.dart';
import 'package:b_camp/service/database/controller/itemCampController.dart';
import 'package:b_camp/service/database/controller/itemKamarController.dart';

class PlaceholderCamp extends StatefulWidget {
  final int campId;
  const PlaceholderCamp({Key? key, required this.campId}) : super(key: key);

  @override
  State<PlaceholderCamp> createState() => _PlaceholderCampState();
}

class _PlaceholderCampState extends State<PlaceholderCamp> {
  bool isLoading = true;
  bool isDeleting = false;
  Map<String, dynamic>? campData;
  List<String> kamarTypes = [];

  @override
  void initState() {
    super.initState();
    _loadCampData();
  }

  // Update the _loadCampData method
  Future<void> _loadCampData() async {
    try {
      setState(() => isLoading = true);
      final camp = await ItemCampController.getCampDetail(widget.campId);
      final types = await ItemKamarController.getKamarTypesByCamp(
        widget.campId,
      );

      setState(() {
        campData = camp;
        kamarTypes = types;
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

  Future<void> _deleteCamp() async {
    try {
      setState(() => isDeleting = true);
      final success = await ItemCampController.deleteCamp(widget.campId);

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Camp berhasil dihapus')),
          );
          Navigator.pop(context, true); // Return true to indicate deletion
        } else {
          throw Exception('Failed to delete camp');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => isDeleting = false);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error menghapus camp: $e')));
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
              : campData == null
              ? const Center(child: Text('Data tidak ditemukan'))
              : Stack(
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
                          child:
                              campData!['gambar_camp'] != null
                                  ? InteractiveViewer(
                                    minScale: 1.0,
                                    maxScale: 5.0,
                                    child: Image.network(
                                      '${ItemCampController.imageBaseUrl}/${campData!['gambar_camp']}',
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
                                    child: Text(
                                      campData!['alamat'] ?? 'No address',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
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
                              const Text(
                                'Tipe Kamar Tersedia',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),

                              // Kamar Types List
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
                                      leading: const Icon(
                                        Icons.bed_rounded,
                                        color: Colors.black,
                                      ),
                                      title: Text(
                                        kamarTypes[index],
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                      ),
                                      trailing: const Icon(
                                        Icons.arrow_forward_ios,
                                        color: Colors.black,
                                      ),
                                      onTap: () {
                                        Navigator.pushNamed(
                                          context,
                                          '/list_kamar',
                                          arguments: {
                                            'camp_id': widget.campId,
                                            'type': kamarTypes[index],
                                          },
                                        );
                                      },
                                    );
                                  },
                                ),

                              // Add bottom padding to prevent overlap with bottom button
                              const SizedBox(height: 100),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tombol back di atas gambar, menempel di pojok kiri atas
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
      // Delete button positioned at the bottom
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
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
                                'Menghapus camp juga akan menghapus seluruh data kamar yang tersedia\nApakah anda yakin ingin menghapusnya ?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed:
                                      () => Navigator.pop(context, false),
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
            child:
                isDeleting
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
