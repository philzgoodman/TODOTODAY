import 'dart:convert';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/TodoApp.dart';
import 'package:todotoday/main.dart';
import 'UI/DocumentEditingScreen.dart';
import 'UI/TagView.dart';
import 'global.dart';

class TaskCard extends StatefulWidget {
  String description;
  bool completed = false;
  bool isToday = false;
  String id = '';
  String hashtag = '';
  bool hasDocument = false;

  String date = '';

  TaskCard(this.description, this.isToday, this.completed, this.id,
      this.hashtag, this.date, this.hasDocument,
      {super.key});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  @override
  void initState() {
    super.initState();
   widget.hasDocument = TodoApp.checkFirestoreIfHasDocument(widget.id);
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.6),
      child: Card(

        shadowColor: Colors.black,
        elevation: 1,
        color: lighten(getRandomColor(widget.date, 50)),
        child: ListTile(
          visualDensity: VisualDensity(horizontal: 0, vertical: -4),
          title: GestureDetector(
              onTap: () {
                showEditDialog();
              },
              child: Text(widget.description,
                  style: TextStyle(
                    fontSize: 14,
                  ))),
          subtitle: GestureDetector(
              onTap: () {
                openAlertDialogThatShowsTasksContainingThisTag(widget.hashtag);
              },
              child:
                  Text(widget.hashtag, style: TextStyle(color: Colors.blue))),
          trailing: Transform.scale(
            scale: 0.95,
              child:

            Transform.translate(
              offset: const Offset(5, 0),
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  SizedBox(
                    width: 56,
                    child: Checkbox(
                      value: widget.completed,
                      onChanged: (bool? value) {
                        setState(() {
                          widget.completed = value!;
                          todoApp.updateTask(widget);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 56,
                    child: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          TodoApp.deleteTaskByFirebaseId(widget.id);
                        });
                      },
                    ),
                  ),
                  SizedBox(
                    width: 56,
                    child: Switch(
                      value: widget.isToday,
                      onChanged: (bool? value) {
                        setState(() {
                          widget.isToday = value!;
                          todoApp.updateTask(widget);
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void showEditDialog() {
    FocusNode myFocusNode = FocusNode();
    TextEditingController txt = TextEditingController(text: widget.description);
    TextEditingController txt2 = TextEditingController(text: widget.hashtag);

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              Container(
                child: AlertDialog(
                  title: Text('Edit Task'),
                  backgroundColor: getRandomColor(widget.date, 50),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        maxLines: 8,
                        controller: txt,
                        onChanged: (String value) {},
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                typeBulletedListIntoTextField(txt);
                              });
                            },
                            icon: Icon(Icons.format_list_numbered),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Transform.translate(
                            offset: Offset(15, 0),
                            child: Offstage(
                                offstage: widget.hasDocument,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.task,
                                      color: Colors.grey,
                                    ))),
                          ),
                          Transform.translate(
                            offset: Offset(15, 0),
                            child: Offstage(
                                offstage: !widget.hasDocument,
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child: Icon(
                                      Icons.task,
                                      color: Colors.greenAccent,
                                    ))),
                          ),
                          Offstage(
                            offstage: widget.hasDocument,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DocumentEditingScreen(widget.id,
                                                  widget.hasDocument)));
                                });
                              },
                              child: Transform.translate(
                                offset: Offset(6, 0),
                                child: Text(
                                  'Add Word Doc',
                                  textAlign: TextAlign.right,
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Offstage(
                            offstage: !widget.hasDocument,
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              DocumentEditingScreen(widget.id,
                                                  widget.hasDocument)));
                                });
                              },
                              child: Text(
                                'Edit Attached Doc',
                                textAlign: TextAlign.right,
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        style: TextStyle(color: Colors.blue),
                        maxLines: 1,
                        controller: txt2,
                        onChanged: (String value) {
                          widget.hashtag = value.toString();
                        },
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        setState(() {
                          trimWhiteSpaceAtEndofString(txt);
                          Navigator.of(context).pop();
                        });

                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }).then((val) {
      widget.description = txt.text;
      todoApp.updateTask(widget);
      TodoApp.updateFirestoreBoolValueHasDocument(widget.id, true);
      runApp(MyApp());
    });
    ;
  }

  void openAlertDialogThatShowsTasksContainingThisTag(String hashtag) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            actions: [
              Padding(
                padding: const EdgeInsets.only(bottom: 28.0, left: 30),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Ⓧ Close',
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ],
            title: Text('Tasks with hashtag: $hashtag'),
            content: Container(
              width: MediaQuery.of(context).size.width * .9,
              child: TagView(
                tag: hashtag,
              ),
            ),
          );
        });
  }

  void trimWhiteSpaceAtEndofString(TextEditingController txt) {
    var str = txt.text;
    var newStr = '';
    for (var i = str.length - 1; i >= 0; i--) {
      if (str[i] != ' ') {
        newStr = str.substring(0, i + 1);
        break;
      }
    }
    txt.text = newStr;
  }

  void uploadStringToFirebaseStorage(TextEditingController txt) {
    var storage = FirebaseStorage.instance;
    var ref = storage.ref().child('test.txt');
    var uploadTask = ref.putString(txt.text);
    uploadTask.then((res) {
      res.ref.getDownloadURL().then((value) {});
    });
  }
}

void typeBulletedListIntoTextField(TextEditingController txt) {
  var _isBulletedList = false;
  if (_isBulletedList) {
    txt.text = txt.text + '•';
  } else {
    txt.text = txt.text + '\n•';
  }

  moveCursorToEnd(txt);
}

void moveCursorToEnd(TextEditingController txt) {
  txt.selection =
      TextSelection.fromPosition(TextPosition(offset: txt.text.length));
}

Color getRandomColor(String date, int darkAmt) {
  return darken(Colors.accents[date.hashCode % Colors.accents.length], darkAmt);
}

Color darken(Color c, [int percent = 8]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
          (c.blue * f).round())
      .withOpacity(0.8);
}

Color invertColorBy10percent(Color today1) {
  return Color.fromARGB(
      today1.alpha, today1.red + 25, today1.green + 25, today1.blue + 25);
}
