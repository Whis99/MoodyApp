import 'package:flutter/material.dart';

class MoodTracker extends StatefulWidget {
  const MoodTracker({super.key});

  @override
  State<MoodTracker> createState() => _MoodTrackerState();
}

class _MoodTrackerState extends State<MoodTracker> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Moody",
        ),
      ),
      body: SafeArea(
        child: Container(

        ),
      ),
    );
  }
}
