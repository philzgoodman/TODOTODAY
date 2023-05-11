import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/TodoApp.dart';
import 'package:todotoday/main.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'MessageTagBox.dart';
import 'UI/DocumentEditingScreen.dart';
import 'UI/Header.dart';
import 'UI/TagView.dart';
import 'UI/hashtags_page.dart';
import 'global.dart';
import 'package:universal_html/html.dart' as html;

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
  bool hasUrl = false;
  String textPlaceholder1 = '';
  String textPlaceholder2 = '';
  String mainText = '';
  String urlText = '';

  @override
  void initState() {
    checkIfHasUrl(widget.description);
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
        child: LongPressDraggable(
          data: widget.id.toString(),
          feedback: Icon(Icons.adjust, color: getRandomColor(widget.date, 50)),
          child: Container(
            child: Card(
              shadowColor: Colors.black,
              elevation: 1,
              color: lighten(getRandomColor(widget.date, 50)),
              child: Column(
                children: [
                  ListTile(
                    visualDensity: VisualDensity(horizontal: -4, vertical: -4),
                    horizontalTitleGap: -10,
                    title: hasUrl
                        ? Transform.translate(
                            offset: const Offset(0, -2),
                            child: Wrap(
                              children: [
                                Text(textPlaceholder1,
                                    style: TextStyle(
                                      fontFamily: 'JetBrainsMono',
                                      color: Colors.white,
                                      fontSize: 13,
                                    )),
                                InkWell(
                                  onTap: () {
                                    launchURL(urlText);
                                  },
                                  child: Text(urlText,
                                      style: TextStyle(
                                          color: Colors.blue,
                                          decoration: TextDecoration.underline,
                                          fontSize: 13,
                                          fontFamily: 'JetBrainsMono')),
                                ),
                                Text(textPlaceholder2,
                                    style: TextStyle(
                                      fontFamily: 'JetBrainsMono',
                                      color: Colors.white,
                                      fontSize: 13,
                                    )),
                              ],
                            ),
                          )
                        : Transform.translate(
                            offset: const Offset(0, -2),
                            child: Text(widget.description,
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  color: Colors.white,
                                  fontSize: 13,
                                )),
                          ),
                    subtitle: Row(
                      children: [
                        GestureDetector(
                            onTap: () {
                              openAlertDialogThatShowsTasksContainingThisTag(
                                  widget.hashtag);
                            },
                            child: Text(widget.hashtag,
                                style: TextStyle(color: Colors.blue))),
                        SizedBox(width: 10),
                        Padding(
                          padding: const EdgeInsets.only(top: 3.0),
                          child: DueDateStream(widget),
                        ),
                      ],
                    ),
                    trailing: Transform.scale(
                      scale: 0.90,
                      child: Transform.translate(
                        offset: const Offset(9, 0),
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> showEditDialog() async {
    FocusNode myFocusNode = FocusNode();
    TextEditingController txt = TextEditingController(text: widget.description);
    TextEditingController txt2 = TextEditingController(text: widget.hashtag);
    String dueDate = await todoApp.getDueDate(widget).toString().split(' ')[0];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              AlertDialog(
                backgroundColor: getRandomColor(widget.date, 50),
                content: SizedBox(
                  width: MediaQuery.of(context).size.width * .8,
                  height: MediaQuery.of(context).size.height * .5,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      TextField(
                        maxLines: 10,
                        controller: txt,
                        onChanged: (String value) {},
                      ),
                      TextField(
                        style: TextStyle(color: Colors.blue),
                        maxLines: 1,
                        controller: txt2,
                        onChanged: (String value) {
                          widget.hashtag = value.toString();
                        },
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
                              child: Text('COPY TO TODAY',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                  )),
                            ),
                          ),
                          Column(
                            children: [
                              IconButton(
                                onPressed: () {
                                  setState(() {
                                    openCalendarDatePicker(context, widget);
                                  });
                                },
                                icon: Icon(Icons.calendar_month),
                              ),
                              DueDateStream(widget),
                            ],
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          DocumentEditingScreen(
                                              id: widget.id)));
                            },
                            icon: Icon(
                              Icons.attach_file,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                actions: [
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
        return AlertDialog(
          elevation: 0,
          backgroundColor: getRandomColor(hashtag, 70),
          insetPadding: EdgeInsets.zero,
          contentPadding: EdgeInsets.zero,
          content: SizedBox(
            width: MediaQuery.of(context).size.width * .9,
            child: Container(
              height: MediaQuery.of(context).size.height * 1,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Align(
                        alignment: Alignment.topCenter,
                        child: SizedBox(
                          height: MediaQuery.of(context).size.height * .06,
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
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                deleteTagGroup(hashtag);
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
                                deleteCompletedTasks(hashtag);
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
                      width: MediaQuery.of(context).size.width * .9,
                      height: MediaQuery.of(context).size.height * .95,
                      child: TagView(
                        tag: hashtag,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: MessageTagBox(hashtag, 0),
                  ),
                ],
              ),
            ),
          ),
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

  String getFirstLinkContainingHttp(String description) {
    var urlText = '';
    var url = '';
    var urlList = description.split(' ');
    for (var i = 0; i < urlList.length; i++) {
      if (urlList[i].contains('http')) {
        url = urlList[i];
        break;
      }
    }
    urlText = url;
    return urlText;
  }

  void checkIfHasUrl(String description) {
    var fullText = '';
    var stringList = [];
    if (description.contains('http') || description.contains('https')) {
      hasUrl = true;

      urlText = getFirstLinkContainingHttp(description);
      fullText = description.replaceAll(urlText, '~~~');
      stringList = fullText.split('~~~');
      textPlaceholder1 = stringList[0];
      textPlaceholder2 = stringList[1];
    } else {
      hasUrl = false;
    }
  }

  void htmlOpenLink(String url) {
    if (kIsWeb) html.window.open(url, 'new tab');
  }

  void launchURL(String urlText) {
    if (kIsWeb) {
      htmlOpenLink(urlText);
    } else {
      launchUrlString(urlText);
    }
  }

  void openCalendarDatePicker(BuildContext context, TaskCard widget) {
    var dueDate = todoApp.getDueDate(widget);

    showDatePicker(
      currentDate: dueDate,
      context: context,
      initialDate: dueDate,
      firstDate: DateTime(dueDate.year - 2),
      lastDate: DateTime(dueDate.year + 2),
    ).then((date) {
      if (date != null) {
        setState(() {
          todoApp.addDueDate(widget, date);
        });
      }
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
}

class DueDateStream extends StatelessWidget {
  Widget widget;

  DueDateStream(this.widget);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: todoApp.getDueDateStream(widget),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Text(
            snapshot.data.toString().split(' ')[0],
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          );
        } else {
          return Text(
            '',
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          );
        }
      },
    );
  }
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
