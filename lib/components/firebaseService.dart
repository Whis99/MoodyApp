import 'package:cloud_firestore/cloud_firestore.dart';

// Class to interact with Firestore to handle user data and mood entries
class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

// Register user in Firestore
  Future<void> addUser(String userId, String name, String email) async {
    try {
      await _firestore.collection('users').doc(userId).set({
        'name': name,
        'email': email,
        'following': [], // Initialize following as an empty array
      });
      print('User added successfully');
    } catch (e) {
      print('Error adding user: $e');
    }
  }

// Method to add the mood entry to Firestore.
  Future<void> addMood(String userId, String mood) async {
    try {
      await _firestore.collection('moods').add({
        'userId': userId,
        'mood': mood,
        'timestamp': FieldValue.serverTimestamp(),
      });
      print('Mood added successfully');
    } catch (e) {
      print('Error adding mood: $e');
    }
  }
}
