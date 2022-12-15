import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/HeaderLabel.dart';
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
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Column(
            children: [
              const HeaderLabel(),
              ListView.builder(
                scrollDirection: Axis.vertical,
                addAutomaticKeepAlives: false,
                reverse: true,
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  if (!tasks[index].isChecked && !tasks[index].isToday) {
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
            ],
          ),
        ),
      ],
    );
  }
}

