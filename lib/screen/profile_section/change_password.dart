import 'package:flutter/material.dart';

class ChangePassword extends StatelessWidget {
  final VoidCallback onPasswordChanged; 

  const ChangePassword({super.key, required this.onPasswordChanged});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(242, 242, 242, 242),
      body: Padding(
        padding: const EdgeInsets.all(0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(  
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                
                Container(
                  margin:  EdgeInsets.only(top: 0, bottom: 0),
                  child: Image.asset(
                  'lib/assets/background/change_pass_icon.png',
                  height: 250,
                  width: 360,
                )
                ),
                SizedBox(height: 0),
                Container(
                  width: 290,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Ganti Password',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 290,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Masukkan password lama dan password baru Anda.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.black,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // Textfield password laama
                SizedBox(
                  width: 290,
                  height: 40,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password Lama',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // TextField password bru
                SizedBox(
                  width: 290,
                  height: 40,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password Baru',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                // TextField konfirm pw
                SizedBox(
                  width: 290,
                  height: 40,
                  child: TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Konfirmasi Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide(color: Colors.black, width: 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50),
                // Tombol ganti pw
                SizedBox(
                  width: 190,
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      // Saat tombol ganti password ditekan
                      print("Ganti Password ditekan");
                      onPasswordChanged(); // Panggil callback
                    },
                    child: Text(
                      'Ubah Password',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}