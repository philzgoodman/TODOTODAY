
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:todotoday/task.dart';

import 'TaskCard.dart';
import 'global.dart';
import 'main.dart';

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

  Future<void> createTask(String description, bool isToday) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not logged in');
    }
    await _firestore.collection('users').doc(user.uid).collection('tasks').add({
      'description': description,
      'completed': false,
      'isToday': isToday,
      'hashtag': getHashtag(description),
      'date': DateTime.now().toString(),
    });

    print("Stored to Firestore");
    notifyListeners();
  }

  Future<void> createTaskWithHashtag(String description, String hashtag) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not logged in');
    }
    await _firestore.collection('users').doc(user.uid).collection('tasks').add({
      'description': description,
      'completed': false,
      'isToday': false,
      'hashtag': hashtag,
      'date': DateTime.now().toString(),
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
        .update({
      'completed': task.completed,
      'isToday': task.isToday,
      'description': task.description,
      'hashtag': task.hashtag,
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

  void deleteTask(String id) {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not logged in');
    }
    _firestore
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .where('id', isEqualTo: id)
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
      var hashtag2 = hashtag[1].split(" ");
      return '#${hashtag2[0]}';
    } else {
      return "#default";
    }
  }

  static void deleteTaskByFirebaseId(String id) {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not logged in');
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('tasks')
        .doc(id)
        .delete();
  }

  static void saveNewColorsToFirestore(Color today1, Color today2,
      Color today3) {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not logged in');
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('colors')
        .doc('today')
        .set({
      'today1': today1.value,
      'today2': today2.value,
      'today3': today3.value,
    });
  }

  static void setSavedBackgroundColorsFromFirestore() {
    var c1;
    var c2;
    var c3;

    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not logged in');
    }
    FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('colors')
        .doc('today')
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        c1 = Color(documentSnapshot['today1']);
        c2 = Color(documentSnapshot['today2']);
        c3 = Color(documentSnapshot['today3']);
      }

      if (c1 != null && c2 != null && c3 != null) {
        today1 = c1;
        today2 = c2;
        today3 = c3;
      }
    });
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    runApp(Phoenix(child: MyApp()));
  }
























  Future<void> saveTextAsSubcollectionInFirestore(String text, String id) async {
    var user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw StateError('Not logged in');
    }
    await _firestore.collection('users').doc(user.uid).collection('tasks')
        .doc(id).collection('notes').add({

      'text': text,
    });

    print("Stored to Firestore");
    notifyListeners();

  }

  static void getFirstNoteFromFireStore(String id) {var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    throw StateError('Not logged in');
  }
  FirebaseFirestore.instance
      .collection('users')
      .doc(user.uid)
      .collection('tasks')
      .doc(id)
      .collection('notes')
      .get()
      .then((QuerySnapshot querySnapshot) {
    querySnapshot.docs.forEach((doc) {
      print(doc["text"]);
      notes[0] = doc["text"];
    });
  });}



}

