import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  String description;
  bool completed;
  String id;
  bool isToday;
  String hashtag;

  Task({
    required this.description,
    required this.completed,
    required this.id,
    required this.isToday,
    required this.hashtag,
  });

  factory Task.fromDocument(DocumentSnapshot doc) {
    return Task(
      description: doc['description'],
      completed: doc['completed'],
      id: doc.id,
      isToday: doc['isToday'],
      hashtag: doc['hashtag'],
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
      completed: doc['completed'],
      isToday: doc['isToday'],
      id: doc.id,
      hashtag: doc['hashtag'],
    );
  }
}
