import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/UI/done.dart';

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
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: query.snapshots(),
            // db.collection('users').doc(user?.uid).collection('tasks').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot task = snapshot.data!.docs[index];
                      if ((index != snapshot.data!.docs.length - 1) &&
                          (snapshot.data!.docs[index]['hashtag'] != null)) {
                        return TaskCard(
                            task['description'],
                            task['isToday'],
                            task['completed'],
                            task.id,
                            task['hashtag'],
                            task['date'].toString(),
                            task['hasDocument'],
                        );
                      } else {
                        return Column(
                          children: [
                            TaskCard(
                                task['description'],
                                task['isToday'],
                                task['completed'],
                                task.id,
                                task['hashtag'].toString(),
                                task['date'].toString(),
                                task['hasDocument'],

                            )

                            ,
                            SizedBox(
                              height: 300,
                              child: Opacity(opacity: 0.4, child: DonePage()),
                            ),
                          ],
                        );
                      }
                    });
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );
  }
}
