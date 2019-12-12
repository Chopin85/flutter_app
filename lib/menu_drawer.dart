import 'package:flutter/material.dart';

class MenuDrawer extends StatelessWidget {
  navigateToPage(BuildContext context, String page) {
    Navigator.of(context)
        .pushNamedAndRemoveUntil(page, (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        DrawerHeader(
          child: Text('BetApp Menu'),
          decoration: BoxDecoration(
            color: Colors.blue,
          ),
        ),
        ListTile(
          title: Text('Serie A'),
          onTap: () {
            navigateToPage(context, 'seriea');
          },
        ),
        ListTile(
          title: Text('Ligue 1'),
          onTap: () {
            navigateToPage(context, 'ligue1');
          },
        ),
      ],
    ));
  }
}
