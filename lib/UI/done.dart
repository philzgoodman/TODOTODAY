import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../TaskCard.dart';
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
        .where('completed', isEqualTo: true)
        .limit(7)
        .orderBy('date', descending: true);

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 28.0),
          child: StreamBuilder<QuerySnapshot>(
            stream: query.snapshots(),
            // db.collection('users').doc(user?.uid).collection('tasks').snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot task = snapshot.data!.docs[index];
                    return TaskCard(
                        task['description'],
                        task['isToday'],
                        task['completed'],
                        task.id,
                        task['hashtag'],
                        task['date'].toString());

                  },

                );
              }
              return Center(child: CircularProgressIndicator());
            },
          ),
        ),
      ],
    );


  }
}
