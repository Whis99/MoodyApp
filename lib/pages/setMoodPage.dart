import 'package:flutter/material.dart';
import 'package:moody/components/firebaseService.dart';
import 'package:moody/components/utils.dart';
import 'package:moody/pages/homePage.dart';

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
        Utils.displayDialog(
            context, 'Mood alert', 'Your mood is set to $mood $emoji'),
        firebaseService.addMood(mood, emoji),
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
              const SizedBox(height: 10),
              Text(
                emoji,
                style: const TextStyle(
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
