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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                                  ? Image.network(
                                    '${ItemCampController.imageBaseUrl}/${campData!['gambar_camp']}',
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
    );
  }
}
