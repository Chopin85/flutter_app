import 'package:flutter/material.dart';
import './text_output.dart';
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
      home: MyHomePage(title: 'BetApp'),
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
            Text(
              'You have pushed the button this many times:',
            ),
            TextOutput(_counter),
            Visibility(
              child: ListTile(
                leading: Icon(Icons.map),
                title: Text('Map'),
              ),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: show,
            ),
            RaisedButton(child: Text('Fetch'), onPressed: fetchPost),
            RaisedButton(child: Text('Show'), onPressed: _showFunc),
            Visibility(
              child: ColorLoader(
                  colors: colors, duration: Duration(milliseconds: 1200)),
              maintainSize: true,
              maintainAnimation: true,
              maintainState: true,
              visible: showLoader,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
