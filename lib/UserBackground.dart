import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/TileColors.dart';
import 'package:todotoday/UserBackground.dart';
import 'package:todotoday/global.dart';

class UserBackground extends StatefulWidget {

  List<Color> userColorList = [];

  UserBackground(
      this.userColorList,
      {super.key});



  @override
  State<UserBackground> createState() => _UserBackgroundState();

}

class _UserBackgroundState extends State<UserBackground> {

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment(0.8, 1),
          colors: <Color>[
            darken(widget.userColorList[0],2),
            darken(widget.userColorList[1],2),
            darken(widget.userColorList[2],2),

          ],
          // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.mirror,
        ),
      ),
    );
  }
}
Color darken(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}