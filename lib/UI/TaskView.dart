import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:todotoday/UI/done.dart';

import '../TaskCard.dart';
import '../TodoApp.dart';
import '../main.dart';

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
      clipBehavior: Clip.none,
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
                        bool onWillAccept = false;

                        return DragTarget(
                          onWillAccept: (data) {
                            print("onWillAccept");
                            onWillAccept = true;
                            return true;
                          },
                          onLeave: (data) {
                            print("onLeave");
                            onWillAccept = false;
                          },
                          onAccept: (data) {
                            print("onAccept");
                            TodoApp().setDateTimeofTaskTo1SecondAfter(
                                task.id, data.toString());
                          },
                          builder: (BuildContext context,
                              List<Object?> candidateData,
                              List<dynamic> rejectedData) {
                            return Opacity(
                              opacity: onWillAccept ? 0.5 : 1.0,
                              child: TaskCard(
                                task['description'],
                                task['isToday'],
                                task['completed'],
                                task.id,
                                task['hashtag'],
                                task['date'].toString(),
                              ),
                            );
                          },
                        );
                      } else if (snapshot.data!.docs.length == 0) {
                        return Opacity(opacity: 0.33, child: DonePage());
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
                            ),
                            Opacity(opacity: 0.33, child: DonePage()),
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
