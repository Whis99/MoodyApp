import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  Future<void> addMood(String mood) async {
    final user = FirebaseAuth.instance.currentUser;
    Timestamp timestamp = Timestamp.now();

    if (user == null) {
      // Handle the case where the user is not authenticated
      print('User is not authenticated');
      // Consider prompting for login or displaying an error message
      return;
    }

    print(user.uid);
    try {
      await _firestore
          .collection('users')
          .doc(user.uid) // Refer to the user's document
          .collection('moods') // Add to the moods subcollection
          .add({
        'mood': mood,
        'time': timestamp,
      });
      print('Mood added successfully');
    } catch (e) {
      print('Error adding mood: $e');
    }

    // try {
    //   await _firestore.collection('moods').add({
    //     'userId': user.uid,
    //     'mood': mood,
    //     'time': timestamp,
    //   });
    //   print('Mood added successfully');
    // } catch (e) {
    //   print('Error adding mood: $e');
    // }
  }

  // Retrieve a snapshot containing the user's name.
  Future<String> getUserName() async {
    final user = FirebaseAuth.instance.currentUser;
    final docRef = _firestore.collection('users').doc(user!.uid);

    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      return docSnapshot.data()!['name'] as String;
    } else {
      // Handle case where document doesn't exist
      return 'User Not Found';
    }
  }
}
