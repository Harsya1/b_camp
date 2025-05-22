import 'package:flutter/material.dart';

class DetailKamar extends StatelessWidget {
  const DetailKamar({super.key});

  @override
  Widget build(BuildContext context) {
    // Data dummy, bisa diganti dengan data dinamis jika diperlukan
    final String namaKamar = "Kamar VIP 1";
    final String tipeKamar = "VIP";
    final String kategori = "Brilliant";
    final String gender = "Laki-Laki";
    final String jumlahKasur = "2";
    final String fasilitas = "AC, Lemari, Meja, Kamar Mandi Dalam";
    final String peraturan = "Tidak boleh merokok, Tidak boleh membawa hewan";
    final String harga = "350000";
    final String deskripsi =
        "Kamar luas dengan fasilitas lengkap dan nyaman untuk istirahat.";

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar header
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    'lib/assets/background/background_home_dashboard.jpg',
                    width: double.infinity,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Nama kamar di kiri, Edit data di kanan
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            namaKamar,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Aksi edit data
                              Navigator.pushNamed(context, '/edit_kamar');
                            },
                            child: Row(
                              children: const [
                                Icon(Icons.edit, color: Colors.black, size: 20),
                                SizedBox(width: 4),
                                Text(
                                  "Edit data",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        deskripsi,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailRow("Tipe Kamar", tipeKamar),
                      _buildDetailRow("Kategori", kategori),
                      _buildDetailRow("Gender", gender),
                      _buildDetailRow("Jumlah Kasur", jumlahKasur),
                      _buildDetailRow("Fasilitas", fasilitas),
                      _buildDetailRow("Peraturan", peraturan),
                      _buildDetailRow("Harga", "Rp $harga / bulan"),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Tombol back di atas gambar, menempel di pojok kiri atas
          Positioned(
            top: 32,
            left: 16,
            child: Material(
              color: Colors.transparent,
              child: Ink(
                decoration: const ShapeDecoration(
                  color: Colors.black,
                  shape: CircleBorder(),
                ),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "$label: ",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
