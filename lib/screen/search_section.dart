import 'package:b_camp/main.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class SearchSection extends StatefulWidget {
  const SearchSection({super.key});

  @override
  State<SearchSection> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<SearchSection> {
  // Variabel untuk menyimpan filter yang dipilih
  String selectedCategory = 'VIP'; // Default kategori
  String selectedType = 'All'; // Default tipe camp

  bool showFilters =
      false; // Untuk menampilkan atau menyembunyikan semua filter

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#f2f2f2'.toColor(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tombol kembali
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 50),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Latar belakang putih
                  shape: BoxShape.circle, // Membuat bentuk bulat
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Bayangan lembut
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),

                child: IconButton(
                  icon: const Icon(
                    Icons.chevron_left,
                    color: Colors.black,
                  ), // Ikon warna hitam
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => const MyApp()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Input pencarian
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Ayo cari camp yang kamu mau',
                  hintStyle: const TextStyle(
                    color: Colors.black, // Warna teks hint
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Dropdown untuk menampilkan semua filter
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    showFilters = !showFilters; // Toggle visibilitas filter
                  });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Filter',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(
                      showFilters
                          ? Icons.keyboard_arrow_up
                          : Icons.keyboard_arrow_down,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
            if (showFilters)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Tipe Camp',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildFilterButton('VIP', selectedCategory, (
                              value,
                            ) {
                              setState(() {
                                selectedCategory = value;
                              });
                            }),
                            const SizedBox(width: 10),
                            _buildFilterButton('Reguler', selectedCategory, (
                              value,
                            ) {
                              setState(() {
                                selectedCategory = value;
                              });
                            }),
                            const SizedBox(width: 10),
                            _buildFilterButton('Homestay', selectedCategory, (
                              value,
                            ) {
                              setState(() {
                                selectedCategory = value;
                              });
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Filter Tipe Camp
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Kategori',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _buildFilterButton('All', selectedType, (value) {
                              setState(() {
                                selectedType = value;
                              });
                            }),
                            const SizedBox(width: 10),
                            _buildFilterButton('Male', selectedType, (value) {
                              setState(() {
                                selectedType = value;
                              });
                            }),
                            const SizedBox(width: 10),
                            _buildFilterButton('Female', selectedType, (value) {
                              setState(() {
                                selectedType = value;
                              });
                            }),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Filter Kategori
                ],
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget untuk membuat tombol filter
  Widget _buildFilterButton(
    String label,
    String selectedValue,
    Function(String) onTap,
  ) {
    final bool isSelected = label == selectedValue;
    return GestureDetector(
      onTap: () => onTap(label),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.white, // Warna tombol
          borderRadius: BorderRadius.circular(50),
          border: Border.all(
            color: isSelected ? Colors.black : Colors.grey, // Warna border
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 10, // Ukuran teks lebih kecil
            color: isSelected ? Colors.white : Colors.black, // Warna teks
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
