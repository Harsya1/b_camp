import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:b_camp/screen/routes/app_drawer.dart';
import 'package:b_camp/service/database/controller/itemCampController.dart';
// import 'package:dropdown_search/dropdown_search.dart';

class CreateCamp extends StatefulWidget {
  const CreateCamp({Key? key}) : super(key: key);

  @override
  State<CreateCamp> createState() => _CreateCampState();
}

class _CreateCampState extends State<CreateCamp> {
  bool _isLoading = false;
  File? _image;
  final picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final _namaCampController = TextEditingController();
  final _deskripsiController = TextEditingController();
  final _alamatController = TextEditingController();
  final _jumlahMaksimalKamarController = TextEditingController();

  Future<void> _saveCamp() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() => _isLoading = true);

      final success = await ItemCampController.createCamp(
        namaCamp: _namaCampController.text,
        deskripsi: _deskripsiController.text,
        gambarCamp: _image, // Pass the File directly
        alamat: _alamatController.text,
        jumlahMaksimalKamar: int.parse(_jumlahMaksimalKamarController.text),
      );

      if (!mounted) return;
      
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Camp berhasil dibuat!')),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception('Failed to create camp');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

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
    _namaCampController.dispose();
    _deskripsiController.dispose();
    _alamatController.dispose();
    _jumlahMaksimalKamarController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final monochrome = Colors.white;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Data Camp'),
        backgroundColor: monochrome,
      ),
      drawer: const AppDrawer(),
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
              // Nama Kamar
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _namaCampController,
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
              // Jumlah Kasur
              SizedBox(
                width: double.infinity,
                child: TextFormField(
                  controller: _jumlahMaksimalKamarController,
                  decoration: _inputDecoration('Jumlah Kamar'),
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.black),
                ),
              ),
              const SizedBox(height: 50),
              // Tombol Tambah Data Kamar
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
                  onPressed: _isLoading ? null : _saveCamp,
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        )
                      : const Text(
                          'Tambah Data Camp',
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
