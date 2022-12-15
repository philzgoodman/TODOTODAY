import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/global.dart';
import 'package:todotoday/main.dart';
import 'todotask.dart';

class Tags extends StatefulWidget {
  const Tags({Key? key, required String title}) : super(key: key);

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  var subtitles = [];
  List uniqueSubtitles = [];
  int count = 0;

  @override
  void initState() {
    for (var i = 0; i < tasks.length; i++) {
      subtitles.add(tasks[i].subtitle);
    }

    uniqueSubtitles = subtitles.toSet().toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: uniqueSubtitles.length,
        itemBuilder: (context, index) {
          count = 0;

          for (int i = 0; i < tasks.length; i++) {
            if (tasks[i].subtitle == uniqueSubtitles[index]) {
              count++;
            }
          }

          return TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color((Random().nextDouble() * 0xFFFFFF) ~/ 4)
                    .withOpacity(0.7),
              ),
              onPressed: () {},
              child:
                  Text(uniqueSubtitles[index] + " (" + count.toString() + ")"));
        },
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          mainAxisExtent: 70,
        ),
      ),
    );
  }
}
