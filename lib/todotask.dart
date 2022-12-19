import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/fade_effect.dart';
import 'package:todotoday/global.dart';
import 'package:todotoday/main.dart';

import 'MessageBox.dart';

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
      return Colors.grey;
    }

    return Card(
      surfaceTintColor: Colors.black26,
      elevation: 5,
      shadowColor: Color(0xFF000008E),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: ListTile(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5.0),
        ),
        contentPadding: const EdgeInsets.fromLTRB(10, 0, 6, 7),
        tileColor: darken(widget.toDoColor, 6),
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
          onTap: () {
            setState(() {
              isEditing = true;
            });
          },
          onEditingComplete: () {
            setState(() {
              isEditing = false;
            });
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
            child: Animate(
              effects: [
                FadeEffect(),
              ],
              child: Checkbox(
                checkColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                fillColor: MaterialStateProperty.resolveWith(getColor),
                value: widget.isChecked,
                onChanged: (value) {
                  checked();
                },
              ),
            ),
          ),
          const SizedBox(width: 20),
          Switch(
            inactiveThumbColor: Colors.red,
            inactiveTrackColor: Colors.grey,
            activeColor: Color(0xFFFFBD64)  ,
            value: widget.isToday,
            onChanged: (value) {
            slideSwitch();
           value = !value;
            },
          ),


        ]),
      ),
    );
  }
void slideSwitch() {
  setState(() {
    widget.isToday = !widget.isToday;

    Future.delayed(const Duration(milliseconds: 300), () {
      saveToShared();
      runApp(MyApp());
    });

  });
}
  void checked() {
    setState(() {
      widget.isChecked = !widget.isChecked;



      Future.delayed(const Duration(milliseconds: 300), () {

        saveToShared();
        runApp(MyApp());



      });
    });
  }

}


Color darken(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
      (c.blue * f).round());
}

