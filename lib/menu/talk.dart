import 'package:flutter/material.dart';

class TalkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: 45.0,
        decoration: BoxDecoration(
          color: Color.fromRGBO(255, 0, 0, 0.3),
        ),
        child: Center(
          child: Text(
            'Bluetooth tidak terhubung',
            style: TextStyle(
              color: Colors.red, 
              fontWeight: FontWeight.bold,
            ),
          ), // Text diletakkan di tengah container
        ),
      ),
    );
  }
}
