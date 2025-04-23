import 'package:b_camp/main.dart';
import 'package:flutter/material.dart';
import 'package:supercharged/supercharged.dart';

class search_Section extends StatefulWidget {
  const search_Section({super.key});

  @override
  State<search_Section> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<search_Section> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: '#f2f2f2'.toColor(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20, top: 30),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Latar belakang putih
                  shape: BoxShape.circle, // Membuat bentuk bulat
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1), // Bayangan lembut
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: Colors.black,
                  ), // Ikon warna hitam
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => MyApp()),
                      (Route<dynamic> route) => false,
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Ayo cari camp yang kamu mau',
                  hintStyle: TextStyle(
                    color: Colors.black, // Warna teks hint
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide.none,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
