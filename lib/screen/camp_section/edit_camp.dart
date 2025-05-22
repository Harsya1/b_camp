import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditCamp extends StatefulWidget {
  const EditCamp({super.key});

  @override
  State<EditCamp> createState() => _EditCampState();
}

class _EditCampState extends State<EditCamp> {
  File? _image;
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _namaKamarController = TextEditingController();
  final TextEditingController _deskripsiController = TextEditingController();
  final TextEditingController _alamatController = TextEditingController();
  final TextEditingController _jumlahkamarController = TextEditingController();

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
    _deskripsiController.dispose();
    _alamatController.dispose();
    _jumlahkamarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final monochrome = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data Camp'),
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
                  child:
                      _image != null
                          ? ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              _image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
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
              // Nama Camp
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _namaKamarController,
                  decoration: _inputDecoration('Nama Camp'),
                  validator:
                      (value) =>
                          value == null || value.isEmpty ? 'Wajib diisi' : null,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 12),
              // Deskripsi
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _deskripsiController,
                  decoration: _inputDecoration('Deskripsi'),
                  maxLines: 2,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 12),
              // Alamat
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _alamatController,
                  decoration: _inputDecoration('Alamat'),
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 12),
              // Jumlah Kamar
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _jumlahkamarController,
                  decoration: _inputDecoration('Jumlah Kamar'),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 50),
              // Tombol Edit Data Camp
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
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Proses edit data camp di sini
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Data camp berhasil diubah!'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Edit Data Camp',
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
