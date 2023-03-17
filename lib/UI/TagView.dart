import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../TaskCard.dart';
import '../global.dart';
import 'TaskView.dart';
import 'done.dart';
import 'doneTag.dart';

class TagView extends StatefulWidget {
  String tag;

  TagView({super.key, required this.tag});

  @override
  State<TagView> createState() => _TagViewState();
}

class _TagViewState extends State<TagView> {
  @override
  Widget build(BuildContext context) {
    final dbTag = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    Query query = dbTag
        .collection('users')
        .doc(user?.uid)
        .collection('tasks')
        .where('hashtag', isEqualTo: widget.tag)
        .where('completed', isEqualTo: false)
        .orderBy('date', descending: false);



    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      // db.collection('users').doc(user?.uid).collection('tasks').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot task = snapshot.data!.docs[index];
                if ((index != snapshot.data!.docs.length - 1) ) {
                  return TaskCard(
                      task['description'],
                      task['isToday'],
                      task['completed'],
                      task.id,
                      task['hashtag'],
                      task['date'].toString());
                } else {
                  return Column(
                    children: [
                      TaskCard(
                          task['description'],
                          task['isToday'],
                          task['completed'],
                          task.id,
                          task['hashtag'].toString(),
                          task['date'].toString()),
                      SizedBox(
                        height: 300,
                        child: Opacity(opacity: 0.4, child: DoneTagPage(tag: widget.tag.toString(),)),
                      ),
                    ],
                  );
                }
              });
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
