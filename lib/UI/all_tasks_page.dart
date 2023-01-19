import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'TaskView.dart';

class AllTasksPage extends StatefulWidget {
  const AllTasksPage({Key? key}) : super(key: key);

  @override
  State<AllTasksPage> createState() => _AllTasksPageState();
}

class _AllTasksPageState extends State<AllTasksPage> {
  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    Query query = db
        .collection('users')
        .doc(user?.uid)
        .collection('tasks')
        .where(
          'completed',
          isEqualTo: false,
        )
        .orderBy('date', descending: false);

    return Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF73ADAD),
              Color(0xFF9799F9),
              Color(0xFF986291),
            ],
          ),
        ),
        child: TaskView(
          db: db,
          user: user,
          query: query,
        ));
  }
}
