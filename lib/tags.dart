import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/TagView.dart';
import 'package:todotoday/global.dart';

class Tags extends StatefulWidget {
  int quantity = 1;
  String hashtag = '';
  String sendTag = '';

  Tags({Key? key, required String title}) : super(key: key);

  @override
  State<Tags> createState() => _TagsState();
}

class _TagsState extends State<Tags> {
  int count = 0;
  late Widget expandedTag;
  String tagString = '';

  @override
  void initState() {
    for (var i = 0; i < tasks.length; i++) {
      subtitles.add(tasks[i].subtitle);
    }

    uniqueSubtitles = subtitles.toSet().toList();

    super.initState();

    expandedTag = TagView("default");
  }

  @override
  Widget build(BuildContext context) {
    bool isExpanded = true;

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          itemCount: uniqueSubtitles.length,
          itemBuilder: (context, index) {
            count = 0;

            for (int i = 0; i < tasks.length; i++) {
              if (tasks[i].subtitle == uniqueSubtitles[index]) {
                count++;
              }

              widget.quantity = uniqueSubtitles.length;
            }

            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Material(
                elevation: 5,
                child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor:
                          Color((Random().nextDouble() * 0xFFFFFF) ~/ 4)
                              .withOpacity(0.7),
                    ),
                    onPressed: () {
                      setState(() {
                        expandedTag = TagView(uniqueSubtitles[index]);
                        _showDialog(context);
                      });
                    },
                    child: Text(uniqueSubtitles[index] +
                        " (" +
                        count.toString() +
                        ")")),
              ),
            );
          },
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            mainAxisExtent: 70,
          ),
        ),
      ],
    );
  }

  void _showDialog(BuildContext context) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          backgroundColor: Colors.transparent,
          elevation: 2,
          content: expandedTag,
        );
      },
    );
  }
}
