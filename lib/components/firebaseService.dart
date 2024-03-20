import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:moody/components/moodData.dart';
import 'package:moody/components/userdata.dart';
import 'package:moody/pages/loginPage.dart';

// Class to interact with Firestore to handle user data and mood entries
class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final user = FirebaseAuth.instance.currentUser;

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
  Future<void> addMood(String mood, String emoji) async {
    // final user = FirebaseAuth.instance.currentUser;
    Timestamp timestamp = Timestamp.now();

    if (user == null) {
      // Handle the case where the user is not authenticated
      print('User is not authenticated');
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(user!.uid) // Refer to the user's document
          .collection('moods') // Add to the moods subcollection
          .add({
        'mood': mood,
        'emoji': emoji,
        'time': timestamp,
      });
      print('Mood added successfully');
    } catch (e) {
      print('Error adding mood: $e');
    }
  }

  // Add followed users into the following list to firestore
  Future<void> followUser(String userId) async {
    if (user == null) {
      // Handle the case where the user is not authenticated
      print('User is not authenticated');
      return;
    }

    try {
      await _firestore
          .collection('users')
          .doc(user!.uid) // Refer to the user's document
          // Method to modify the following array.
          .update({
        // A merge operation that appends the userId to the existing array without overwriting it
        'following': FieldValue.arrayUnion([userId])
      });
      print('User followed successfully');
    } catch (e) {
      print('Error following user: $e');
    }
  }

  // Retrieve a snapshot containing the user's name.
  Future<String> getUserName() async {
    // final user = FirebaseAuth.instance.currentUser;
    final docRef = _firestore.collection('users').doc(user!.uid);

    final docSnapshot = await docRef.get();
    if (docSnapshot.exists) {
      return docSnapshot.data()!['name'] as String;
    } else {
      // Handle case where document doesn't exist
      return 'User Not Found';
    }
  }

  // Get user's recent mood rom firestore
  Stream<MoodData?> getRecentMood() async* {
    final user = FirebaseAuth.instance.currentUser;

    // Handle case where user is not authenticated
    if (user == null) yield null;

    try {
      // Use the currently signed-in user's ID to access their moods subcollection in Firestore.
      final moodsRef = FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .collection('moods');

      // Query to retrieve the mood documents ordered by their time field in descending order,
      // to get the most recent one first.
      final moodQuery = moodsRef.orderBy('time', descending: true).limit(1);

      final snapshot = await moodQuery.get();
      if (snapshot.docs.isEmpty) yield null; // No moods

      final moodData = snapshot.docs.first.data();
      yield MoodData(
        mood: moodData['mood'] as String,
        emoji: moodData['emoji'] as String,
        timeStamp: moodData['time'] as Timestamp,
      );
    } catch (error) {
      print('Error fetching mood: $error');
      yield null; // Error
    }
  }

  // Sign the user out of the application
  Future<void> userSignOut(BuildContext context) async {
    try {
      await _auth.signOut();
      // Navigate to sign-in screen sign out
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Login()));
    } catch (e) {
      // Handle sign-up errors
      print('Error signing up: $e');
    }
  }

  Future<List<UserData>> getFollowingUsers() async {
    final followingList = await _firestore
        .collection('users')
        .doc(user!.uid)
        .get()
        .then((snapshot) =>
            snapshot.data()?['following'] as List); // Get following IDs

    if (followingList.isEmpty) {
      return []; // Return empty list if no following users
    }

    final userFutures = followingList.map((userId) => _firestore
        .collection('users')
        .doc(userId)
        .get()); // Create futures for each user

    final userSnapshots =
        await Future.wait(userFutures); // Wait for all futures to complete

    final users = userSnapshots
        .map((snapshot) => UserData(
              name: snapshot.data()?['name'] as String,
              mood: snapshot.data()?['mood'] as String,
              emoji: snapshot.data()?['emoji'] as String,
            ))
        .toList(); // Extract user data and create User objects

    return users;
  }
}
