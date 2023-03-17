import 'package:flutter/material.dart';
import 'package:todotoday/TodoApp.dart';
import 'package:todotoday/main.dart';
import 'UI/TagView.dart';
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.5),
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
              child: Text(widget.hashtag, style: TextStyle(color: Colors.blue))),
          trailing: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Checkbox(
                value: widget.completed,
                onChanged: (bool? value) {
                  setState(() {
                    widget.completed = value!;
                    todoApp.updateTask(widget);
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.delete),
                onPressed: () {
                  setState(() {
                    TodoApp.deleteTaskByFirebaseId(widget.id);
                  });
                },
              ),
              Switch(
                value: widget.isToday,
                onChanged: (bool? value) {
                  setState(() {
                    widget.isToday = value!;
                    todoApp.updateTask(widget);
                  });
                },
              ),
            ],
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
                        children: [
                          IconButton(
                            onPressed: () {
                              setState(() {
                                typeBulletedListIntoTextField(txt);
                              });
                            },
                            icon: Icon(Icons.format_list_numbered),
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
                        trimWhiteSpaceAtEndofString(txt);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        }).then((val) {
          if (widget.description != txt.text || widget.hashtag != txt2.text) {
            widget.description = txt.text;
            todoApp.updateTask(widget);
            runApp(MyApp());
          }

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


}

void launchWordDocEditor(TaskCard widget) {}

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
  return Color.fromARGB(today1.alpha, today1.red + 25, today1.green + 25,
      today1.blue + 25);
}
