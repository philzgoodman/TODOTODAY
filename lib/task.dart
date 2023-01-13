
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
   String description;
   bool completed;
   String id;
   bool isToday;

  Task({
    required this.description,
    required this.completed,
    required this.id,
    required this.isToday,
  });

  factory Task.fromDocument(DocumentSnapshot doc) {
    return Task(
      description: doc['description'],
      completed: doc['completed'], id: doc.id, isToday: doc['isToday'],
    );
  }





  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'completed': completed,
      'isToday': isToday,
    };
  }

  static Task fromFirestore(QueryDocumentSnapshot<Object?> doc) {

    return Task(
      description: doc['description'],
      completed: doc['completed'], isToday: doc['isToday'], id: doc.id,

    );
  }
}
