import 'package:flutter/material.dart';
import 'package:b_camp/screen/search_section.dart';
import 'package:supercharged/supercharged.dart';


class dashboard_main extends StatefulWidget {
  const dashboard_main({super.key});

  @override
  State<dashboard_main> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<dashboard_main> {
  String selectedCategory = 'All';

  void setSelectedCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#f2f2f2'.toColor(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader([
              {'key': 'value'}, // Example data
            ]),
            SizedBox(height: 50),
            Padding(
              padding: EdgeInsets.only(left: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Tipe Camp Kami',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Roboto',
                        ),
                      ),
                      SizedBox(width: 10),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        child: Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              //border: Border.all(color: Colors.black),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildFilterButton('All'),
                                buildFilterButton('Male'),
                                buildFilterButton('Female'),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildFilterButton(String category) {
    bool isSelected = selectedCategory == category;

    return GestureDetector(
      onTap: () => setSelectedCategory(category),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(20),
          //border: Border.all(color: Colors.black),
        ),
        child: Text(
          category,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black,
            fontSize: 12,
            fontWeight: FontWeight.bold,
            fontFamily: 'Roboto',
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(List<Map<String, String>> dataList) {
    return Stack(
      children: [
        Container(
          color: '#f2f2f2'.toColor(),
          padding: const EdgeInsets.all(0),
          child: Stack(
            clipBehavior:
                Clip.none, // Pastikan widget di luar Stack tetap terlihat
            children: [
              Container(
                width: double.infinity,
                height: 220,
                padding: const EdgeInsets.all(0),
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  image: DecorationImage(
                    image: AssetImage(
                      'lib/assets/background/background_home_dashboard.jpg',
                    ),
                    fit: BoxFit.fill,
                    colorFilter: ColorFilter.mode(
                      Colors.black.withOpacity(0.5),
                      BlendMode.darken,
                    ),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 20, top: 36),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Hi Nameless!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Roboto',
                                    fontSize: 20,
                                  ),
                                ),
                                Text(
                                  'Welcome to B-Camp',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontFamily: 'Roboto',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                right: 20,
                top: 20,
                //notification button
                child: IconButton(
                  icon: Icon(Icons.notifications, color: Colors.white),
                  onPressed: () {
                    // Tambahkan logika untuk notifikasi di sini
                    print('Notifikasi button pressed');
                  },
                ),
              ),
              Positioned(
                bottom: -25,
                left: 25,
                right: 25,
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: InkWell(
                    onTap: () {
                      // Navigasi ke halaman search_section
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SearchSection(),
                        ),
                      );
                    },
                    child: SizedBox(
                      height: 50,
                      child: Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.search, color: Colors.black),
                            SizedBox(width: 8),
                            Text(
                              'Ayo cari camp yang kamu inginkan!',
                              style: TextStyle(fontSize: 16),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
