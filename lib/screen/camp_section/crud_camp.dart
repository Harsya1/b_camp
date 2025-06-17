import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:b_camp/screen/routes/app_drawer.dart';
import 'package:b_camp/service/database/controller/itemCampController.dart';
import 'package:b_camp/service/database/controller/itemKamarController.dart';

class CrudCamp extends StatefulWidget {
  const CrudCamp({Key? key}) : super(key: key);

  @override
  State<CrudCamp> createState() => _CrudCampState();
}

class _CrudCampState extends State<CrudCamp> {
  List<Map<String, dynamic>> camps = [];
  List<Map<String, dynamic>> filteredCamps = [];
  bool isLoading = true;
  String selectedFilter = 'Semua';

  // Deklarasi filters cukup sekali saja di sini
  final List<String> filters = [
    'Semua',
    'Regular',
    'Regular+',
    'Homestay',
    'Homestay+',
    'VIP',
  ];

  Map<int, List<String>> campKamarTypes = {}; // Tambahkan ini untuk menyimpan tipe kamar

  @override
  void initState() {
    super.initState();
    _loadCamps();
  }

  Future<void> _loadCamps() async {
    try {
      setState(() => isLoading = true);
      // Ambil semua camp terlebih dahulu
      final campData = await ItemCampController.getCamps();
      
      // Ambil tipe kamar untuk setiap camp
      for (var camp in campData) {
        final types = await ItemKamarController.getKamarTypesByCamp(camp['id']);
        campKamarTypes[camp['id']] = types;
      }

      setState(() {
        camps = campData;
        _applyFilter(selectedFilter); // Terapkan filter setelah data lengkap
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

  // Update fungsi _applyFilter
  void _applyFilter(String tipe) {
    setState(() {
      selectedFilter = tipe;
      if (tipe.toLowerCase() == 'semua') {
        filteredCamps = List.from(camps);
      } else {
        // Filter camps berdasarkan tipe kamar
        filteredCamps = camps.where((camp) {
          List<String> types = campKamarTypes[camp['id']] ?? [];
          return types.any((t) => t.toLowerCase() == tipe.toLowerCase());
        }).toList();
      }
    });
  }

  // Update fungsi _showFilterDialog
  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Filter Tipe Kamar'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children:
                  filters.map((filter) {
                    return RadioListTile<String>(
                      title: Text(filter),
                      value: filter,
                      groupValue: selectedFilter,
                      onChanged: (value) {
                        Navigator.pop(context);
                        if (value != null) {
                          _applyFilter(value);
                        }
                      },
                    );
                  }).toList(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#f2f2f2'.toColor(),
      drawer: const AppDrawer(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () {
          Navigator.pushNamed(
            context,
            '/create_camp',
          ).then((value) => _loadCamps());
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    Center(
                      child: Text(
                        'Daftar Camp untuk Dikelola',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (isLoading)
                      const Center(child: CircularProgressIndicator())
                    else if (filteredCamps.isEmpty)
                      const Center(
                        child: Image(
                          height: 160,
                          width: 160,
                          image: AssetImage(
                            'lib/assets/picture/data_not_load.png',
                          ),
                        ),
                      )
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              mainAxisExtent: 250,
                            ),
                        itemCount: filteredCamps.length,
                        itemBuilder:
                            (context, index) =>
                                _buildCampCard(filteredCamps[index]),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Update _buildCampCard untuk menampilkan tipe kamar
  Widget _buildCampCard(Map<String, dynamic> camp) {
    List<String> types = campKamarTypes[camp['id']] ?? [];
    
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/placeholder_camp',
          arguments: {'id': camp['id']},
        ).then((value) => _loadCamps());
      },
      child: Card(
        color: Colors.white,
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10),
              ),
              child:
                  camp['gambar_camp'] != null
                      ? Image.network(
                        '${ItemCampController.imageBaseUrl}/${camp['gambar_camp']}',
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
                    camp['nama_camp'] ?? 'Unnamed Camp',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    camp['alamat'] ?? 'No address',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Max Kamar: ${camp['jumlah_maksimal_kamar']?.toString() ?? '0'}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[800]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          ),
          const Text(
            'Kelola Camp',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: _showFilterDialog,
          ),
        ],
      ),
    );
  }
}
