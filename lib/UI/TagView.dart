import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todotoday/global.dart';
import '../TaskCard.dart';

import 'doneTag.dart';

class TagView extends StatefulWidget {
  String tag;

  TagView({super.key, required this.tag});

  @override
  State<TagView> createState() => _TagViewState();
}

class _TagViewState extends State<TagView> {
  var calculatorValue = 0;
  @override
  Widget build(BuildContext context) {


    final dbTag = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    Query query = dbTag
        .collection('users')
        .doc(user?.uid)
        .collection('tasks')
        .where('hashtag', isEqualTo: widget.tag)
        .where('completed', isEqualTo: false)
        .orderBy('date', descending: false);


    return Stack(
      children:
      [ StreamBuilder<QuerySnapshot>(
        stream: query.snapshots(),
        // db.collection('users').doc(user?.uid).collection('tasks').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  tagLength = snapshot.data!.docs.length;
                  DocumentSnapshot task = snapshot.data!.docs[index];
                  if ((index != snapshot.data!.docs.length - 1)) {
                    return TaskCard(
                      task['description'],
                      task['isToday'],
                      task['completed'],
                      task.id,
                      task['hashtag'],
                      task['date'].toString(),
                    );
                  } else {
                    return Column(
                      children: [
                        TaskCard(
                          task['description'],
                          task['isToday'],
                          task['completed'],
                          task.id,
                          task['hashtag'].toString(),
                          task['date'].toString(),


                        ),
                        SizedBox(
                          height: 300,
                          child: Opacity(opacity: 0.1,
                              child: DoneTagPage(tag: widget.tag.toString(),)),
                        ),
                      ],
                    );
                  }
                });
          }
          return Center(child: CircularProgressIndicator());
        },
      ),

        Positioned(
          bottom: 40,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    sumList(widget.tag);

                  });

                },
        child: Text("Sum List", style: TextStyle(
          color: Colors.white,
        ),),
              ),
              Text(calculatorValue.toString(), style: TextStyle(
                color: Colors.white,
                fontSize: 30,
              ),),


            ],
          ),
        ),

      ],
    );

  }

  void sumList(String tag) {
    int? sum = 0;
    int? num = 0;
    final dbTag = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    Query query = dbTag
        .collection('users')
        .doc(user?.uid)
        .collection('tasks')
        .where('hashtag', isEqualTo: tag)
        .where('completed', isEqualTo: false)
        .orderBy('date', descending: false);

    query.get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        num = int.tryParse(value.docs[i]['description'])?.toInt();
        if (num != null) {
          sum = sum! + num!;
        }
      }
      calculatorValue = sum!;
      print(calculatorResult);
    });
  }




}































