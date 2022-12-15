import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/TileColors.dart';
import 'package:todotoday/global.dart';
import 'package:todotoday/main.dart';
import 'package:todotoday/todotask.dart';
import 'TileColors.dart' as constants;

class MessageBox extends StatefulWidget {
  MessageBox({super.key});

  @override
  State<MessageBox> createState() => _MessageBoxState();
}

class _MessageBoxState extends State<MessageBox> {
  FocusNode myFocusNode = FocusNode();

  void updateText() {
    setState(() {
      tasks.add(TodoTask(txt.text, txt.text, false, false,
          TileColors.TILECOLORS.elementAt(tasks.length)));
      txt.clear();
      for (var i = 0; i < tasks.length; i++) {
        getSubtitle(i);
      }
    });
    txt.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
        child: SizedBox(
          width: 360,
          child: Material(
            borderRadius: BorderRadius.circular(5),
            color: Colors.black87,
            shadowColor: Colors.black,
            elevation: 15,
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: TextField(
                  toolbarOptions: const ToolbarOptions(
                    copy: true,
                    cut: true,
                    paste: true,
                    selectAll: true,
                  ),
                cursorColor: Colors.deepOrangeAccent,
                  style: const TextStyle(
                    color: Colors.white,fontSize:14
                  ),
                  focusNode: myFocusNode,
                  keyboardAppearance: Brightness.dark,
                  onSubmitted: (value) {
                    setState(() {
                      updateText();
                      FocusScopeNode currentFocus = FocusScope.of(context);
                      if (!currentFocus.hasPrimaryFocus) {
                        currentFocus.unfocus();
                      }
                    });
                    setState(() {
                      runApp(MyApp());
                    });
                  },
                  textInputAction: TextInputAction.search,
                  controller: txt,
                  decoration: InputDecoration(

                    hintText: 'Enter a task',
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      onPressed: () {
                        setState(() {
                          updateText();
                          FocusScopeNode currentFocus = FocusScope.of(context);
                          if (!currentFocus.hasPrimaryFocus) {
                            currentFocus.unfocus();
                          }
                        });
                        setState(() {
                          runApp(MyApp());
                        });
                      },
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}

void getSubtitle(int i) {
  if (tasks[i].name == tasks[i].subtitle) {
    tasks[i].subtitle = "#default";
  }

  if (tasks[i].name.contains('#', 0)) {
    tasks[i].subtitle = tasks[i].name.substring(tasks[i].name.indexOf('#', 0));
    tasks[i].name = tasks[i].name.substring(0, tasks[i].name.indexOf('#', 0));
  }
}

String getSubtitle2(int i) {
  if (tasks[i].name == tasks[i].subtitle) {
    return "#default";
  } else {
    return tasks[i].subtitle;
  }
}
