import 'package:flutter/material.dart';
import 'global.dart';
import 'task.dart';

class TaskCard extends StatefulWidget {
  String description;
  bool completed = false;
  bool isToday = false;
  String id = '';
  String hashtag = '';

  TaskCard(this.description, this.isToday, this.completed, this.id, this.hashtag, {super.key});

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(widget.description),
        subtitle: Text(widget.hashtag),
        trailing: Wrap(
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
                todoApp.deleteTask(widget.description);
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
}
