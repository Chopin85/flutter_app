import 'package:flutter/material.dart';

class TeamRow extends StatelessWidget {
  // final _counter;
  final bool select;
  final Function setPair;
  final String team;

  TeamRow(this.setPair, this.select, this.team);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: select ? Colors.green : Colors.red,
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            setPair();
          },
          child: ListTile(
            title: Text(team),
          )),
    );
  }
}
