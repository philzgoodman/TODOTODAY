import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../TaskCard.dart';
import '../global.dart';
import 'TaskView.dart';


class TagView extends StatefulWidget {

  String tag;
  TagView({super.key, required this.tag});

  @override
  State<TagView> createState() => _TagViewState();
}

class _TagViewState extends State<TagView> {

  @override
  Widget build(BuildContext context) {
    final dbTag = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;
    Query query = dbTag
        .collection('users')
        .doc(user?.uid)
        .collection('tasks')
        .where('hashtag', isEqualTo: widget.tag);

      return
        TaskView(db: dbTag, user: user, query: query,);

    }

  }










