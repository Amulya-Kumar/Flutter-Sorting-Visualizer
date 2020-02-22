import 'package:flutter/material.dart';

class Bar extends StatefulWidget {
  double value;
  int stateValue;

  double _maxElementHeight = 100;

  Bar({this.value, this.stateValue});

  @override
  _BarState createState() => _BarState();
}

class _BarState extends State<Bar> {
  @override
  Widget build(BuildContext context) {
    widget._maxElementHeight = MediaQuery.of(context).size.height - 60;
    return Column(
      children: <Widget>[
        Container(
          height: (1 - widget.value) * widget._maxElementHeight,
        ),
        Container(
          width: MediaQuery.of(context).size.width*0.9 /50,
          height: widget.value * widget._maxElementHeight,
          color: widget.stateValue == 1 ? Colors.blue : widget.stateValue == 2 ? Colors.red : widget.stateValue == 3 ? Colors.green : widget.stateValue == 4 ? Colors.orange : Colors.white54,
        ),
      ],
    );
  }
}
