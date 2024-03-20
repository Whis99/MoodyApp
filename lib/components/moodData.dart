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

  // Convert the Timestamp into a more readable time
  String timeConverter() {
    final now = DateTime.now();
    final time = timeStamp.toDate();
    final difference = now.difference(time);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} s ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} h ago';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} d ago';
    } else if (difference.inDays < 365) {
      final months = (difference.inDays / 30).floor();
      return '$months month${months == 1 ? '' : 's'} ago';
    } else {
      final years = (difference.inDays / 365).floor();
      return '$years year${years == 1 ? '' : 's'} ago';
    }
  }
}
