import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../TaskCard.dart';

class DoneTagPage extends StatefulWidget {
  final String tag;

  const DoneTagPage({super.key, required this.tag});

  @override
  State<DoneTagPage> createState() => _DoneTagPageState();
}

class _DoneTagPageState extends State<DoneTagPage> {
  Query query = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('tasks')
      .where('completed', isEqualTo: true);

  @override
  Widget build(BuildContext context) {
    Query query2 = query.where('hashtag', isEqualTo: widget.tag);
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: query2.snapshots(),
              // db.collection('users').doc(user?.uid).collection('tasks').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      DocumentSnapshot task = snapshot.data!.docs[index];
                      return TaskCard(
                        task['description'],
                        task['isToday'],
                        task['completed'],
                        task.id,
                        task['hashtag'],
                        task['date'].toString(),
                      );
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
