import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        .where('completed', isEqualTo: false);

    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFB0BD8A),
              Color(0xFF356C40),
              Color(0xFF34574A),
            ],
          ),
        ),
        child: TaskView(
          db: dbToday,
          user: user,
          query: query,
        ));
  }
}
