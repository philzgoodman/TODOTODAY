import 'dart:math';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserBackground extends StatefulWidget {
  List<Color> userColorList = [];

  UserBackground(this.userColorList, {super.key});

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
            widget.userColorList[0],
            widget.userColorList[1],
            widget.userColorList[2],
          ],
          // Gradient from https://learnui.design/tools/gradient-generator.html
          tileMode: TileMode.mirror,
        ),
      ),
    );
  }
}
