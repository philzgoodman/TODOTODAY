import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/animate.dart';
import 'package:flutter_animate/effects/fade_effect.dart';
import 'package:todotoday/global.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:todotoday/main.dart';

import 'MessageBox.dart';
import 'TileColors.dart';

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
      child: GestureDetector(
        onTap: () {
         editMode(context);
        },
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          contentPadding: const EdgeInsets.fromLTRB(10, 0, 6, 7),
          tileColor: darken(widget.toDoColor, 6),
          visualDensity: const VisualDensity(horizontal: 0, vertical: -4),
          dense: true,
          minVerticalPadding: 0,
          title: Text(
              overflow: TextOverflow.ellipsis,
              maxLines: 1,


              widget.name),
          subtitle: Text(
              style: const TextStyle(color: Colors.blue, fontSize: 12),
              widget.subtitle),
          trailing: Wrap(children: [
            IconButton(
              color: Colors.grey,
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  tasks.remove(widget);
                  saveToFireStore();
                  saveToShared();
                  runApp(MyApp());
                });
              },
            ),
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

              if (FirebaseAuth.instance.currentUser != null) saveToFireStore();

              },
            ),



          ]),
        ),
      ),
    );
  }

  void updateText() {
    setState(() {
      if (DefaultTabController.of(context)?.index == 1) {
        tasks.add(TodoTask(txt.text, txt.text, false, true,
            TileColors.TILECOLORS.elementAt(tasks.length)));



      } else {
        tasks.add(TodoTask(txt.text, txt.text, false, false,
            TileColors.TILECOLORS.elementAt(tasks.length)));
      }

      txt.clear();
      for (var i = 0; i < tasks.length; i++) {
        getSubtitle(i);
      }
    });
    txt.clear();



    saveToShared();

    if (FirebaseAuth.instance.currentUser != null) saveToFireStore();


  }
  void editMode (BuildContext context) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(

          backgroundColor: Color(0xE8231216),


          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration:
                InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Text",

                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                ),
                  maxLines:6,
                  toolbarOptions: const ToolbarOptions(
                    copy: true,
                    cut: true,
                    paste: true,
                    selectAll: true,
                  ),
                  cursorColor: Colors.deepOrangeAccent,
                  style:
                  const TextStyle(color: Colors.white, fontSize: 14),
                  keyboardAppearance: Brightness.dark,

                  onChanged: (value) {
                    widget.name = value;
                  },
                  controller: TextEditingController(text: widget.name),


              ),
              SizedBox(height: 10,),
              TextField(
                controller: TextEditingController(text: widget.subtitle),
                decoration:
                InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Tag",
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white, width: 2.0),
                  ),
                ),
        ),

            ],

          ),
          actions: [

            IconButton(
              onPressed: () {
                Navigator.of(context).pop();
                Future.delayed(const Duration(milliseconds: 100), () {
                  runApp(MyApp());
                });
                runApp(MyApp());
              }, icon: const Icon(Icons.done, color: Colors.white, size: 34,),
            ),
          ],



        );
      },
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

        if (FirebaseAuth.instance.currentUser != null) saveToFireStore();



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

