import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';
import 'package:b_camp/screen/camp_section/camp_detail.dart';
import 'package:b_camp/service/database/controller/itemCampController.dart';
import 'package:b_camp/service/database/model/Kamar.dart';
import 'package:b_camp/screen/routes/app_drawer.dart';
import 'package:b_camp/service/database/controller/itemBookingController.dart';
import 'package:b_camp/service/database/controller/itemKamarController.dart';

class CrudBooking extends StatefulWidget {
  const CrudBooking({super.key});

  @override
  State<CrudBooking> createState() => _CrudBooking();
}

class _CrudBooking extends State<CrudBooking> {
  List<Map<String, dynamic>> camps = [];
  List<Map<String, dynamic>> filteredCamps = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();
  
  // Add total booking count and total kamar count
  int totalBookingCount = 0;
  int totalKamarCount = 0;
  bool isLoadingTotal = true;

  @override
  void initState() {
    super.initState();
    searchController.addListener(_filterCamps);
    _loadCamps();
    _loadTotalCounts(); // Load both booking and kamar counts
  }

  @override
  void dispose() {
    searchController.dispose(); // Clean up controller
    super.dispose();
  }

  Future<void> _loadCamps() async {
    try {
      setState(() => isLoading = true);
      final campData = await ItemBookingController.getAllCamps();
      if (mounted) {
        setState(() {
          camps = campData;
          filteredCamps = campData; // Initially show all camps
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

  // Filter camps based on search query
  void _filterCamps() {
    final query = searchController.text.toLowerCase();
    setState(() {
      filteredCamps =
          camps.where((camp) {
            final name = camp['nama_camp']?.toLowerCase() ?? '';
            return name.contains(query);
          }).toList();
    });
  }

  // Optimized method to load both booking and kamar counts
  Future<void> _loadTotalCounts() async {
    try {
      setState(() => isLoadingTotal = true);

      print('=== Loading Total Booking and Kamar Counts (Optimized) ===');
      
      // Run both queries in parallel using Future.wait
      final results = await Future.wait([
        ItemBookingController.getAllBookingsWithDetails(),
        ItemCampController.getCamps(),
      ]);
      
      final bookings = results[0] as List<Map<String, dynamic>>;
      final camps = results[1] as List<Map<String, dynamic>>;
      
      print('Total bookings fetched: ${bookings.length}');
      print('Total camps fetched: ${camps.length}');
      
      // Process camps in parallel to get kamar counts
      final kamarCountFutures = camps.map((camp) async {
        try {
          final kamarTypes = await ItemCampController.getKamarTypesByCamp(camp['id']);
          
          // Get kamar counts for all types in parallel
          final kamarCounts = await Future.wait(
            kamarTypes.map((type) => 
              ItemKamarController.getKamarByType(camp['id'], type)
                .then((kamars) => kamars.length)
                .catchError((e) {
                  print('Error getting kamars for camp ${camp['id']} type $type: $e');
                  return 0;
                })
            )
          );
          
          return kamarCounts.fold<int>(0, (sum, count) => sum + count);
        } catch (e) {
          print('Error getting kamars for camp ${camp['id']}: $e');
          return 0;
        }
      });
      
      final kamarCountsPerCamp = await Future.wait(kamarCountFutures);
      final totalKamars = kamarCountsPerCamp.fold<int>(0, (sum, count) => sum + count);
      
      print('Total kamars calculated: $totalKamars');

      if (mounted) {
        setState(() {
          totalBookingCount = bookings.length;
          totalKamarCount = totalKamars;
          isLoadingTotal = false;
        });
        
        print('Total booking count set to: $totalBookingCount');
        print('Total kamar count set to: $totalKamarCount');
      }
    } catch (e) {
      print('Error loading total counts: $e');
      if (mounted) {
        setState(() {
          isLoadingTotal = false;
          totalBookingCount = 0;
          totalKamarCount = 0;
        });
      }
    }
  }

  // Updated total booking widget with kamar count
  Widget _buildTotalBooking() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Text(
                'Total Booking Keseluruhan',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              isLoadingTotal
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: totalBookingCount.toString(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const TextSpan(
                            text: ' booking dari ',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.blue,
                            ),
                          ),
                          TextSpan(
                            text: totalKamarCount.toString(),
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          const TextSpan(
                            text: ' kamar',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.normal,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#f2f2f2'.toColor(),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildTotalBooking(), // Updated widget with kamar count
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [_itemCamp()],
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 150,
      color: '#f2f2f2'.toColor(),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            left: 10,
            top: 20,
            child: Builder(
              builder:
                  (context) => IconButton(
                    icon: const Icon(Icons.menu, color: Colors.black),
                    onPressed: () {
                      Scaffold.of(context).openDrawer();
                    },
                  ),
            ),
          ),
          Positioned(
            top: 24,
            left: 0,
            right: 0,
            child: Center(
              child: Text(
                "Booking Camp",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            left: 25,
            right: 25,
            child: TextField(
              controller: searchController, // Attach controller
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.white,
                hintText: 'Cari Camp!',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: const BorderSide(color: Colors.grey),
                ),
                hintStyle: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemCamp() {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            mainAxisExtent: 250,
          ),
          itemCount: filteredCamps.length, // Use filteredCamps
          itemBuilder: (context, index) {
            final camp = filteredCamps[index]; // Use filteredCamps
            return GestureDetector(
              onTap: () {
                Navigator.pushNamed(
                  context,
                  '/booking_section',
                  arguments: {'camp_id': camp['id'], 'camp_data': camp},
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child:
                          camp['gambar_camp'] != null
                              ? Image.network(
                                '${ItemBookingController.imageBaseUrl}/${camp['gambar_camp']}',
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 150,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: const Icon(
                                      Icons.broken_image,
                                      size: 48,
                                    ),
                                  );
                                },
                              )
                              : Container(
                                height: 150,
                                width: double.infinity,
                                color: Colors.grey[300],
                                child: const Icon(Icons.image, size: 48),
                              ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10),
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
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            );
            },
          );
  }
}
