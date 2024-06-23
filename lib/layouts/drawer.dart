import 'package:flutter/material.dart';
import '../menu/talk.dart';
import '../menu/guide.dart';
import '../menu/about.dart';
import '../main.dart';

class CustomDrawer extends StatelessWidget {
  final Function(Widget) onSelectPage;
  CustomDrawer({required this.onSelectPage});
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
                    height: 97.0,
                    child: DrawerHeader(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(5, 10, 48, 1),
                      ),
                      child: Text(
                        'TRANS-SIBI MENU',
                        style: TextStyle(
                          color: Color.fromRGBO(255, 204, 0, 1), 
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.campaign, color: Color.fromRGBO(255,255,255,1)),
                    title: const Text(
                      'Berbicara',
                      style: TextStyle(
                        color: Color.fromRGBO(255,255,255,1), 
                      ),
                    ),
                    onTap: () {
                      onSelectPage(TalkPage());
                      Navigator.of(context).pop(); 
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.assistant, color: Color.fromRGBO(255,255,255,1)),
                    title: const Text(
                      'Panduan Pengguna',
                      style: TextStyle(
                        color: Color.fromRGBO(255,255,255,1),
                      ),
                    ),
                    onTap: () {
                      onSelectPage(GuidePage());
                      Navigator.of(context).pop(); 
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.info, color: Color.fromRGBO(255,255,255,1)),
                    title: const Text(
                      'Tentang Aplikasi',
                      style: TextStyle(
                        color: Color.fromRGBO(255,255,255,1),
                      ),
                    ),
                    onTap: () {
                      onSelectPage(AboutPage());
                      Navigator.of(context).pop();
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
                    Row(
                      children: [
                        Icon(
                          Icons.copyright,
                          color: Color.fromRGBO(255, 255, 255, 1),
                          size: 18,
                        ),
                        SizedBox(width: 5), // Jarak antara ikon dan teks
                        Text(
                          '2024 - TRANS-SIBI',
                          style: TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 1), 
                            // fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
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