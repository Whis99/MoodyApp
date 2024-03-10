import 'package:flutter/material.dart';
import 'package:moody/components/firebaseService.dart';
import 'package:moody/pages/home.dart';

class SetMoodPage extends StatelessWidget {
  // Dictionary to store moods and emojis
  final Map<String, String> moods = {
    'Happy': '😊',
    'Sad': '😢',
    'Angry': '😡',
    'Excited': '🤩',
    'Confused': '😕',
    'Tired': '😴',
    'Relaxed': '😌',
    'Grateful': '🙏',
    'Surprised': '😮',
    'Content': '😌',
    'Love': '❤️',
    'Stressed': '😫',
    'Depressed': '😞',
    'Meeeh': '😑',
  };

  final FirebaseService firebaseService = FirebaseService();

  SetMoodPage({super.key});

  void _moodAlert(BuildContext context, String mood) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Mood alert",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          content: Text(
            "Your mood is set to $mood",
            style: const TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w500,
              color: Colors.black54,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 30, 20, 10),
        child: Column(
          children: [
            Container(
              alignment: Alignment.topLeft,
              child: IconButton(
                onPressed: () {
                  // Handle click
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => HomePage()));
                },
                icon: const Icon(
                  Icons.arrow_back_ios_rounded,
                  size: 30.0,
                  color: Colors.black54,
                ),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            const Text(
              "What's your mood?",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                children: moods.entries.map((entry) {
                  return _buildMoodCard(context, entry.key, entry.value);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMoodCard(BuildContext context, String mood, String emoji) {
    return GestureDetector(
      onTap: () => {
        _moodAlert(context, mood),
        firebaseService.addMood(mood),
        print(mood),
      },
      child: Card(
        elevation: 3,
        color: Colors.white,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                mood,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10),
              Text(
                emoji,
                style: TextStyle(
                  fontSize: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
