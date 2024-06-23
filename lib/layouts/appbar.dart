import 'package:flutter/material.dart';

class CustomAppbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(
          color: Color.fromRGBO(255, 204, 0, 1),
        ),
        title: Text(
          'TRANS-SIBI',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
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
                radius: 17,
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
            _showBluetoothAlert(context);
          },
        ),
      ],
    );
  }

  void _showBluetoothAlert(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Bluetooth"),
          content: Text("Bluetooth is not connected."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

}  