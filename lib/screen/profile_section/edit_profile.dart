import 'package:flutter/material.dart';

class EditProfile extends StatefulWidget {
  @override
  EditProfilePageState createState() => EditProfilePageState();
}

class EditProfilePageState extends State<EditProfile> {
  String? _selectedGender;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 242, 242, 242),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2F2F2),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        centerTitle: false,
      ),
      body: Center( 
  child: SingleChildScrollView(
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Column(
        children: [
          const SizedBox(height: 16),
          Stack(
            alignment: Alignment.bottomRight,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: AssetImage('lib/assets/background/avatar.jpg'),
              ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 20),
                  )
                ],
              ),
              const SizedBox(height: 30),
              _buildFixedSizeTextField(icon: Icons.person, label: 'Nama Lengkap'),
              const SizedBox(height: 16),
              _buildFixedSizeTextField(icon: Icons.alternate_email, label: 'Username'),
              const SizedBox(height: 16),
              _buildFixedSizeTextField(icon: Icons.email, label: 'Email'),
              const SizedBox(height: 16),
              _buildFixedSizeTextField(icon: Icons.phone, label: 'Nomor Telepon'),
              const SizedBox(height: 16),
              _buildFixedSizeDropdownField(icon: Icons.person_outline, label: 'Jenis Kelamin'),
              const SizedBox(height: 16),
              _buildFixedSizeTextField(icon: Icons.location_on, label: 'Alamat'),
              const SizedBox(height: 30),
              SizedBox(
                width: 180,
                height: 40,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Simpan Perubahan',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildFixedSizeTextField({required IconData icon, required String label}) {
    return SizedBox(
      width: 290,
      height: 40,
      child: TextField(
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
        ),
      ),
    );
  }

  Widget _buildFixedSizeDropdownField({required IconData icon, required String label}) {
    return SizedBox(
      width: 290,
      height: 40,
      child: DropdownButtonFormField<String>(
        value: _selectedGender,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.black),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.black, width: 1),
          ),
        ),
        items: const [
          DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
          DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
        ],
        onChanged: (value) {
          setState(() {
            _selectedGender = value;
          });
        },
      ),
    );
  }
}
