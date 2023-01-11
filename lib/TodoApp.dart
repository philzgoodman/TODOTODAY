import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todotoday/user.dart';
import 'package:todotoday/task.dart';

class TodoApp {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

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

  Future<void> createTask(String description, DateTime dueDate) async {
    var user = _auth.currentUser;
    if (user == null) {
      throw StateError('Not logged in');
    }
    await _firestore
        .collection('tasks')
        .doc(user.uid)
        .collection('tasks')
        .add({
      'description': description,
      'due_date': dueDate,
      'completed': false,
    });
  }

  void updateTask(Task task) {}
}
