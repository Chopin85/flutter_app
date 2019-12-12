import 'package:flutter/material.dart';
import 'menu_drawer.dart';

class Ligue1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Ligue 1'),
      ),
      drawer: MenuDrawer(),
      body: Center(child: Text('Ligue 1')),
    );
  }
}
