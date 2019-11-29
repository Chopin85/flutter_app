import 'package:flutter/material.dart';
import './team_row.dart';
import './color_loader.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'DemoApp'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Team {
  final String team;
  final double quota;

  Team({this.team, this.quota});

  result() => {'team': team, 'quota': quota, 'pair': false, 'bet': false};
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List data;

  bool show = false;

  bool pair = false;

  bool showLoader = false;

  List teamData = [];

  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  final utile = TextEditingController();

  final sessionImport = TextEditingController();

  final sessionExport = TextEditingController();

  @override
  void initState() {
    super.initState();

    // utile.addListener(() => print(utile.text));
    // sessionImport.addListener(() => print(sessionImport.text));
    // sessionExport.addListener(() => print(sessionExport.text));
  }

  List<Color> colors = [
    // Colors.red,
    // Colors.green,
    // Colors.indigo,
    // Colors.pinkAccent,
    Colors.blue
  ];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void addToList(String team, double quota) {
    setState(() {
      teamData.add(Team(team: team, quota: quota).result());
    });
    // print(teamData);
  }

  Future _fetchPost() async {
    setState(() {
      showLoader = true;
    });
    teamData.clear();
    final response = await http.get(
        'http://10.0.2.2:3001/match/seriea/request?session=${sessionExport.text}');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.

      if (response.body == 'not find') {
        print('ok');
      } else {
        List result = json.decode(response.body)['match'];

        result.forEach((element) => {
              element['match']
                  .split("-")
                  .forEach((fruit) => addToList(fruit, element['quota']))
            });

        print(teamData.length);
      }

      setState(() {
        showLoader = false;
        // data = (json.decode(response.body)).sublist(0, 2);
      });
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  void _showFunc() {
    setState(() {
      show = !show;
      print('ok');
    });
  }

  void _setPair() {
    setState(() {
      pair = !pair;
    });
  }

  void _testFunc(team) {
    int findIndex = teamData.indexWhere((e) => e['team'] == team);

    setState(() {
      teamData[findIndex]['pair'] = !teamData[findIndex]['pair'];
    });

    print(teamData[findIndex]['pair']);
  }

  void _setBetTeam(bool valuen, team) {
    int findIndex = teamData.indexWhere((e) => e['team'] == team);

    setState(() {
      teamData[findIndex]['bet'] = !teamData[findIndex]['bet'];
    });

    print(teamData[findIndex]['bet']);
  }

  // void _value2Changed(bool value) => print('okk');

// Widget _buildSuggestions() {
//   return ListView.builder(
//     itemCount: ,
//       itemBuilder: teamData.map(e => Text(e.team)));
// }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Row(
            //   children: <Widget>[
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //       child: Text(
            //         'UTILE',
            //       ),
            //     ),
            //     Flexible(
            //       child: Padding(
            //         padding: const EdgeInsets.only(left: 20.0, right: 178.0),
            //         child: TextField(
            //           controller: utile,
            //           decoration: InputDecoration(
            //             //Add th Hint text here.
            //             hintText: "Utile",
            //             border: OutlineInputBorder(),
            //           ),
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
            // Row(
            //   children: <Widget>[
            //     Padding(
            //       padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //       child: Text(
            //         'IMPORT',
            //       ),
            //     ),
            //     Flexible(
            //       child: Padding(
            //         padding: const EdgeInsets.symmetric(horizontal: 20.0),
            //         child: TextField(
            //           controller: sessionImport,
            //           decoration: InputDecoration(
            //             //Add th Hint text here.
            //             hintText: "Session import",
            //             border: OutlineInputBorder(),
            //           ),
            //         ),
            //       ),
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.only(left: 20.0, right: 50.0),
            //       child:
            //           RaisedButton(child: Text('Fetch'), onPressed: fetchPost),
            //     ),
            //   ],
            // ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'EXPORT',
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: sessionExport,
                      decoration: InputDecoration(
                        //Add th Hint text here.
                        hintText: "Session Export",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 50.0),
                    child: RaisedButton(
                        child: Text('Fetch'), onPressed: _fetchPost)),
              ],
            ),
            RaisedButton(child: Text('Show'), onPressed: _showFunc),
            // RaisedButton(child: Text('Fetch'), onPressed: fetchPost),
            // RaisedButton(child: Text('Print'), onPressed: addToList),

            // Text(
            //   'You have pushed the button this many times:',
            // ),
            // TeamRow(_counter),

            // Text(teamData[0]['team']),

            show
                ? new Expanded(
                    child: ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: teamData.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            child: TeamRow(
                                () => _testFunc(teamData[index]['team']),
                                teamData[index],
                                (e) => _setBetTeam(e, teamData[index]['team'])),
                            // height: 50,
                            // color: Colors.amber[colorCodes[index]],
                            // child: Center(child: Text('Entry ${entries[index]}')),
                          );
                        }))
                : Container(),

            // Visibility(
            //   child: Column(
            //     children: <Widget>[
            //       TeamRow(_setPair, pair),
            //       TeamRow(_setPair, pair),
            //     ],
            //   ),
            //   maintainSize: true,
            //   maintainAnimation: true,
            //   maintainState: true,
            //   visible: show,
            // ),
            // RaisedButton(child: Text('Fetch'), onPressed: fetchPost),
            // Visibility(
            //   child: ColorLoader(
            //       colors: colors, duration: Duration(milliseconds: 1200)),
            //   maintainSize: true,
            //   maintainAnimation: true,
            //   maintainState: true,
            //   visible: showLoader,
            // ),
          ],
        ),
      ),
    );
  }
}
