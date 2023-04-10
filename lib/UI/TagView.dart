import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:todotoday/global.dart';
import '../TaskCard.dart';

import '../TodoApp.dart';
import '../main.dart';
import 'doneTag.dart';

class TagView extends StatefulWidget {
  String tag;

  TagView({super.key, required this.tag});

  @override
  State<TagView> createState() => _TagViewState();
}

class _TagViewState extends State<TagView> {
  var calculatorValue = 0;
  var calcVisible = false;
  Color selected = Colors.lightBlueAccent;
  Color unselected = Color(0xff537E9FFF);
  int index = 1;

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
      clipBehavior: Clip.none,
      children: [
        StreamBuilder<QuerySnapshot>(
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
                      bool onWillAccept = false;

                      return DragTarget(
                        onWillAccept: (data) {
                          print("onWillAccept");
                          onWillAccept = true;
                          return true;
                        },
                        onLeave: (data) {
                          print("onLeave");
                          onWillAccept = false;
                        },
                        onAccept: (data) {
                          print("onAccept");
                          TodoApp().setDateTimeofTaskTo1SecondAfter(
                              task.id, data.toString());
                        },
                        builder: (BuildContext context,
                            List<Object?> candidateData,
                            List<dynamic> rejectedData) {
                          return Opacity(
                            opacity: onWillAccept ? 0.5 : 1.0,
                            child: TaskCard(
                              task['description'],
                              task['isToday'],
                              task['completed'],
                              task.id,
                              task['hashtag'],
                              task['date'].toString(),
                            ),
                          );
                        },
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
                            child: Opacity(
                                opacity: 0.1,
                                child: DoneTagPage(
                                  tag: widget.tag.toString(),
                                )),
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
          bottom: 210,
          left: 0,
          child: IconButton(
            color: calcVisible ? selected : unselected,
            onPressed: () {
              setState(() {
                calcVisible = !calcVisible;
              });
            },
            icon: Icon(Icons.calculate),
          ),
        ),
        Visibility(
          visible: calcVisible,
          child: Positioned(
            bottom: 160,
            left: 10,
            child: StreamBuilder<int>(
                stream: getCalculatorStream(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    calculatorValue = snapshot.data!;
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0, left: 5.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: index == 1 ? selected : unselected,
                          ),
                          onPressed: () {
                            setState(() {
                              sumList(widget.tag);
                              index = 1;
                            });
                          },
                          child: Text(
                            "SUM",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: index == 2 ? selected : unselected,
                          ),
                          onPressed: () {
                            setState(() {
                              multiplyList(widget.tag);
                              index = 2;
                            });
                          },
                          child: Text(
                            "MULTIPLY",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 18.0),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: index == 3 ? selected : unselected,
                          ),
                          onPressed: () {
                            setState(() {
                              getTaskCount(widget.tag);
                              index = 3;
                            });
                          },
                          child: Text(
                            "COUNT",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            "Result:",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            calculatorValue.toString(),
                            style: TextStyle(
                              color: Colors.yellowAccent,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  );
                }),
          ),
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
          itemsWithNumbers
              .add(getOnlyNumbersAndSpaces(value.docs[i]['description']));
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
    var onlyNumbers = doc.replaceAll(RegExp(r"[^0-9]"), "");
    return onlyNumbers;
  }

  void multiplyList(String tag) {
    int product = 1;
    int num = 1;
    int sum = 0;

    List<int> itemsWithNumbers = [];

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
          itemsWithNumbers.add(
              int.parse(getOnlyNumbersAndSpaces(value.docs[i]['description'])));
        }
      }
      for (int i = 0; i < itemsWithNumbers.length; i++) {
        product = multiplyItemsInList(itemsWithNumbers);
      }
      setState(() {
        calculatorResult = product;
      });
    });
  }

  int multiplyItemsInList(List<int> itemsWithNumbers) {
    int product = 1;
    for (int i = 0; i < itemsWithNumbers.length; i++) {
      product = product * itemsWithNumbers[i];
    }
    return product;
  }

  void getTaskCount(String tag) {
    int count = 0;

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
        count++;
      }
      setState(() {
        calculatorResult = count;
      });
    });
  }
}
