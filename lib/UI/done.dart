import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../TaskCard.dart';
import '../global.dart';
import 'TaskView.dart';

class DonePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final db = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser;

    return
      TaskView(db: db, user: user);

  }

}
