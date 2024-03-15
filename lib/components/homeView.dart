import 'package:flutter/material.dart';
import 'package:moody/components/firebaseService.dart';
import 'package:moody/components/moodData.dart';
import 'package:moody/components/searchBar.dart';
import 'package:moody/pages/setMood.dart';

// This class will be the first view to show when accessing the homepage
// and also the first index of the bottom navigation bar
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final FirebaseService firebaseService = FirebaseService();
  Future<String>? _userName;

  @override
  void initState() {
    super.initState();
    _userName = firebaseService.getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      child: ListView(
        children: [
          showUserName("Welcome"),
          UserSearchBar(),
          // SearchBar
          // Padding(
          //   padding: const EdgeInsets.symmetric(vertical: 20),
          //   child: TextField(
          //     decoration: InputDecoration(
          //       hintText: "Search for a user",
          //       filled: true,
          //       fillColor: Colors.white,
          //       prefixIcon:
          //           const Icon(Icons.search, size: 30, color: Colors.black54),
          //       border: OutlineInputBorder(
          //         borderRadius: BorderRadius.circular(50),
          //       ),
          //     ),
          //   ),
          // ),
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
    );
  }

  // Function that will display the current user name
  FutureBuilder<String> showUserName(String text) {
    return FutureBuilder<String>(
        future: _userName,
        builder: (context, snapshot) {
          // Show username if it exists
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

  // A container that will display all the users the current user has followed
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

  // Redirects the user to the page where he/she will select is/her current mood. The mood will
  // be sent to firestore and it will also be displayed in the homepage.
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

  // A card that diplays the current mood of the current user, the related emoji and the time
  // when he/she has set it.
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
                const Text(
                  "Your Mood",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30.0,
                      color: Colors.black54),
                ),
                const Spacer(),
                Text(
                  emoji,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 50.0),
                ), // Display mood emoji
              ],
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Text(
                  mood,
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 19.0,
                      color: Colors.black54),
                ), // Display mood text
                const Spacer(),
                Text(
                  time,
                  style: const TextStyle(fontSize: 19.0, color: Colors.black54),
                ), // Display mood time
              ],
            ),
          ],
        ),
      ),
    );
  }
}
