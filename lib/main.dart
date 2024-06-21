import 'package:flutter/material.dart';
import 'components/drawer.dart';
import 'talk.dart';
import 'guide.dart';
import 'about.dart';


void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          iconTheme: IconThemeData(
            color: Color.fromRGBO(255, 204, 0, 1), // Mengatur warna ikon hamburger menjadi kuning
          ),
          title: Text(
            'TRANS-SIBI',
              style: TextStyle(
                fontSize: 20, // Ukuran font
                fontWeight: FontWeight.bold, // Tebal font
                color: Color.fromRGBO(255, 204, 0, 1),
              ),
            ),
          backgroundColor: Color.fromRGBO(5, 10, 48, 1),
          actions: [
          IconButton(
            icon: Stack(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.white,
                  radius: 18,
                  child: Icon(
                    Icons.bluetooth,
                    color: Color.fromRGBO(5, 10, 48, 1),
                  ),
                ),
                Positioned(
                  right: 0,
                  bottom: 0,
                  child: CircleAvatar(
                    backgroundColor: Colors.red,
                    radius: 5,
                  ),
                ),
              ],
            ),
            onPressed: () {
              // Tindakan ketika tombol Bluetooth ditekan
              print("Bluetooth button pressed");
            },
          ),
        ],
        ),
        drawer: CustomDrawer(),
      ),
    );
  }
}