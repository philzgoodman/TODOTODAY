import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/fade_effect.dart';
import 'package:todotoday/HeaderLabel.dart';
import 'package:todotoday/addUser.dart';
import 'package:todotoday/done.dart';
import 'package:todotoday/global.dart';

class All extends StatefulWidget {
  All({Key? key, required String title}) : super(key: key);

  @override
  State<All> createState() => _AllState();
}

class _AllState extends State<All> {



  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        SingleChildScrollView(
          reverse: true,
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [

              const HeaderLabel(),
              ListView.builder(
                scrollDirection: Axis.vertical,
                addAutomaticKeepAlives: false,
                reverse: false,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  if (index == tasks.length - 1 && tasks[index].isChecked == false && tasks[index].isToday == false) {
                    return Animate(effects: [
                      FadeEffect(),
                    ], child: tasks[index]);
                  } else if (!tasks[index].isChecked && !tasks[index].isToday) {
                    return tasks[index];
                  } else {
                    return const SizedBox(
                      height: 0,
                    );
                  }
                },
              ),
              SizedBox(
                height: 110,
              ),
              Done(),
            ],
          ),
        ),
      ],
    );
  }
}
