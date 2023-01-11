import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todotoday/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'TodoApp.dart';

class AllTasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final auth = FirebaseAuth.instance;
    return Scaffold(
      body: StreamBuilder<List<Task>>(
        stream: FirebaseFirestore.instance
            .collection('tasks')
            .doc(auth.currentUser?.uid)
            .collection('tasks')
            .snapshots()
            .map((snapshot) => snapshot.docs
            .map((doc) => Task.fromFirestore(doc))
            .toList()),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          var tasks = snapshot.data;
          return ListView.builder(
              itemCount: tasks?.length,
              itemBuilder: (context, index) {
                if (tasks != null) {
                  var task = tasks[index];
                  return ListTile(
                    title: Text(task.description),
                    trailing: Checkbox(
                      value: task.completed,
                      onChanged: (bool? value) {
                        task.completed = value!;
                        TodoApp().updateTask(task);
                      },
                    ),
                  );
                } else {
                  return Text("No tasks");
                }
              });
        },
      ),
    );
  }
}
