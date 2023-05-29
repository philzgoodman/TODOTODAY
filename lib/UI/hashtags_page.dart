import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:todotoday/MessageTagBox.dart';
import 'package:todotoday/UI/TagView.dart';
import '../MessageBox.dart';
import '../TaskCard.dart';
import '../global.dart';
import 'Header.dart';

class HashtagsPage extends StatelessWidget {
  HashtagsPage({super.key});

  List<String> subtitles = [];
  List<String> uniqueSubtitles = [];
  Query query = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('tasks');

  @override
  Widget build(BuildContext context) {
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
          uniqueSubtitles.sort();

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
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                ListView(
                  children: [
                    Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: 900,
                        ),
                        child: GridView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 3,
                                  crossAxisSpacing: 2,
                                  mainAxisSpacing: 2,
                                  childAspectRatio: 2),
                          itemCount: uniqueSubtitles.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Center(
                                child: InkWell(
                                  onTap: () {
                                    Query tagQuery = FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(FirebaseAuth
                                            .instance.currentUser?.uid)
                                        .collection('tasks')
                                        .where('completed', isEqualTo: false)
                                        .where('hashtag',
                                            isEqualTo: uniqueSubtitles[index])
                                        .limit(30)
                                        .orderBy('date', descending: false);
                                    openAlertDialogThatShowsTasksContainingThisTag(
                                        uniqueSubtitles[index], context);
                                  },
                                  child: Card(
                                    color: getRandomColor(
                                        uniqueSubtitles[index], 40),
                                    elevation: 3,
                                    shadowColor: Colors.black,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.center,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Color(0xff0000007A),
                                            Color(0xff00000034),
                                          ],
                                        ),
                                      ),
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 8.0),
                                              child: Text(
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 1,
                                                textAlign: TextAlign.center,
                                                uniqueSubtitles[index],
                                                style: TextStyle(
                                                  color: Colors.lightBlueAccent,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ),
                                            Text(
                                              textAlign: TextAlign.center,
                                              subtitles
                                                  .where((element) =>
                                                      element ==
                                                      uniqueSubtitles[index])
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
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 150,
                    ),
                  ],
                ),
                MessageBox(),
              ],
            ),
          );
        } else {
          subTitleCount.clear();
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void finished() {}
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

  query.get(GetOptions(source: Source.cache)).then((value) {
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

  query.get(GetOptions(source: Source.cache)).then((value) {
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
