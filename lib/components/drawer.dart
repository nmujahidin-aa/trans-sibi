import 'package:flutter/material.dart';
import '../talk.dart';
import '../guide.dart';
import '../about.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: Color.fromRGBO(5,10,48,1),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 97.0, // Ubah ukuran tinggi sesuai keinginan Anda
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(5, 10, 48, 1), // Warna latar belakang DrawerHeader
                      ),
                      child: Text(
                        'TRANS-SIBI MENU',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 204, 0, 1), // Warna teks DrawerHeader
                          fontWeight: FontWeight.bold, // Tebal font teks DrawerHeader
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.campaign, color: Color.fromRGBO(255,255,255,1)),
                    title: const Text(
                      'Berbicara',
                      style: TextStyle(
                        color: Color.fromRGBO(255,255,255,1), // Warna teks
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.assistant, color: Color.fromRGBO(255,255,255,1)),
                    title: const Text(
                      'Panduan Pengguna',
                      style: TextStyle(
                        color: Color.fromRGBO(255,255,255,1), // Warna teks
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => GuidePage()),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info, color: Color.fromRGBO(255,255,255,1)),
                    title: const Text(
                      'Tentang Aplikasi',
                      style: TextStyle(
                        color: Color.fromRGBO(255,255,255,1), // Warna teks
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AboutPage()),
                      );
                    },
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 5),
                    Text(
                      '2024 - TRANS-SIBI',
                      style: TextStyle(
                        color: Color.fromRGBO(255, 255, 255, 1), // Warna teks
                        fontWeight: FontWeight.bold, // Tebal font
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )
    ); 
  }
}