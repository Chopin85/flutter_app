import 'package:flutter/material.dart';

class TextOutput extends StatelessWidget {
  final _counter;

  TextOutput(this._counter);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_counter',
      style: Theme.of(context).textTheme.display1,
    );
  }
}
