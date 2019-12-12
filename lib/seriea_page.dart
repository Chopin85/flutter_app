import 'package:flutter/material.dart';
import './team_row.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'menu_drawer.dart';
import './team_class.dart';
import './service.dart';

class SerieA extends StatefulWidget {
  SerieA({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _SerieAState createState() => _SerieAState();
}

class _SerieAState extends State<SerieA> {
  bool showLoader = false;

  final List<Map<dynamic, dynamic>> teamData = [];

  final sessionExport = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchLastSession();
  }

  void addToList(String team, double quota, int oldCash) {
    setState(() {
      teamData.add(Team(team: team, quota: quota, oldCash: oldCash).result());
    });
  }

  final snackBar = SnackBar(content: Text('Done !'));

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future _fetchLastSession() async {
    setState(() {
      showLoader = true;
    });
    final response =
        await http.get('http://10.0.2.2:3001/match/seriea/lastsession');

    if (response.statusCode == 200) {
      _scaffoldKey.currentState.showSnackBar(snackBar);
      setState(() {
        sessionExport.text =
            (json.decode(response.body)['maxSession']).toString();
        showLoader = false;
      });
      // print(json.decode(response.body)['maxSession']);
    } else {
      throw Exception('Failed to load post');
    }
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
        _scaffoldKey.currentState.showSnackBar(SnackBar(
          content: Text('Not Find!'),
        ));
        print('ok');
      } else {
        final responseBet = await http.get('http://10.0.2.2:3001/bets/request');

        // List resultBet = (json.decode(responseBet.body));

        List result = json.decode(response.body)['match'];

        Map resultBet = json.decode(responseBet.body);

        List listBet = [];

        resultBet.forEach((k, v) => listBet.add(v));

        result.forEach((element) => {
              element['match'].split("-").forEach((team) => {
                    if (listBet.indexWhere((f) => f['team'] == team) > 0)
                      {
                        addToList(
                            team,
                            element['quota'],
                            listBet[listBet
                                .indexWhere((f) => f['team'] == team)]['cash'])
                      }
                    else
                      {addToList(team, element['quota'], 0)}
                  })
            });

        // print(teamData[0]);
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

  String solde = '';

  // Future _fetchSolde() async {
  //   setState(() {
  //     showLoader = true;
  //   });
  //   final response = await http.get('http://10.0.2.2:3001/solde/request');

  //   if (response.statusCode == 200) {
  //     if (response.body == 'not find') {
  //       print('ok');
  //     } else {
  //       setState(() {
  //         showLoader = false;
  //         solde = json.decode(response.body)['solde'];
  //       });
  //     }
  //   } else {
  //     throw Exception('Failed to load post');
  //   }
  // }

  Future _setMatchNull() async {
    setState(() {
      showLoader = true;
    });

    var postTest = json.encode({'data': teamData});

    var response = await http.post('http://10.0.2.2:3001/bets',
        headers: {"Content-Type": "application/json"}, body: postTest);

    if (response.statusCode == 200) {
      print(response.body);
      _scaffoldKey.currentState.showSnackBar(snackBar);
      setState(() {
        teamData.clear();
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  void _testFunc(team) {
    int findIndex = teamData.indexWhere((e) => e['team'] == team);

    setState(() {
      teamData[findIndex]['isChecked'] = !teamData[findIndex]['isChecked'];
    });

    print(teamData[findIndex]['isChecked']);
  }

  void _setBetTeam(bool valuen, team) {
    int findIndex = teamData.indexWhere((e) => e['team'] == team);

    setState(() {
      teamData[findIndex]['isAdd'] = valuen;
    });

    print(teamData[findIndex]['isAdd']);
  }

  void _setAllPair() {
    setState(() {
      teamData.forEach((e) => e.update("isChecked", (value) => true));
    });
  }

  Future _autoBet() async {
    List newArray = [];
    int size = 2;

    for (int i = 0; i < teamData.length; i += size) {
      List newList = (teamData.sublist(i, i + size));
      if (newList[0]['isAdd'] && newList[1]['isAdd']) {
        newArray.add({
          'match': '${newList[0]['team']} - ${newList[1]['team']}',
          'cash': newList[0]['cash'] + newList[1]['cash']
        });
      } else if (newList[0]['isAdd'] || newList[1]['isAdd']) {
        if (newList[0]['isAdd'])
          newArray.add({
            'match': '${newList[0]['team']} - ${newList[1]['team']}',
            'cash': newList[0]['cash']
          });
        if (newList[1]['isAdd'])
          newArray.add({
            'match': '${newList[0]['team']} - ${newList[1]['team']}',
            'cash': newList[1]['cash']
          });
      }
    }

    var postTest = json.encode({'teams': newArray});

    // print(postTest);

    var response = await http.post('http://10.0.2.2:3001/bets/sendcash/seriea',
        headers: {"Content-Type": "application/json"}, body: postTest);

    if (response.statusCode == 200) {
      // print(response.body);
      _scaffoldKey.currentState.showSnackBar(snackBar);
      setState(() {
        teamData.clear();
      });
    } else {
      throw Exception('Failed to load post');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              RaisedButton(child: Text('1-SET NULL'), onPressed: _setMatchNull),
              RaisedButton(child: Text('2-BET'), onPressed: _autoBet),
            ],
          ),
          elevation: 0,
        ),
        appBar: AppBar(
          title: Text(widget.title),
        ),
        drawer: MenuDrawer(),
        body: Builder(builder: (context) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text('SALDO'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(solde.toString()),
                  ),
                  RaisedButton(
                      child: Text('SALDO'),
                      onPressed: () => ServiceHttpTest()
                          .fetchSolde()
                          .then((e) => setState(() {
                                solde = e;
                              }))),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: RaisedButton(
                        child: Text('SET ALL PAIR'), onPressed: _setAllPair),
                  ),
                ],
              ),
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
                        keyboardType: TextInputType.number,
                        controller: sessionExport,
                        onSubmitted: (String str) {
                          _fetchPost();
                        },
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
                          child: Text('EXPORT'), onPressed: _fetchPost)),
                ],
              ),
              teamData.length > 0
                  ? new Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.all(8),
                          itemCount: teamData.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              child: TeamRow(
                                  () => _testFunc(teamData[index]['team']),
                                  teamData[index],
                                  (e) =>
                                      _setBetTeam(e, teamData[index]['team'])),
                            );
                          }))
                  : Container(),
            ],
          );
        }));
  }
}
