import 'package:flutter/material.dart';
import 'package:todotoday/MessageBox.dart';
import 'package:todotoday/QuantityBadge.dart';
import 'package:todotoday/all.dart';
import 'package:todotoday/global.dart';
import 'package:todotoday/tags.dart';
import 'package:todotoday/today.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODOTODAY',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: const ColorScheme.highContrastDark().copyWith(
          primary: Colors.greenAccent,
          secondary: Colors.green,
          tertiary: Colors.red,
        ),
        fontFamily: 'Courier',
      ),
      home: MyHomePage(
        title: '',
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Stack(
                  children: [
                    Tab(icon: Icon(Icons.all_inbox)),
                    QuantityBadge(getAllCount()),
                  ],
                ),
                Stack(
                  children: [
                    Tab(icon: Icon(Icons.sunny)),
                    QuantityBadge(getTodayCount()),
                  ],
                ),
                Stack(
                  children: [
                    Tab(icon: Icon(Icons.tag)),
                  ],
                ),
              ],
            ),
            toolbarHeight: 0,
          ),
          body: Stack(
            children: [
              Stack(
                children: [
                  TabBarView(
                    children: [
                      All(
                        key: UniqueKey(),
                        title: '',
                      ),
                      Today(
                        key: UniqueKey(),
                        title: '',
                      ),
                      Tags(
                        key: UniqueKey(),
                        title: '',
                      ),
                    ],
                  ),
                ],
              ),
              MessageBox(),
              Positioned(
                bottom: 70,
                right: 6,
                child: Transform.scale(
                  scale: .6,
                  child: FloatingActionButton(
                    backgroundColor: Colors.grey,
                    onPressed: () {
                      _showDialog(context);
                    },
                    tooltip: 'Add',
                    child: const Icon(Icons.settings),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int getTodayCount() {
    int n = 0;
    for (var i = 0; i < tasks.length; i++) {
      if (tasks[i].isToday) {
        n++;
      }
    }
    return n;
  }

  int getAllCount() {
    int n = 0;
    for (var i = 0; i < tasks.length; i++) {
      if (!tasks[i].isChecked && !tasks[i].isToday) {
        n++;
      }
    }
    return n;
  }
}

void _showDialog(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new TextButton(
          onPressed: () {
            tasks.clear();
            runApp(MyApp());
          },
          child: const Text(
            "Clear All Tasks",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 20,
            ),
          ),
        ),
        actions: <Widget>[
          // usually buttons at the bottom of the dialog
          new TextButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();

                FocusManager.instance.primaryFocus?.unfocus();
              }),
        ],
      );
    },
  );
}
