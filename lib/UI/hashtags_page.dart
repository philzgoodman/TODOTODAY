import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todotoday/MessageTagBox.dart';
import 'package:todotoday/UI/TagView.dart';
import 'package:todotoday/main.dart';
import '../TaskCard.dart';
import '../global.dart';
import 'Header.dart';

class HashtagsPage extends StatelessWidget {
  HashtagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    List<String> subtitles = [];
    List<String> uniqueSubtitles = [];

    Query query = db.collection('users').doc(user?.uid).collection('tasks');

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        subtitles.clear();
        uniqueSubtitles.clear();
        if (snapshot.hasData) {
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            if (snapshot.data!.docs[i]['hashtag'] != null) {
              subtitles.add(snapshot.data!.docs[i]['hashtag']);
            }
          }
          uniqueSubtitles = subtitles.toSet().toList();

          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  hash1,
                  hash2,
                  hash3,
                ],
              ),
            ),child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.5,
              ),
              shrinkWrap: true,
              itemCount: uniqueSubtitles.length,
              itemBuilder: (context, index) {
                return Center(
                  child: InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            elevation: 0,
                            backgroundColor:
                            getRandomColor(uniqueSubtitles[index], 70),
                            insetPadding: EdgeInsets.zero,
                            contentPadding: EdgeInsets.zero,
                            content: SizedBox(
                              width: MediaQuery
                                  .of(context)
                                  .size
                                  .width * .9,
                              child: Container(
                                height: MediaQuery
                                    .of(context)
                                    .size
                                    .height * 1,
                                child: Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Align(
                                          alignment: Alignment.topCenter,
                                          child: SizedBox(
                                            height: MediaQuery
                                                .of(context)
                                                .size
                                                .height *
                                                .06,
                                            child: Center(
                                              child: Text(
                                                uniqueSubtitles[index].toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 13,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,

                                          crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                          children: [
                                            Transform.scale(
                                              scale: .7,
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.blue,
                                                ),
                                                onPressed: () {
                                                  duplicateTaskTodoToday(
                                                      uniqueSubtitles[index]);
                                                },
                                                child: Text('COPY LIST TO TODAY',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 9,
                                                    )),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Transform.scale(
                                              scale: .7,
                                              child: TextButton(
                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.teal,
                                                ),
                                                onPressed: () {
                                                  deleteTagGroup(
                                                      uniqueSubtitles[index]);
                                                },
                                                child: Text('DELETE TAG GROUP',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 9,
                                                    )),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Transform.scale(
                                              scale: .7,
                                              child: TextButton(

                                                style: TextButton.styleFrom(
                                                  backgroundColor: Colors.purple,
                                                ),
                                                onPressed: () {
                                                  deleteCompletedTasks(
                                                      uniqueSubtitles[index]);
                                                },
                                                child: Text('DELETE DONE TASKS',
                                                    style: TextStyle(

                                                      color: Colors.white,
                                                      fontSize: 9,
                                                    )),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Header(), ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 138.0),
                                      child: SizedBox(
                                        width: MediaQuery
                                            .of(context)
                                            .size
                                            .width *
                                            .9,
                                        height:
                                        MediaQuery
                                            .of(context)
                                            .size
                                            .height *
                                            .95,
                                        child: TagView(
                                          tag: uniqueSubtitles[index],
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      child: MessageTagBox(
                                          uniqueSubtitles[index], index),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            actions: [
                              Padding(
                                padding:
                                const EdgeInsets.only(bottom: 28.0, left: 30),
                                child: Center(
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text(
                                      'Ⓧ Close',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ).then((val) {
                        finished();
                      });

                    },
                    child: Card(
                      color: darken(getRandomColor(uniqueSubtitles[index], 50)),
                      elevation: 2,
                        shadowColor: Colors.grey,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Text(
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                textAlign: TextAlign.center,
                                uniqueSubtitles[index],
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              textAlign: TextAlign.center,
                              subtitles
                                  .where((element) =>
                              element == uniqueSubtitles[index])
                                  .length
                                  .toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        } else {
          subTitleCount.clear();
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void finished() {
    runApp(MyApp());
  }



}
void showToast(String s) {
  Fluttertoast.showToast(
      msg: s,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0);
}


void duplicateTaskTodoToday(String tag) {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  Query query = db
      .collection('users')
      .doc(user?.uid)
      .collection('tasks')
      .where('hashtag', isEqualTo: tag);

  query.get().then((value) {
    for (int i = 0; i < value.docs.length; i++) {
      DocumentSnapshot task = value.docs[i];
      db.collection('users').doc(user?.uid).collection('tasks').add({
        'description': task['description'],
        'isToday': true,
        'completed': false,
        'hashtag': '#default',
        'date': DateTime.now().add(Duration(seconds: i)).toString(),
      });
    }
  });

  showToast(
      'Copied tasks to do today. Note: Hashtag of new tasks are set to #default.');
}


void deleteTagGroup(String uniqueSubtitle) {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  Query query = db
      .collection('users')
      .doc(user?.uid)
      .collection('tasks')
      .where('hashtag', isEqualTo: uniqueSubtitle);

  query.get().then((value) {
    for (int i = 0; i < value.docs.length; i++) {
      DocumentSnapshot task = value.docs[i];
      db
          .collection('users')
          .doc(user?.uid)
          .collection('tasks')
          .doc(task.id)
          .delete();
    }
  });
}

void deleteCompletedTasks(String uniqueSubtitle) {
  final db = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  Query query = db
      .collection('users')
      .doc(user?.uid)
      .collection('tasks')
      .where('hashtag', isEqualTo: uniqueSubtitle)
      .where('completed', isEqualTo: true);

  query.get().then((value) {
    for (int i = 0; i < value.docs.length; i++) {
      DocumentSnapshot task = value.docs[i];
      db
          .collection('users')
          .doc(user?.uid)
          .collection('tasks')
          .doc(task.id)
          .delete();
    }
  });
}
