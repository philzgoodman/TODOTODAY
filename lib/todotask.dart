import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/global.dart';
import 'package:todotoday/main.dart';

class TodoTask extends StatefulWidget {
  String name;
  String subtitle = "#default";
  bool isChecked = false;
  bool isToday = false;

  var toDoColor;

  TodoTask(
      this.name, this.subtitle, this.isChecked, this.isToday, this.toDoColor,
      {super.key});

  @override
  State<TodoTask> createState() => TodoTaskState();
}

class TodoTaskState extends State<TodoTask> {
  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.red;
    }

    return Material(
      borderRadius: BorderRadius.circular(5),
      surfaceTintColor: Colors.red,
      elevation: 10,
      shadowColor: Colors.black26,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 14, 4),
        child: ListTile(
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 6, 7),
          tileColor: widget.toDoColor,
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          dense: true,
          minVerticalPadding: 0,
          title: TextField(
            style: const TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
            ),
            controller: TextEditingController(text: widget.name),
            onChanged: (text) {
              widget.name = text;
            },
          ),
          subtitle: GestureDetector(
            onTap: () {
              setState(() {
                DefaultTabController.of(context)?.animateTo(2);
              });
            },
            child: Text(
                style: const TextStyle(color: Colors.blue, fontSize: 12),
                widget.subtitle),
          ),
          trailing: Wrap(children: [
            SizedBox(
              width: 50,
              child: Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: widget.isChecked,
                onChanged: (value) {
                  setState(() {
                    widget.isChecked = value!;
                    runApp(MyApp());
                  });
                },
              ),
            ),
            const SizedBox(width: 20),
            SizedBox(
              width: 50,
              child: Checkbox(
                checkColor: Colors.white,
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: widget.isToday,
                onChanged: (value) {
                  setState(() {
                    widget.isToday = value!;
                    runApp(MyApp());
                  });
                },
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
