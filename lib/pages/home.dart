import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:moody/components/firebaseService.dart';
import 'package:moody/components/moodData.dart';
import 'package:moody/pages/setMood.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService firebaseService = FirebaseService();
  Future<String>? _userName;

  @override
  void initState() {
    super.initState();
    _userName = firebaseService.getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      appBar: AppBar(
        title: const Text(
          "Moody",
          style: TextStyle(
            fontSize: 25.0,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.9,
        elevation: 0.00,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 252, 163, 247),
              ),
              child: showUserName(''),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                  fontSize: 20.0,
                ),
              ),
              onTap: () async {
                // await _auth.signOut();
                // Navigate to sign-in screen or any other screen after sign out
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
        child: ListView(
          children: [
            showUserName("Welcome"),
            // SearchBar
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search for a user",
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon:
                      const Icon(Icons.search, size: 30, color: Colors.black54),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
            // StreamBuilder is used to take user's mood in realtime from firestore after each update
            StreamBuilder<MoodData?>(
              stream: firebaseService.getRecentMood(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final moods = snapshot.data;
                  print(moods!.mood);
                  print(moods.emoji);
                  print(moods.timeStamp);
                  return moodCard(
                    mood: moods.mood,
                    emoji: moods.emoji,
                    time: moods.timeConverter(),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData) {
                  return moodCard(mood: '', emoji: '', time: '');
                }
                // Display a loading indicator while fetching
                return const Center(child: CircularProgressIndicator());
              },
            ),
            setMoodCard(),
            userList(),
          ],
        ),
      ),
    );
  }

  FutureBuilder<String> showUserName(String text) {
    return FutureBuilder<String>(
        future: _userName,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            print(snapshot.data);
            return Text(
              "$text ${snapshot.data}",
              style: const TextStyle(
                color: Colors.black54,
                fontWeight: FontWeight.w600,
                fontSize: 25.0,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }
          // Display a loading indicator while fetching
          return const Center(child: CircularProgressIndicator());
        });
  }

  Container userList() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20),
      padding: EdgeInsets.all(20),
      height: 350.0,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 10, // Replace with actual count of followed users
          itemBuilder: (context, index) {
            return ListTile(
              title: Text("Followed User ${index + 1}"),
              subtitle: const Text("Mood: Happy"),
              leading: CircleAvatar(
                child: Text((index + 1).toString()),
              ),
            );
          },
        ),
      ),
    );
  }

  Container setMoodCard() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            "Set a Mood",
            style: TextStyle(
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Spacer(),
          IconButton(
            onPressed: () {
              // Handle click
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => SetMoodPage()));
            },
            icon: const Icon(
              Icons.arrow_forward_ios_rounded,
              size: 30.0,
              color: Colors.black54,
            ),
          ),
        ],
      ),
    );
  }

  Card moodCard(
      {required String mood, required String emoji, required String time}) {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  "Your Mood",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.black54),
                ),
                Spacer(),
                Text(
                  emoji,
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
                ), // Display mood emoji
              ],
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Text(
                  mood,
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Colors.black54),
                ), // Display mood text
                Spacer(),
                Text("$time"), // Display mood time
              ],
            ),
          ],
        ),
      ),
    );
  }
}
