import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'menu/bluetooth.dart';
import 'layouts/appbar.dart';
import 'layouts/drawer.dart';
import 'menu/talk.dart';
import 'menu/guide.dart';
import 'menu/about.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ValueNotifier<bool> isConnectedNotifier = ValueNotifier<bool>(false);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BasePage(
        isConnectedNotifier: isConnectedNotifier,
        child: TalkPage(
          isConnectedNotifier: isConnectedNotifier,
          connectedDeviceName: ValueNotifier<String?>(null),
        ),
      ),
    );
  }
}

class BasePage extends StatelessWidget {
  final ValueNotifier<bool> isConnectedNotifier;
  final Widget child;

  BasePage({required this.isConnectedNotifier, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        isConnectedNotifier: isConnectedNotifier,
        onSelectPage: (page) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => page),
          );
        },
      ),
      drawer: CustomDrawer(
        onSelectPage: (page) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => BasePage(
              isConnectedNotifier: isConnectedNotifier,
              child: page,
            )),
          );
        },
        isConnectedNotifier: isConnectedNotifier,
      ),
      body: child,
    );
  }
}
