import 'package:flutter/material.dart';
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
    return Card(
      shadowColor: Colors.black,
      elevation: 3,
      color: getRandomColor(widget.date, 50),
      child: ListTile(
        visualDensity: VisualDensity(horizontal: 0, vertical: -4),
        title: GestureDetector(
            onTap: () {
              showEditDialog();
            },
            child: Text(widget.description)),
        subtitle: Text(widget.hashtag, style: TextStyle(color: Colors.blue)),
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
                  todoApp.deleteTask(widget.date);
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
    );
  }

  void showEditDialog() {
    FocusNode myFocusNode = FocusNode();
    TextEditingController txt = TextEditingController();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Stack(
            children: [
              AlertDialog(
                title: Text('Edit Task'),
                content: TextField(
                  maxLines: 8,
                  controller: TextEditingController(text: widget.description),
                  onChanged: (String value) {
                    widget.description = value;
                  },
                ),
                actions: [
                  TextButton(
                    child: Text('Cancel'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text('Save'),
                    onPressed: () {
                      todoApp.updateTask(widget);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          );
        });
  }
}

Color getRandomColor(String date, int darkAmt) {
  return darken(Colors.accents[date.hashCode % Colors.accents.length], darkAmt);
}

Color darken(Color c, [int percent = 10]) {
  assert(1 <= percent && percent <= 100);
  var f = 1 - percent / 100;
  return Color.fromARGB(c.alpha, (c.red * f).round(), (c.green * f).round(),
          (c.blue * f).round())
      .withOpacity(0.8);
}
