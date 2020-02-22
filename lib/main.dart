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

  void insertionSort() async {
    for (int i = 1; i < valueList.length; i++) {
      double key = valueList[i];
      int j = i - 1;
      while (j >= 0 && key < valueList[j]) {
        if (stateList[j] == 3 ||
            stateList[j + 1] == 3 ||
            stateList[j] == 1 ||
            stateList[j + 1] == 1 ||
            stateList[j] == 4 ||
            stateList[j + 1] == 4) {
          await Future.delayed(const Duration(milliseconds: 20), () {
            setState(() {
              stateList[j] = 2;
              stateList[j + 1] = 2;
            });
          });
        }
        await swap(j, j + 1);
        await Future.delayed(const Duration(milliseconds: 20), () {
          setState(() {
            stateList[j] = 4;
            stateList[j + 1] = 4;
          });
        });
        j -= 1;
      }
      valueList[j + 1] = key;
    }
    for (int i = 0; i < valueList.length; i++) {
      stateList[i] = 3;
    }
  }

  dynamic partition(int low, int high) async {
    int i = low - 1;
    double pivot = valueList[high];
    for (int j = low; j < high; j++) {
      if (valueList[j] < pivot) {
        i = i + 1;
        if (stateList[j] == 3 ||
            stateList[i] == 3 ||
            stateList[j] == 1 ||
            stateList[i] == 1 ||
            stateList[j] == 4 ||
            stateList[i] == 4) {
          await Future.delayed(const Duration(milliseconds: 20), () {
            setState(() {
              stateList[j] = 2;
              stateList[i] = 2;
            });
          });
        }
        await swap(i, j);
        await Future.delayed(const Duration(milliseconds: 20), () {
          setState(() {
            stateList[j] = 4;
            stateList[i] = 4;
          });
        });
      }
    }
    if (stateList[high] == 3 ||
        stateList[i + 1] == 3 ||
        stateList[high] == 1 ||
        stateList[i + 1] == 1 ||
        stateList[high] == 4 ||
        stateList[i + 1] == 4) {
      await Future.delayed(const Duration(milliseconds: 20), () {
        setState(() {
          stateList[high] = 2;
          stateList[i + 1] = 2;
        });
      });
    }
    await swap(i + 1, high);
    await Future.delayed(const Duration(milliseconds: 20), () {
      setState(() {
        stateList[high] = 4;
        stateList[i + 1] = 4;
      });
    });
    return i + 1;
  }

  void quickSort(int low, int high) async {
    if (low < high) {
      var pi = await partition(low, high);
      await quickSort(low, pi - 1);
      await quickSort(pi + 1, high);
    }
  }

  void merge(int l, int m, int r) async {
    int i, j, k;
    int n1 = m - l + 1;
    int n2 = r - m;

    List<double> left = List<double>(n1);
    List<double> right = List<double>(n2);

    for (i = 0; i < n1; i++) {
      left[i] = valueList[l + i];
    }
    for (j = 0; j < n2; j++) {
      right[j] = valueList[m + 1 + j];
    }
    i = 0; // Initial index of first subarray
    j = 0; // Initial index of second subarray
    k = l; // Initial index of merged subarray

    while (i < n1 && j < n2) {
      if (left[i] <= right[j]) {
        await Future.delayed(const Duration(milliseconds: 20), () {
          setState(() {
            stateList[k] = 2;
          });
        });
        await Future.delayed(const Duration(milliseconds: 50), () {
          setState(() {
            valueList[k] = left[i];
          });
        });
        await Future.delayed(const Duration(milliseconds: 20), () {
          setState(() {
            stateList[k] = 4;
          });
        });
        i++;
      } else {
        await Future.delayed(const Duration(milliseconds: 20), () {
          setState(() {
            stateList[k] = 2;
            valueList[k] = right[j];
            stateList[k] = 4;
          });
        });
        j++;
      }
      k++;
    }

    /* Copy the remaining elements of L[], if there 
       are any */
    while (i < n1) {
      await Future.delayed(const Duration(milliseconds: 20), () {
        setState(() {
          valueList[k] = left[i];
        });
      });
      
      i++;
      k++;
    }

    /* Copy the remaining elements of R[], if there 
       are any */
    while (j < n2) {
      await Future.delayed(const Duration(milliseconds: 20), () {
        setState(() {
          valueList[k] = right[j];
        });
      });
      j++;
      k++;
    }
  }

  void mergeSort(int l, int r) async {
    if (l < r) {
      int m = ((l + r) ~/ 2);
      await mergeSort(l, m);
      await mergeSort(m + 1, r);

      await merge(l, m, r);
    }
  }

  void doMergeSort() async {
    await mergeSort(0, (valueList.length - 1));
    for (int i = 0; i < valueList.length; i++) {
      stateList[i] = 3;
    }
  }

  void bubbleSort() async {
    int len = valueList.length;
    for (int i = 0; i < len - 1; i++) {
      for (int j = 0; j < len - i - 1; j++) {
        if (valueList[j] > valueList[j + 1]) {
          if (stateList[j] == 3 ||
              stateList[j + 1] == 3 ||
              stateList[j] == 1 ||
              stateList[j + 1] == 1 ||
              stateList[j] == 4 ||
              stateList[j + 1] == 4) {
            await Future.delayed(const Duration(milliseconds: 20), () {
              setState(() {
                stateList[j] = 2;
                stateList[j + 1] = 2;
              });
            });
          }
          await swap(j, j + 1);
          await Future.delayed(const Duration(milliseconds: 20), () {
            setState(() {
              stateList[j] = 4;
              stateList[j + 1] = 4;
            });
          });
        }
      }
    }
    for (int i = 0; i < len; i++) {
      stateList[i] = 3;
    }
  }

  void doQuickSort() async {
    await quickSort(0, (valueList.length - 1));
    for (int i = 0; i < valueList.length; i++) {
      stateList[i] = 3;
    }
  }

  void refreshState() {
    for (int i = 0; i < valueList.length; i++) {
      var rnd = new Random();
      double res = rnd.nextDouble();
      setState(() {
        valueList[i] = res;
      });
    }

    for (int i = 0; i < valueList.length; i++) {
      stateList[i] = 1;
    }
  }

  @override
  void initState() {
    for (int i = 0; i < valueList.length; i++) {
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
          IconButton(icon: Icon(Icons.refresh), onPressed: refreshState),
          RaisedButton(
            onPressed: () async {
              await mergeSort(0, valueList.length-1);
              //await insertionSort();
            },
            child: Text("Bubble Sort"),
          ),
          RaisedButton(
            onPressed: () async {
              await doQuickSort();
              //await insertionSort();
            },
            child: Text("Quick Sort"),
          ),
          RaisedButton(
            onPressed: () async {
              await insertionSort();
              //await insertionSort();
            },
            child: Text("Insertion Sort"),
          ),
          RaisedButton(
            onPressed: () async {
              await doMergeSort();
              //await insertionSort();
            },
            child: Text("Merge Sort"),
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
