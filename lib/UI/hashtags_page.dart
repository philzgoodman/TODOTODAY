import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todotoday/UI/TagView.dart';

import '../TaskCard.dart';

class HashtagsPage extends StatelessWidget {


  HashtagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    List<String> subtitles = [];
    List<String> uniqueSubtitles = [];
    List<String> subTitleCount = [];
    Query query = db.collection('users').doc(user?.uid).collection('tasks');
    return StreamBuilder<QuerySnapshot>(
      stream: query.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for (int i = 0; i < snapshot.data!.docs.length; i++) {
            DocumentSnapshot task = snapshot.data!.docs[i];
            subtitles.add(task['hashtag']);
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
          return GridView.builder(
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
                          backgroundColor: Colors.transparent,
                          insetPadding: EdgeInsets.zero,
                          contentPadding: EdgeInsets.zero,
                          content: SizedBox(
                            width: MediaQuery.of(context).size.width *.9,
                            child: TagView(
                              tag: uniqueSubtitles[index],
                            ),
                          ),
                          actions: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: 108.0, left: 30),
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
