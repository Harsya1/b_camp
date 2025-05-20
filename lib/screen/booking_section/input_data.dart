import 'package:flutter/material.dart';

void main() {
  runApp(CampVipApp());
}

class CampVipApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CampVipPage(),
    );
  }
}

class CampVipPage extends StatefulWidget {
  @override
  _CampVipPageState createState() => _CampVipPageState();
}

class _CampVipPageState extends State<CampVipPage> {
  String gender = 'Perempuan';
  String roomType = 'VIP';
  DateTime checkInDate = DateTime(2025, 5, 20);
  DateTime checkOutDate = DateTime(2025, 5, 20);

  final nameController = TextEditingController();
  final addressController = TextEditingController();

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? checkInDate : checkOutDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                'assets/camp_vip.jpg', // ganti dengan path gambar kamu
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Camp VIP",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TextButton(
              onPressed: () {},
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Lihat Detail"),
                  Icon(Icons.arrow_forward, size: 16),
                ],
              ),
            ),
            Text(
              "Mulyoasri, Tulungrejo, Kec. Pare, Kediri, Jawa Timur 64212",
              style: TextStyle(color: Colors.grey[700]),
            ),
            Divider(height: 30),
            Text(
              "Input Informasi Pendaftar",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: "Nama Lengkap",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: gender,
                    items: ['Perempuan', 'Laki-laki']
                        .map((label) => DropdownMenuItem(
                              child: Text(label),
                              value: label,
                            ))
                        .toList(),
                    decoration: InputDecoration(
                      labelText: "Jenis Kelamin",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() => gender = value!);
                    },
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: addressController,
                    maxLines: 2,
                    decoration: InputDecoration(
                      labelText: "Alamat",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: roomType,
                    items: ['VIP']
                        .map((label) => DropdownMenuItem(
                              child: Text(label),
                              value: label,
                            ))
                        .toList(),
                    decoration: InputDecoration(
                      labelText: "Pilih Tipe Kamar",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      setState(() => roomType = value!);
                    },
                  ),
                  SizedBox(height: 10),
                  ListTile(
                    title: Text("Tanggal Masuk: ${checkInDate.day}/${checkInDate.month}/${checkInDate.year}"),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context, true),
                  ),
                  ListTile(
                    title: Text("Tanggal Keluar: ${checkOutDate.day}/${checkOutDate.month}/${checkOutDate.year}"),
                    trailing: Icon(Icons.calendar_today),
                    onTap: () => _selectDate(context, false),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logika pemesanan kamar di sini
                  showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                      title: Text("Berhasil!"),
                      content: Text("Kamar berhasil dipesan."),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text("OK"),
                        )
                      ],
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: StadiumBorder(),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text("Pesan Kamar"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
