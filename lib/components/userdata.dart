import 'package:cloud_firestore/cloud_firestore.dart';

class UserData {
  final String name;
  final String mood;
  final String emoji;
  final Timestamp timeStamp;

  UserData({
    required this.name,
    required this.mood,
    required this.emoji,
    required this.timeStamp,
  });
}
