import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../TaskCard.dart';

class TaskView extends StatelessWidget {
  Query query;

  TaskView({
    Key? key,
    required this.db,
    required this.user,
    required this.query,
  }) : super(key: key);

  final FirebaseFirestore db;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      // db.collection('users').doc(user?.uid).collection('tasks').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              DocumentSnapshot task = snapshot.data!.docs[index];
              return TaskCard(
                  task['description'],
                  task['isToday'],
                  task['completed'],
                  task.id,
                  task['hashtag'],
                  task['date'].toString());
            },
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
