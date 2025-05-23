import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:b_camp/screen/routes/app_drawer.dart';
import 'package:b_camp/service/database/controller/itemCampController.dart';

class CrudCamp extends StatefulWidget {
  const CrudCamp({Key? key}) : super(key: key);

  @override
  State<CrudCamp> createState() => _CrudCampState();
}

class _CrudCampState extends State<CrudCamp> {
  List<Map<String, dynamic>> camps = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCamps();
  }

  Future<void> _loadCamps() async {
    try {
      setState(() => isLoading = true);
      final campData = await ItemCampController.getCamps();
      setState(() {
        camps = campData;
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
                    else if (camps.isEmpty)
                      const Center(child: Text('Tidak ada data camp'))
                    else
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              childAspectRatio: 0.75,
                            ),
                        itemCount: camps.length,
                        itemBuilder:
                            (context, index) => _buildCampCard(camps[index]),
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

  Widget _buildCampCard(Map<String, dynamic> camp) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          '/placeholder_camp',
          arguments: {'id': camp['id']},
        ).then((value) => _loadCamps());
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
                  const SizedBox(height: 8),
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
        children: [
          Builder(
            builder:
                (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Kelola Camp',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
