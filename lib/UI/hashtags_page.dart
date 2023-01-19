import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todotoday/UI/TagView.dart';

import '../TaskCard.dart';

class HashtagsPage extends StatelessWidget {
  String hashtag = '';
  String sendTag = '';
  List<String> subTitleCount = [];

  HashtagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    List<String> subtitles = [];
    List<String> uniqueSubtitles = [];
    subTitleCount = [];
    Query query = db.collection('users').doc(user?.uid).collection('tasks');

    query.get().then((QuerySnapshot querySnapshot) {
      for (var doc in querySnapshot.docs) {
        subtitles.add(doc['hashtag']);
      }

      uniqueSubtitles = subtitles.toSet().toList();

      for (int i = 0; i < uniqueSubtitles.length; i++) {
        int count = 0;
        for (int j = 0; j < subtitles.length; j++) {
          if (uniqueSubtitles[i] == subtitles[j]) {
            count++;
          }
        }
        subTitleCount.add(count.toString());
      }
    });

    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      // db.collection('users').doc(user?.uid).collection('tasks').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return GridView.builder(
            itemCount: uniqueSubtitles.length,
            itemBuilder: (context, index) {
              return Center(
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.zero,
                          contentPadding: EdgeInsets.zero,
                          content: SizedBox(
                            width:MediaQuery.of(context).size.width-100,

                            child: TagView(

                              tag: uniqueSubtitles[index],
                            ),
                          ),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.only(bottom:108.0,left:30),
                              child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text('Close'),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: SizedBox(
                    width: 150,
                    height: 150,
                    child: Card(
                      color: getRandomColor(uniqueSubtitles[index]),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              textAlign: TextAlign.center,
                              uniqueSubtitles[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                            Text(
                              subTitleCount[index],
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
