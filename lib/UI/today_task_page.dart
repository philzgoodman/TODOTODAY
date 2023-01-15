
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/task.dart';

import '../TaskCard.dart';
import '../TodoApp.dart';
import '../global.dart';
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
        .where('isToday', isEqualTo: true);

    return TaskView(db: dbToday, user: user, query: query,);
  }

}

