import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String id;
  final String email;
  final String name;

  User({
    required this.id,
    required this.email,
    required this.name,
  });

  factory User.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data as Map;
    return User(
      id: doc.id,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
    );
  }
}
