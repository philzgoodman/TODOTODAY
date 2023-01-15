import 'package:flutter/material.dart';
import 'global.dart';
import 'task.dart';

class TaskCard extends StatefulWidget {
  String description;
  bool completed = false;
  bool isToday = false;
  String id = '';
  String hashtag = '';

  DateTime date;

  TaskCard(this.description, this.isToday, this.completed, this.id, this.hashtag, this.date, {super.key});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: GestureDetector(
          onTap: () {
         showEditDialog();
            },
            child: Text(widget.description)),
        subtitle: Text(widget.hashtag,
            style: TextStyle(
                color: Colors.blue)),
        trailing: Wrap(
          crossAxisAlignment:  WrapCrossAlignment.center,

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
                todoApp.deleteTask(widget.date);
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

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Edit Task'),
            content: TextField(
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
          );
        });


  }
}
