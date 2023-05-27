import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/global.dart';
import '../TaskCard.dart';
import 'doneTag.dart';

class TagView extends StatelessWidget {
  final Query query;
  final String tag;

  TagView(
      {super.key,
      required this.tag,
      required this.db,
      this.user,
      required this.query});

  final FirebaseFirestore db;
  final User? user;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        StreamBuilder<QuerySnapshot>(
          stream: query.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data!.docs.length == 0) {
                return SingleChildScrollView(
                  child: Opacity(
                    opacity: 0.43,
                    child: DoneTagPage(
                      tag: tag.toString(),
                    ),
                  ),
                );
              }

              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    tagLength = snapshot.data!.docs.length;
                    DocumentSnapshot task = snapshot.data!.docs[index];
                    if ((index != snapshot.data!.docs.length - 1)) {
                      return TaskCard(
                        task['description'],
                        task['isToday'],
                        task['completed'],
                        task.id,
                        task['hashtag'],
                        task['date'].toString(),
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
                          Opacity(
                              opacity: 0.43,
                              child: DoneTagPage(
                                tag: tag.toString(),
                              )),
                        ],
                      );
                    }
                  });
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ],
    );
  }
}
