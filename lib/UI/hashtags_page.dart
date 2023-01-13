import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../TaskCard.dart';
import 'TaskView.dart';

class HashtagsPage extends StatelessWidget {
  const HashtagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;


    return StreamBuilder<QuerySnapshot>(
      stream: db
          .collection('users')
          .doc(user?.uid)
          .collection('tasks').snapshots(),

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
}
