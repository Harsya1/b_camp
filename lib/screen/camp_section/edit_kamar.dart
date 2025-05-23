import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:b_camp/service/database/controller/itemKamarController.dart';

class EditKamar extends StatefulWidget {
  final Map<String, dynamic> kamarData;
  final int campId;

  const EditKamar({
    Key? key,
    required this.kamarData,
    required this.campId,
  }) : super(key: key);

  @override
  State<EditKamar> createState() => _EditKamarState();
}

class _EditKamarState extends State<EditKamar> {
  File? _image;
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaKamarController = TextEditingController();
  final TextEditingController _jumlahKasurController = TextEditingController();
  final TextEditingController _fasilitasController = TextEditingController();
  final TextEditingController _peraturanController = TextEditingController();
  final TextEditingController _hargaController = TextEditingController();

  String? _selectedKategori;
  String? _selectedTipeKamar;
  String? _selectedGender;

  bool _isLoading = false;

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: const Color(0xFFF0F0F0),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.grey),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(50),
        borderSide: const BorderSide(color: Colors.black, width: 2),
      ),
      hintStyle: TextStyle(color: Colors.grey[500]),
    );
  }

  @override
  void dispose() {
    _namaKamarController.dispose();
    _jumlahKasurController.dispose();
    _fasilitasController.dispose();
    _peraturanController.dispose();
    _hargaController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadKamarData();
  }

  void _loadKamarData() {
    _namaKamarController.text = widget.kamarData['nama_kamar'] ?? '';
    _selectedTipeKamar = widget.kamarData['type_kamar'];
    _selectedKategori = widget.kamarData['kategori'];
    _selectedGender = widget.kamarData['gender'];
    _jumlahKasurController.text = widget.kamarData['jumlah_kasur']?.toString() ?? '0';
    _fasilitasController.text = widget.kamarData['fasilitas'] ?? '';
    _peraturanController.text = widget.kamarData['peraturan'] ?? '';
    _hargaController.text = widget.kamarData['harga']?.toString() ?? '0';
  }

  Future<void> _updateKamar() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      await ItemKamarController.updateKamar(
        id: widget.kamarData['id'],
        namaKamar: _namaKamarController.text,
        typeKamar: _selectedTipeKamar,
        kategori: _selectedKategori,
        gender: _selectedGender,
        jumlahKasur: int.parse(_jumlahKasurController.text),
        fasilitas: _fasilitasController.text,
        peraturan: _peraturanController.text,
        gambar: _image, // Pass the File directly
        harga: double.parse(_hargaController.text),
      );

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kamar berhasil diupdate!')),
      );
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final monochrome = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Kamar'),
        backgroundColor: monochrome,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Pilih Gambar
              GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 180,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _image != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(
                            _image!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        )
                      : widget.kamarData['gambar'] != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                '${ItemKamarController.imageBaseUrl}/${widget.kamarData['gambar']}',
                                fit: BoxFit.cover,
                                width: double.infinity,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 180,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.broken_image),
                                  );
                                },
                              ),
                            )
                          : Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.image,
                                  size: 48,
                                  color: Colors.grey[600],
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Pilih Gambar',
                                  style: TextStyle(color: Colors.grey[700]),
                                ),
                              ],
                            ),
                ),
              ),
              const SizedBox(height: 20),
              // Nama Kamar
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _namaKamarController,
                  decoration: _inputDecoration('Nama Kamar'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Wajib diisi' : null,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 12),
              // Tipe Kamar (Dropdown)
              SizedBox(
                width: double.infinity,
                child: DropdownSearch<String>(
                  mode: Mode.form,
                  items:
                      (filter, cs) => [
                        "Regular",
                        "Regular+",
                        "Homestay",
                        "Homestay+",
                        "Barrack",
                        "VIP",
                        "VVIP",
                      ],
                  selectedItem: _selectedTipeKamar,
                  decoratorProps: DropDownDecoratorProps(
                    decoration: _inputDecoration('Tipe Kamar'),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedTipeKamar = value;
                    });
                  },
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
              ),
              const SizedBox(height: 12),
              // Kategori (Dropdown)
              SizedBox(
                width: double.infinity,
                child: DropdownSearch<String>(
                  items: (filter, cs) => ["Brilliant", "Bieplus"],
                  selectedItem: _selectedKategori,
                  decoratorProps: DropDownDecoratorProps(
                    decoration: _inputDecoration('Kategori'),
                  ),
                  popupProps: PopupProps.menu(
                    fit: FlexFit.loose,
                    showSearchBox: false,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedKategori = value;
                    });
                  },
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
              ),
              const SizedBox(height: 12),
              // Gender (Dropdown)
              SizedBox(
                width: double.infinity,
                child: DropdownSearch<String>(
                  items: (filter, cs) => ["Perempuan", "Laki-Laki"],
                  selectedItem: _selectedGender,
                  decoratorProps: DropDownDecoratorProps(
                    decoration: _inputDecoration('Gender'),
                  ),
                  popupProps: PopupProps.menu(
                    fit: FlexFit.loose,
                    showSearchBox: false,
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedGender = value;
                    });
                  },
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Wajib diisi' : null,
                ),
              ),
              const SizedBox(height: 12),
              // Jumlah Kasur
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _jumlahKasurController,
                  decoration: _inputDecoration('Jumlah Kasur'),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 12),
              // Fasilitas
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _fasilitasController,
                  decoration: _inputDecoration('Fasilitas'),
                  maxLines: 2,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 12),
              // Peraturan
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _peraturanController,
                  decoration: _inputDecoration('Peraturan'),
                  maxLines: 2,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 12),
              // Harga
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _hargaController,
                  decoration: _inputDecoration('Harga'),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 24),
              // Tombol Edit Data Kamar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  onPressed: _isLoading ? null : _updateKamar,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Edit Data Kamar',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
