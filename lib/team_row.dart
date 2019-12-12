import 'package:flutter/material.dart';

class TeamRow extends StatelessWidget {
  // final _counter;
  final Function setPair;
  final Map team;
  final Function onBetTeam;

  TeamRow(this.setPair, this.team, this.onBetTeam);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: team['isChecked']
          ? Colors.green
          : team['oldCash'] > 0 ? Colors.orange : Colors.red,
      child: InkWell(
          splashColor: Colors.blue.withAlpha(30),
          onTap: () {
            setPair();
          },
          child: ListTile(
            title: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(team['team']),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(team['quota'].toString()),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${team['cash'].toString()} €'),
                ),
              ],
            ),
            trailing: Switch(
              value: team['isAdd'],
              onChanged: onBetTeam,
              // activeTrackColor: Colors.green,
              activeColor: Colors.blue,
            ),
          )),
    );
  }
}
