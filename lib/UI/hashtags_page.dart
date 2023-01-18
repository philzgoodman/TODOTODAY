import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todotoday/UI/TagView.dart';
import '../TaskCard.dart';
import 'TaskView.dart';


class HashtagsPage extends StatelessWidget {
  int quantity = 1;
  String hashtag = '';
  String sendTag = '';
  List<String> subtitles = [];
  List<String> uniqueSubtitles = [];

  HashtagsPage({super.key});



  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    Query query = db.collection('users').doc(user?.uid).collection('tasks');

    for (int i = 0; i < quantity; i++) {
      query.get().then((value) {
        for (var element in value.docs) {
          subtitles.add(element['hashtag']);
        }
      });
    }

    uniqueSubtitles = subtitles.toSet().toList();
    List<String> subTitleCount = [];

    for (int i = 0; i < uniqueSubtitles.length; i++) {
      int count = 0;
      for (int j = 0; j < subtitles.length; j++) {
        if (uniqueSubtitles[i] == subtitles[j]) {
          count++;
        }
      }
      subTitleCount.add(count.toString());
    }

    final List<String> finalCounts = subTitleCount;

    return Scaffold(
      appBar: AppBar(
        title: Text('Hashtags'),
        backgroundColor: Color(0xFF356C40),
      ),
      body: GridView.builder(
        itemCount: uniqueSubtitles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(uniqueSubtitles[index]),
            onTap: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    backgroundColor: Colors.transparent,
                    insetPadding: EdgeInsets.zero,
                    contentPadding: EdgeInsets.zero,
                    content: TagView(
                      tag: uniqueSubtitles[index],
                    ),
                  );
                },
              );
            },
          );
        },
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
      ),
    );
  }
}
