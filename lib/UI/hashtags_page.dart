import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../TaskCard.dart';
import 'TaskView.dart';

class HashtagsPage extends StatelessWidget {
  const HashtagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    int tagCount = 0;
    String currentTag = '';

return

  StreamBuilder<QuerySnapshot>(
    stream: db
        .collection('users')
        .doc(user?.uid)
        .collection('tasks').snapshots(),

    builder: (context, snapshot) {
      if (snapshot.hasData) {
        return ListView.builder(
          itemCount: snapshot.data!.docs.length,
          itemBuilder: (context, index) {
            DocumentSnapshot task = snapshot.data!.docs[index];
            if (task['hashtag'] != currentTag) {
              currentTag = task['hashtag'];
              tagCount++;
              return Column(
                children: [
                  Text(currentTag),
                  TaskCard(
                      task['description'], task['isToday'], task['completed'], task.id, task['hashtag']),
                ],
              );
            } else {
              return TaskCard(
                  task['description'], task['isToday'], task['completed'], task.id, task['hashtag']);
            }
          },
        );
      }
      return Center(child: CircularProgressIndicator());
    },
  );



  }
}

