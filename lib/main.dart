import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sorting_app/common/bar.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sorting Visualizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Sorting Visualizer'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}
List<Bar> barList = List<Bar>(50);
List<double> valueList = List<double>(50); 
List<int> stateList = List<int>.filled(50, 1); 

class _MyHomePageState extends State<MyHomePage> {
  void swap(int a, int b) async {
    await Future.delayed(const Duration(milliseconds: 50), () {
      setState(() {
        var x = valueList[b];
        valueList[b] = valueList[a];
        valueList[a] = x;
      });
    });
  }

  void bubbleSort() async {
    int len = valueList.length;
    for (int i = 0; i < len - 1; i++) {
      for (int j = 0; j < len - i - 1; j++) {
        if (valueList[j] > valueList[j + 1]) {
          if(stateList[j] == 3 || stateList[j+1] == 3 || stateList[j] == 1 || stateList[j+1] == 1 || stateList[j] == 4 || stateList[j+1] == 4){
            await Future.delayed(const Duration(milliseconds: 50), () {
              setState(() {
                stateList[j] = 2;
                stateList[j+1] = 2;
              });
            });
          }
          await swap(j, j + 1);
          await Future.delayed(const Duration(milliseconds: 50), () {
            setState(() {
              stateList[j] = 4;
              stateList[j+1] = 4;
            });
          });
        }
      }
    }
    for (int i = 0; i < len; i++) {
      stateList[i] = 3;
    }  
  }

  @override
  void initState(){
    for(int i=0; i<valueList.length; i++){
      var rnd = new Random();
      double res = rnd.nextDouble();
      valueList[i] = res;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height - 50;
    var _width = MediaQuery.of(context).size.width * 0.9;

    for (int i = 0; i < barList.length; i++) {
      Bar tempBar = new Bar(
        value: valueList[i],
        stateValue: stateList[i],
      );
      barList[i] = tempBar;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        actions: <Widget>[
          RaisedButton(
            onPressed: () {
              bubbleSort();
            },
            child: Text("Bubble Sort"),
          )
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.only(top: 2.0, bottom: 2.0),
          height: _height,
          width: _width,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: barList,
          ),
        ),
      ),
    );
  }
}
