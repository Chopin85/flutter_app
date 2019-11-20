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

class Post {
  final int userId;
  final int id;
  final String title;
  final String body;

  Post({this.userId, this.id, this.title, this.body});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      userId: json['userId'],
      id: json['id'],
      title: json['title'],
      body: json['body'],
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List data;

  bool show = false;

  bool showLoader = false;

  final utile = TextEditingController();

  final sessionImport = TextEditingController();

  final sessionExport = TextEditingController();

  @override
  void initState() {
    super.initState();

    utile.addListener(() => print(utile.text));
    sessionImport.addListener(() => print(sessionImport.text));
    sessionExport.addListener(() => print(sessionExport.text));
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

  Future fetchPost() async {
    setState(() {
      showLoader = true;
    });
    final response =
        await http.get('https://jsonplaceholder.typicode.com/posts');

    if (response.statusCode == 200) {
      // If server returns an OK response, parse the JSON.
      setState(() {
        showLoader = false;
        data = (json.decode(response.body)).sublist(0, 10);
      });
      print(response.body);
    } else {
      // If that response was not OK, throw an error.
      throw Exception('Failed to load post');
    }
  }

  void _showFunc() {
    setState(() {
      show = !show;
    });
  }

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
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'UTILE',
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 178.0),
                    child: TextField(
                      controller: utile,
                      decoration: InputDecoration(
                        //Add th Hint text here.
                        hintText: "Utile",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    'IMPORT',
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: TextField(
                      controller: sessionImport,
                      decoration: InputDecoration(
                        //Add th Hint text here.
                        hintText: "Session import",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 50.0),
                  child:
                      RaisedButton(child: Text('Fetch'), onPressed: fetchPost),
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
                  child:
                      RaisedButton(child: Text('Fetch'), onPressed: fetchPost),
                ),
              ],
            ),
            RaisedButton(child: Text('Show'), onPressed: _showFunc),

            // Text(
            //   'You have pushed the button this many times:',
            // ),
            // TeamRow(_counter),

            Visibility(
              child: TeamRow((e) => print(e)),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: show,
            ),
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
