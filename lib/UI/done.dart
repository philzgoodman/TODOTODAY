import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../TaskCard.dart';

class DonePage extends StatefulWidget {
   const DonePage({Key? key}) : super(key: key);

  @override
  State<DonePage> createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
      Stream<QuerySnapshot<Object?>> stream =  FirebaseFirestore.instance
       .collection('users')
       .doc(FirebaseAuth.instance.currentUser?.uid)
       .collection('tasks')
       .where('completed', isEqualTo: true)
       .limit(12)
       .orderBy('date', descending: true)
       .snapshots();

  @override
  Widget build(BuildContext context) {


    return Container(
      height: MediaQuery.of(context).size.height * 1.2,
      constraints: BoxConstraints(
        maxWidth: 900,
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 28.0),
            child: StreamBuilder<QuerySnapshot>(
              stream: stream,
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
