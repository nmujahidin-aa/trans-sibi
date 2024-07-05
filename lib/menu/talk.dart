import 'package:flutter/material.dart';
import 'dart:async';
import 'bluetooth.dart';

class TalkPage extends StatelessWidget {
  final ValueNotifier<bool> isConnectedNotifier;
  final ValueNotifier<String?> connectedDeviceName;

  TalkPage({required this.isConnectedNotifier, required this.connectedDeviceName});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 45.0,
              decoration: BoxDecoration(
                color: Color.fromRGBO(255, 0, 0, 0.3),
              ),
              child: Center(
                child: ValueListenableBuilder<bool>(
                  valueListenable: isConnectedNotifier,
                  builder: (context, isConnected, child) {
                    print('isConnected: $isConnected');
                    print('connecedDevice: $connectedDeviceName');
                    return Text(
                      isConnected ? 'Bluetooth terhubung' : 'Bluetooth tidak terhubung',
                      style: TextStyle(
                        color: isConnected ? Colors.green : Colors.red, 
                        fontWeight: FontWeight.bold,
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: 16),
            ValueListenableBuilder<String?>(
              valueListenable: connectedDeviceName,
              builder: (context, name, child) {
                return Text(
                  'Connected Device: ${name ?? "No Device"}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
