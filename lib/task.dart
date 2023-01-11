
import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String description;
  final DateTime dueDate;
  late final bool completed;
  final String userId;
  final List<String> tags;
  final bool today;

  Task({
    required this.id,
    required this.description,
    required this.dueDate,
    required this.completed,
    required this.userId,
    required this.tags,
    required this.today
  });

  factory Task.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data as Map;
    return Task(
      id: doc.id,
      description: data['description'] ?? '',
      dueDate: data['due_date'].toDate() ?? DateTime.now(),
      completed: data['completed'] ?? false,
      userId: data['user'] ?? '',
      tags: List<String>.from(data['tags'] ?? []),
      today: data['today'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'description': description,
      'due_date': dueDate,
      'completed': completed,
      'tags': tags,
      'today': today,
    };
  }
}
