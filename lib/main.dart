import 'package:flutter/material.dart';
import 'layouts/drawer.dart';
import 'layouts/appbar.dart';
import 'menu/talk.dart';
import 'menu/about.dart';
import 'menu/guide.dart';


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

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget _selectedPage = TalkPage();

  void _onSelectPage(Widget page) {
    setState(() {
      _selectedPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: CustomAppbar(),
      ),
      drawer: CustomDrawer(onSelectPage: _onSelectPage),
      body: _selectedPage,
    );
  }
}