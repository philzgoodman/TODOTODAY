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

        StreamBuilder< int>(
          stream: getCalculatorStream(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              calculatorValue = snapshot.data!;
            }
            return Positioned(
              bottom: 10,
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
            );
          }
        ),

      ],
    );

  }

  void sumList(String tag) {
    int? sum = 0;
    int? num = 0;

    List itemsWithNumbers = [];

    final dbTag = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    Query query = dbTag
        .collection('users')
        .doc(user?.uid)
        .collection('tasks')
        .where('hashtag', isEqualTo: tag)
        .where('completed', isEqualTo: false);

    query.get().then((value) {



      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i]['description'].contains(RegExp(r'[0-9]')) != false) {
          itemsWithNumbers.add(getOnlyNumbersAndSpaces(value.docs[i]['description']));
        }
      }
      for (int i = 0; i < itemsWithNumbers.length; i++) {
        num = int.parse(itemsWithNumbers[i]);
        sum = sum! + num!;
      }

      setState(() {
        calculatorResult = sum!;
      });

    });
  }

  getCalculatorStream() {
    return Stream<int>.periodic(Duration(seconds: 0), (x) {
      return calculatorResult;
    });
  }

  getOnlyNumbersAndSpaces(doc) {
    return doc.replaceAll(RegExp(r'[^0-9 ]'), '');
  }




}































