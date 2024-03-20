import 'package:cloud_firestore/cloud_firestore.dart';

class MoodData {
  final String mood;
  final String emoji;
  final Timestamp timeStamp;

  MoodData({
    required this.mood,
    required this.emoji,
    required this.timeStamp,
  });
}
