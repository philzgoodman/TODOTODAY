import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/fade_effect.dart';
import 'package:flutter_animate/effects/scale_effect.dart';
import 'package:todotoday/MessageBox.dart';
import 'package:todotoday/QuantityBadge.dart';
import 'package:todotoday/TileColors.dart';
import 'package:todotoday/UserBackground.dart';
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
        onTap: () { FocusManager.instance.primaryFocus?.unfocus();
        isEditing = false;

          },
        child: Stack(
          children: [
            userBG,
            Scaffold(
              backgroundColor: Colors.black26,
              resizeToAvoidBottomInset: true,
              appBar: AppBar(
                shadowColor: Colors.black87,
                elevation: 6,
                bottom: TabBar(

                    enableFeedback: true,
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
                        QuantityBadge(getTagCount()),
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
                          tag
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
          ],
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

  int getTagCount() {
    for (var i = 0; i < tasks.length; i++) {
      subtitles.add(tasks[i].subtitle);
    }

    uniqueSubtitles = subtitles.toSet().toList();


    return uniqueSubtitles.length;

  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
            backgroundColor: Color(0xE8231216),
          title: new TextButton(
            onPressed: () {
              tasks.clear();
              runApp(MyApp());
            },
            child: const Text(
              "Clear All Tasks",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15,
              ),
            ),
          ),
          content: TextButton(
            onPressed: () {
              userBG.userColorList.clear();
              userBG = UserBackground([
                TileColors.TILECOLORS
                    .elementAt(Random().nextInt(TileColors.TILECOLORS.length)),
                TileColors.TILECOLORS
                    .elementAt(Random().nextInt(TileColors.TILECOLORS.length)),
                TileColors.TILECOLORS
                    .elementAt(Random().nextInt(TileColors.TILECOLORS.length))
              ]);
              Navigator.of(context).pop();
              runApp(MyApp());
            },
            child: const Text(
              textAlign: TextAlign.center,
              "Shuffle Background Colors",
              style: TextStyle(
                color: Colors.blue,
                fontSize: 15,
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
}
