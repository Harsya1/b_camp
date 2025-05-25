import 'package:flutter/material.dart';
import 'package:b_camp/service/database/controller/itemBookingController.dart';
import 'package:b_camp/screen/booking_section/input_data.dart';

class PlaceholderBooking extends StatefulWidget {
  final int campId;
  final Map<String, dynamic> campData;

  const PlaceholderBooking({
    Key? key,
    required this.campId,
    required this.campData,
  }) : super(key: key);

  @override
  State<PlaceholderBooking> createState() => _PlaceholderBookingState();
}

class _PlaceholderBookingState extends State<PlaceholderBooking> {
  Map<String, dynamic>? campDetail;
  List<String> kamarTypes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      setState(() => isLoading = true);
      final detail = await ItemBookingController.getCampDetail(widget.campId);
      final types = await ItemBookingController.getKamarTypesByCamp(widget.campId);
      
      if (mounted) {
        setState(() {
          campDetail = detail;
          kamarTypes = types;
          isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  Widget _buildKamarTypeList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: kamarTypes.length,
      itemBuilder: (context, index) {
        final kamarType = kamarTypes[index];
        return Card(
          child: ListTile(
            leading: const Icon(Icons.bed),
            title: Text(kamarType),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () async {
              try {
                // Get kamar list for this type
                final kamarList = await ItemBookingController.getKamarByType(
                  widget.campId,
                  kamarType,
                );

                if (kamarList.isEmpty) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No rooms available for type: $kamarType')),
                    );
                  }
                  return;
                }

                // Use the first kamar from the list
                final kamar = kamarList.first;
                
                if (mounted) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => InputData(
                        kamarId: kamar['id'],
                        kamarDetail: kamar,
                      ),
                    ),
                  );
                }
              } catch (e) {
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e')),
                  );
                }
              }
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Camp Image
                  Stack(
                    children: [
                      Image.network(
                        '${ItemBookingController.imageBaseUrl}/${widget.campData['gambar_camp']}',
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.black54,
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Camp Details
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.campData['nama_camp'] ?? '',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          widget.campData['alamat'] ?? '',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Available Room Types',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildKamarTypeList(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
