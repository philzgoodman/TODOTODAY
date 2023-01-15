import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:todotoday/task.dart';

import 'TaskCard.dart';

class TodoApp with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final List<Task> tasks = [];

  Future<void> signUp(String email, String password) async {
    await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signIn(String email, String password) async {
    await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> createTask(String description) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not logged in');
    }
    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')

        .add({
      'description': description,
      'completed': false,
      'isToday': false,
      'hashtag': getHashtag(description),
      'date': DateTime.now(),

    });


    print("Stored to Firestore");
    notifyListeners();
  }

  void updateTask(TaskCard task) {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not logged in');
    }
    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(task.id)
        .update({ 'completed': task.completed, 'isToday': task.isToday , 'description': task.description});

  }




  Future<List<Task>> getTasks(index) {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not logged in');
    }
    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["description"]);
        tasks.add(Task.fromFirestore(doc));
      });
      return tasks;
    });

  }

  void initializeTasks() {
var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not logged in');
    }
    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        print(doc["description"]);
        tasks.add(Task.fromFirestore(doc));
      });
    });


  }

  void deleteTask(DateTime timeStamp) {

    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not logged in');
    }
    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .where('date', isEqualTo: timeStamp)
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        doc.reference.delete();
      });
    });





  }

  getHashtag(String description) {


    if (description.contains("#")) {
      var hashtag = description.split("#");
      return hashtag[1];
    } else {
      return "#default";
    }
  }






}
