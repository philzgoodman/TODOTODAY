import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:todotoday/global.dart';

class Done extends StatefulWidget {
  Done({super.key});

  @override
  State<Done> createState() => _DoneState();
}

class _DoneState extends State<Done> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(children: [
          SizedBox(
            height: 110,
          ),
          Text(
            'DONE ↓',
            style: TextStyle(color: Colors.white, fontSize: 15),
          ),
          Transform.scale(
            scale: 0.85,
            child: Opacity(
              opacity: 0.35,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  if (tasks[index].isChecked) {
                    return tasks[index];
                  } else {
                    return const SizedBox(
                      height: 0,
                    );
                  }
                },
              ),
            ),
          ),
        ]),
      ],
    );
  }
}
