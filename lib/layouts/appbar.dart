import 'package:flutter/material.dart';
import '../menu/bluetooth.dart';

class CustomAppbar extends StatelessWidget implements PreferredSizeWidget {
  final ValueNotifier<bool> isConnectedNotifier;
  final Function(Widget) onSelectPage;
  CustomAppbar({required this.isConnectedNotifier, required this.onSelectPage});

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
                child: ValueListenableBuilder<bool>(
                  valueListenable: isConnectedNotifier,
                  builder: (context, isConnected, child) {
                    return CircleAvatar(
                      backgroundColor: isConnected ? Colors.green : Colors.red,
                      radius: 5,
                    );
                  },
                ),
              ),
            ],
          ),
          onPressed: () {
            onSelectPage(BluetoothPage(isConnectedNotifier: isConnectedNotifier));
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
