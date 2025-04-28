import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  final VoidCallback onLogin; // Tambahkan ini

  const LoginPage({Key? key, required this.onLogin}) : super(key: key); // Constructor

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
                Image.asset(
                  'lib/assets/background/login_logo.png',
                  height: 360,
                  width: 360,
                ),
                SizedBox(height: 0),
                Container(
                  width: 290, 
                  alignment: Alignment.centerLeft,
                  child: Text(
                  'Selamat Datang Kembali',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                ),
                SizedBox(height: 5),
                Container(
                  width: 290, 
                  alignment: Alignment.centerLeft,
                  child: Text(
                  'Silahkan login untuk pengalaman yang lebih baik',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black,
                  ),
                ),
                ),
                SizedBox(height: 50),
                SizedBox(
                  width: 290, 
                  height: 40,
                  child: TextField(
                  decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                  ),
                 ),
                ),
              ),
                SizedBox(height: 30),
                SizedBox(
                  width: 290, // Atur panjang TextField
                  height: 40,
                  child: TextField(
                  decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: Colors.black, width: 1),
                ),
            ),
                  ),
               ),
                SizedBox(height: 50),
                SizedBox(
                  width: 290, // Atur panjang TextField
                  height: 40,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                    ),
                    onPressed: () {
                      // Saat tombol login ditekan
                      print("Login ditekan");
                      onLogin(); // Panggil callback ke main
                    },
                    child: Text(
                      'Log In',
                     style: TextStyle(
                        fontSize: 16,
                        color: Colors.white
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
