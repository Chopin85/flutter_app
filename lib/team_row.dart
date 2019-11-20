import 'package:flutter/material.dart';

class TeamRow extends StatelessWidget {
  // final _counter;
  Function setPair;

  TeamRow(this.setPair);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            setPair('ok');
          },
          child: ListTile(
            leading: Icon(Icons.album, size: 50),
            title: Text('Heart Shaker'),
            subtitle: Text('TWICE'),
          )),
    );
  }
}
