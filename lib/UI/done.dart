import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../TaskCard.dart';
import '../global.dart';
import 'TaskView.dart';

class DonePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final dbDone = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    Query query = dbDone
        .collection('users')
        .doc(user?.uid)
        .collection('tasks')
        .where('completed', isEqualTo: true);

    return TaskView(
      db: dbDone,
      user: user,
      query: query,
    );
  }
}
