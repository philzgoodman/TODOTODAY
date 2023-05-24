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
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                if (snapshot.data!.docs.length == 0) {
                  return SingleChildScrollView(
                    child: Opacity(opacity: 0.43, child: DonePage()),
                  );
                }

                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot task = snapshot.data!.docs[index];
                      if ((index != snapshot.data!.docs.length - 1)) {
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
                          ],
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
                            ),
                            Opacity(opacity: 0.43, child: DonePage()),
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
