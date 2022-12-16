import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/HeaderLabel.dart';
import 'package:todotoday/done.dart';
import 'package:todotoday/global.dart';

class Today extends StatefulWidget {
  const Today({Key? key, required String title}) : super(key: key);

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  @override
  Widget build(BuildContext context) {
    return Stack(
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
                  if (tasks[index].isToday) {
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
