import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../MessageBox.dart';
import '../global.dart';
import 'Header.dart';
import 'TaskView.dart';

class TodayTaskPage extends StatelessWidget {
  TodayTaskPage({super.key});

  @override
  Widget build(BuildContext context) {
    final dbToday = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    Query query = dbToday
        .collection('users')
        .doc(user?.uid)
        .collection('tasks')
        .where('isToday', isEqualTo: true)
        .where('completed', isEqualTo: false)
        .orderBy('date', descending: false);

    return Stack(
      children: [
        Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  today1,
                  today2,
                  today3,
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: TaskView(
                db: dbToday,
                user: user,
                query: query,
              ),
            )),
        Header(),
        Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: MessageBox(),
        ),
      ],
    );
  }
}
