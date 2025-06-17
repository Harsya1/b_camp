import 'package:flutter/material.dart';
import 'package:b_camp/service/database/controller/itemBookingController.dart';
import 'package:b_camp/screen/camp_section/camp_detail.dart';
import 'package:intl/intl.dart';

class InputData extends StatefulWidget {
  final int kamarId;
  final Map<String, dynamic> kamarDetail;

  const InputData({Key? key, required this.kamarId, required this.kamarDetail})
    : super(key: key);

  @override
  State<InputData> createState() => _InputDataState();
}

class _InputDataState extends State<InputData> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  String gender = 'Perempuan';
  DateTime checkInDate = DateTime.now();
  DateTime checkOutDate = DateTime.now().add(const Duration(days: 1));
  final quantityController = TextEditingController(text: '1');
  bool isLoading = false;
  final _currencyFormatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp',
    decimalDigits: 0,
  );

  // Add method to calculate duration
  int _calculateDuration() {
    return checkOutDate.difference(checkInDate).inDays;
  }

  // Add duration widget
  Widget _buildDurationWidget() {
    final duration = _calculateDuration();
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.access_time,
            size: 20,
            color: Colors.grey[600],
          ),
          const SizedBox(width: 12),
          Text(
            'Durasi Menginap',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue[200]!),
            ),
            child: Text(
              '$duration hari',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.blue[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime now = DateTime.now();
    final DateTime firstDate = DateTime(now.year, now.month, now.day);
    final DateTime initial = isCheckIn ? checkInDate : checkOutDate;
    final DateTime safeInitialDate =
        initial.isBefore(firstDate) ? firstDate : initial;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: safeInitialDate,
      firstDate: firstDate,
      lastDate: DateTime(2026),
    );
    if (picked != null) {
      setState(() {
        if (isCheckIn) {
          checkInDate = picked;
          if (checkOutDate.isBefore(checkInDate)) {
            checkOutDate = checkInDate.add(const Duration(days: 1));
          }
        } else {
          checkOutDate = picked;
        }
      });
    }
  }

  Future<void> _submitBooking() async {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter a name')));
      return;
    }

    setState(() => isLoading = true);

    try {
      final success = await ItemBookingController.createBooking(
        kamarId: widget.kamarId,
        nama: nameController.text,
        gender: gender,
        startDate: checkInDate,
        endDate: checkOutDate,
        quantity: int.parse(quantityController.text),
      );

      if (mounted) {
        if (success) {
          showDialog(
            context: context,
            builder:
                (ctx) => AlertDialog(
                  title: const Text("Berhasil!"),
                  content: const Text("Kamar berhasil dipesan."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Failed to create booking')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Gambar kamar
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child:
                      widget.kamarDetail['gambar'] != null
                          ? InteractiveViewer(
                            minScale: 1.0,
                            maxScale: 5.0,
                            child: Image.network(
                              '${ItemBookingController.imageBaseUrl}/${widget.kamarDetail['gambar']}', // Removed 'storage/'
                              width: double.infinity,
                              height: 300,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                print('Error loading image: $error');
                                return Container(
                                  height: 120,
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image),
                                );
                              },
                            ),
                          )
                          : Container(
                            height: 120,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image),
                          ),
                ),

                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            widget.kamarDetail['nama_kamar'] ?? 'Nama Kamar',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => Scaffold(
                                        backgroundColor: Colors.white,
                                        body: Stack(
                                          children: [
                                            SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Kamar Image
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius.vertical(
                                                          bottom:
                                                              Radius.circular(
                                                                20,
                                                              ),
                                                        ),
                                                    child:
                                                        widget.kamarDetail['gambar'] !=
                                                                null
                                                            ? InteractiveViewer(
                                                              minScale: 1.0,
                                                              maxScale: 5.0,
                                                              child: Image.network(
                                                                '${ItemBookingController.imageBaseUrl}/${widget.kamarDetail['gambar']}',
                                                                width:
                                                                    double
                                                                        .infinity,
                                                                height: 300,
                                                                fit:
                                                                    BoxFit
                                                                        .cover,
                                                                errorBuilder: (
                                                                  context,
                                                                  error,
                                                                  stackTrace,
                                                                ) {
                                                                  return Container(
                                                                    height: 200,
                                                                    color:
                                                                        Colors
                                                                            .grey[300],
                                                                    child: const Icon(
                                                                      Icons
                                                                          .broken_image,
                                                                      size: 50,
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            )
                                                            : Container(
                                                              height: 200,
                                                              color:
                                                                  Colors
                                                                      .grey[300],
                                                              child: const Icon(
                                                                Icons.image,
                                                                size: 50,
                                                              ),
                                                            ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          20,
                                                        ),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                widget.kamarDetail['nama_kamar'] ??
                                                                    'Unnamed',
                                                                style: const TextStyle(
                                                                  fontSize: 24,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            Text(
                                                              _currencyFormatter.format(
                                                                double.tryParse(
                                                                      widget.kamarDetail['harga'] ??
                                                                          '0',
                                                                    ) ??
                                                                    0,
                                                              ),
                                                              style: const TextStyle(
                                                                fontSize: 20,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color:
                                                                    Colors
                                                                        .green,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        const SizedBox(
                                                          height: 16,
                                                        ),
                                                        _buildInfoSection(
                                                          'Tipe Kamar',
                                                          widget
                                                              .kamarDetail['type_kamar'],
                                                        ),
                                                        _buildInfoSection(
                                                          'Kategori',
                                                          widget
                                                              .kamarDetail['kategori'],
                                                        ),
                                                        _buildInfoSection(
                                                          'Gender',
                                                          widget
                                                              .kamarDetail['gender'],
                                                        ),
                                                        _buildInfoSection(
                                                          'Jumlah Kasur',
                                                          widget
                                                              .kamarDetail['jumlah_kasur']
                                                              ?.toString(),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        const Text(
                                                          'Fasilitas',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          widget.kamarDetail['fasilitas'] ??
                                                              'Tidak ada fasilitas',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors
                                                                    .grey[600],
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 20,
                                                        ),
                                                        const Text(
                                                          'Peraturan',
                                                          style: TextStyle(
                                                            fontSize: 18,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 8,
                                                        ),
                                                        Text(
                                                          widget.kamarDetail['peraturan'] ??
                                                              'Tidak ada peraturan',
                                                          style: TextStyle(
                                                            fontSize: 16,
                                                            color:
                                                                Colors
                                                                    .grey[600],
                                                          ),
                                                        ),
                                                        if (widget
                                                                .kamarDetail['catatan_tambahan'] !=
                                                            null) ...[
                                                          const SizedBox(
                                                            height: 20,
                                                          ),
                                                          const Text(
                                                            'Catatan Tambahan',
                                                            style: TextStyle(
                                                              fontSize: 18,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            height: 8,
                                                          ),
                                                          Text(
                                                            widget
                                                                .kamarDetail['catatan_tambahan'],
                                                            style: TextStyle(
                                                              fontSize: 16,
                                                              color:
                                                                  Colors
                                                                      .grey[600],
                                                            ),
                                                          ),
                                                        ],
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            // Back Button
                                            Positioned(
                                              top: 40,
                                              left: 10,
                                              child: Material(
                                                color: Colors.black,
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                child: IconButton(
                                                  icon: const Icon(
                                                    Icons.arrow_back,
                                                    color: Colors.white,
                                                  ),
                                                  onPressed:
                                                      () => Navigator.pop(
                                                        context,
                                                      ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: const [
                                  Text(
                                    "Lihat Detail",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  SizedBox(width: 4),
                                  Icon(Icons.arrow_forward, size: 16),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.kamarDetail['type_kamar'] ?? 'Tipe Kamar',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.kamarDetail['kategori'] ?? 'Kategori Kamar',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Divider(height: 30),
                      const Text(
                        "Input Informasi Pendaftar",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          children: [
                            TextField(
                              controller: nameController,
                              decoration: const InputDecoration(
                                labelText: "Nama Lengkap",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            DropdownButtonFormField<String>(
                              value: gender,
                              items:
                                  ['Perempuan', 'Laki-laki']
                                      .map(
                                        (label) => DropdownMenuItem(
                                          value: label,
                                          child: Text(label),
                                        ),
                                      )
                                      .toList(),
                              decoration: const InputDecoration(
                                labelText: "Jenis Kelamin",
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                setState(() => gender = value!);
                              },
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: quantityController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: "Jumlah",
                                border: OutlineInputBorder(),
                              ),
                            ),
                            const SizedBox(height: 10),
                            ListTile(
                              title: Text(
                                "Tanggal Masuk: ${checkInDate.day}/${checkInDate.month}/${checkInDate.year}",
                              ),
                              trailing: const Icon(Icons.calendar_today),
                              onTap: () => _selectDate(context, true),
                            ),
                            ListTile(
                              title: Text(
                                "Tanggal Keluar: ${checkOutDate.day}/${checkOutDate.month}/${checkOutDate.year}",
                              ),
                              trailing: const Icon(Icons.calendar_today),
                              onTap: () => _selectDate(context, false),
                            ),
                            
                            // Add duration widget here
                            _buildDurationWidget(),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: ElevatedButton(
                          onPressed: isLoading ? null : _submitBooking,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: const StadiumBorder(),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 50,
                              vertical: 15,
                            ),
                          ),
                          child:
                              isLoading
                                  ? const CircularProgressIndicator(
                                    color: Colors.white,
                                  )
                                  : const Text(
                                    "Input Data",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    quantityController.dispose();
    super.dispose();
  }

  Widget _buildInfoSection(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            value ?? '-',
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }
}
