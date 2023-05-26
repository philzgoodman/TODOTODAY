import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../MessageBox.dart';
import '../global.dart';
import 'Header.dart';
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
    return Stack(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  make20percentLessSaturated(all1),
                  make20percentLessSaturated(all2),
                  make20percentLessSaturated(all3),
                ],
              ),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 13.0),
                child: TaskView(
                  db: db,
                  user: user,
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

  make20percentLessSaturated(Color all1) {
    return Color.fromARGB(
      all1.alpha,
      all1.red - 20,
      all1.green - 20,
      all1.blue - 20,
    );
  }
}
