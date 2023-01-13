
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
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

    @override
    Widget build(BuildContext context) {
      return StreamBuilder<QuerySnapshot>(
        stream: db
            .collection('users')
            .doc(user?.uid)
            .collection('tasks')
            .where('isToday', isEqualTo: true)
            .snapshots(),

        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot task = snapshot.data!.docs[index];
                return TaskCard(
                    task['description'], task['isToday'], task['completed'], task.id);
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },


      );
    }



  }

