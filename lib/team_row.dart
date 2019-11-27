import 'package:flutter/material.dart';

class TeamRow extends StatelessWidget {
  // final _counter;
  final Function setPair;
  final Map team;
  final Function onBetTeam;

  final int utile = 25;

  TeamRow(this.setPair, this.team, this.onBetTeam);

  int _calcBet() {
    return (utile / (team['quota'] - 1)).ceil();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: team['pair'] ? Colors.green : Colors.red,
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
                  child: Text('${_calcBet().toString()} €'),
                ),
              ],
            ),
            trailing: Checkbox(
              value: team['bet'],
              tristate: false,
              onChanged: onBetTeam,
            ),
          )),
    );
  }
}
