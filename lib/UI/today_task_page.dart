import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../MessageBox.dart';
import '../global.dart';
import 'Header.dart';
import 'TaskView.dart';

class TodayTaskPage extends StatelessWidget {
  TodayTaskPage({super.key});

  final Query query = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('tasks')
      .where('isToday', isEqualTo: true)
      .where('completed', isEqualTo: false)
      .orderBy('date', descending: false);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
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
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 13.0),
                child: TaskView(
                  query: query,
                ),
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
