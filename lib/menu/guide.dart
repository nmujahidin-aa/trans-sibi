import 'package:flutter/material.dart';

class GuidePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
        height: screenHeight * 0.25,
        decoration: BoxDecoration(
          color: Color.fromRGBO(5, 10, 48, 1),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25.0),
            bottomRight: Radius.circular(25.0),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              spreadRadius: 0, 
              blurRadius: 4, 
              offset: Offset(0, 10),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/design1.png", width: 100),
              SizedBox(height: 10), // Spasi antara gambar dan teks
              Text(
                "Panduan Pengguna",
                style: TextStyle(
                  color: Color.fromRGBO(255, 204, 0, 1), // Warna teks
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
