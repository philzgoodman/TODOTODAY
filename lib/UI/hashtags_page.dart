import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../TaskCard.dart';
import 'TaskView.dart';

class HashtagsPage extends StatelessWidget {
  int quantity = 1;
  String hashtag = '';
  String sendTag = '';
  int count = 0;
  List<String> subtitles = [];
  List<String> uniqueSubtitles = [];

  HashtagsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    return StreamBuilder<QuerySnapshot>(
      stream:
          db.collection('users').doc(user?.uid).collection('tasks').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          for (var i = 0; i < snapshot.data!.docs.length; i++) {
            subtitles.add(snapshot.data!.docs[i]['hashtag']);
          }
          uniqueSubtitles = subtitles.toSet().toList();
          return GridView.builder(
            itemCount: uniqueSubtitles.length,
            itemBuilder: (context, index) {
              count = 0;
              for (var i = 0; i < subtitles.length; i++) {
                if (subtitles[i] == uniqueSubtitles[index]) {
                  count++;
                }
              }
              return GestureDetector(
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('Delete this hashtag?'),
                        content: Text(
                            'Are you sure you want to delete this hashtag?'),



                      );
                    },


                  );
                },
                child: Card(
                    child: Center(
                        child: Text(
                            uniqueSubtitles[index] + ' ' + count.toString()))),
              );
            },
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
          );
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}
