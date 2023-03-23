import 'package:flutter/material.dart';
import 'package:todotoday/TodoApp.dart';
import 'package:todotoday/main.dart';
import 'MessageTagBox.dart';
import 'UI/DocumentEditingScreen.dart';
import 'UI/Header.dart';
import 'UI/TagView.dart';
import 'UI/hashtags_page.dart';
import 'global.dart';

class TaskCard extends StatefulWidget {
  String description;
  bool completed = false;
  bool isToday = false;
  String id = '';
  String hashtag = '';

  String date = '';

  TaskCard(this.description, this.isToday, this.completed, this.id,
      this.hashtag, this.date,
      {super.key});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.6),
      child: GestureDetector(
        onTap: () {
          showEditDialog();
        },
        child: Card(

          shadowColor: Colors.black,
          elevation: 1,
          color: lighten(getRandomColor(widget.date, 50)),
          child: ListTile(
            visualDensity: VisualDensity(horizontal: 0, vertical: -4),
            title: Text(widget.description,
                style: TextStyle(
                  fontSize: 14,
                )),
            subtitle: GestureDetector(
                onTap: () {
                  openAlertDialogThatShowsTasksContainingThisTag(
                      widget.hashtag);
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 1.1,
                child: AlertDialog(


                  backgroundColor: getRandomColor(widget.date, 50),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Transform.scale(
                        scale: .7,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.blue,
                          ),
                          onPressed: () {
                            TodoApp().copyTaskTodoToday(widget.description);
                            showToast(
                                'Copied tasks to do today. Note: Hashtag of new tasks are set to #default.');
                          },
                          child: Text('COPY LIST TO TODAY',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                              )),
                        ),
                      ),
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

                          SizedBox(
                            width: 70,
                            child: TextButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            DocumentEditingScreen(
                                                id: widget.id)));
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
                        maxLines: 8,
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
      runApp(MyApp());
    });
    ;
  }

  void openAlertDialogThatShowsTasksContainingThisTag(String hashtag) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return
          AlertDialog(
            elevation: 0,
            backgroundColor:
            getRandomColor(hashtag, 70),
            insetPadding: EdgeInsets.zero,
            contentPadding: EdgeInsets.zero,
            content: SizedBox(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * .9,
              child: Container(
                height: MediaQuery
                    .of(context)
                    .size
                    .height * 1,
                child: Stack(
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topCenter,
                          child: SizedBox(
                            height: MediaQuery
                                .of(context)
                                .size
                                .height *
                                .06,
                            child: Center(
                              child: Text(
                                hashtag.toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment
                              .center,

                          crossAxisAlignment: CrossAxisAlignment
                              .center,
                          children: [
                            Transform.scale(
                              scale: .7,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () {
                                  duplicateTaskTodoToday(
                                      hashtag);
                                },
                                child: Text('COPY LIST TO TODAY',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Transform.scale(
                              scale: .7,
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.teal,
                                ),
                                onPressed: () {
                                  deleteTagGroup(
                                      hashtag);
                                },
                                child: Text('DELETE TAG GROUP',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 9,
                                    )),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Transform.scale(
                              scale: .7,
                              child: TextButton(

                                style: TextButton.styleFrom(
                                  backgroundColor: Colors.purple,
                                ),
                                onPressed: () {
                                  deleteCompletedTasks(
                                      hashtag
                                  );
                                },
                                child: Text('DELETE DONE TASKS',
                                    style: TextStyle(

                                      color: Colors.white,
                                      fontSize: 9,
                                    )),
                              ),
                            ),
                          ],
                        ),
                        Header(),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 138.0),
                      child: SizedBox(
                        width: MediaQuery
                            .of(context)
                            .size
                            .width *
                            .9,
                        height:
                        MediaQuery
                            .of(context)
                            .size
                            .height *
                            .95,
                        child: TagView(
                          tag: hashtag,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: MessageTagBox(
                          hashtag, 0),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              Padding(
                padding:
                const EdgeInsets.only(bottom: 28.0, left: 30),
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
          );
      },
    ).then((val) {});
    ;
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
          (c.blue * f).round());

}

Color invertColorBy10percent(Color today1) {
  return Color.fromARGB(
      today1.alpha, today1.red + 25, today1.green + 25, today1.blue + 25);
}

