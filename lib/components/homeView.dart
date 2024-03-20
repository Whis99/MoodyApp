import 'package:flutter/material.dart';
import 'package:moody/components/firebaseService.dart';
import 'package:moody/components/moodData.dart';
import 'package:moody/components/userdata.dart';
import 'package:moody/pages/setMoodPage.dart';

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
          const SizedBox(height: 10.0),
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
          const Text(
            'Following',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25.0,
                color: Colors.black54),
          ),
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
      margin: const EdgeInsets.symmetric(vertical: 20),
      padding: const EdgeInsets.all(20),
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
        child: FutureBuilder<List<UserData>>(
          future: firebaseService.getFollowingUsers(),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              print(snapshot.error);
              return Text('Error: ${snapshot.error}');
            }
            final users = snapshot.data!;
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  users.length, // Replace with actual count of followed users
              itemBuilder: (context, index) {
                final user = users[index];
                return ListTile(
                  title: Text(
                    user.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                        color: Colors.black54),
                  ),
                  subtitle: Text(
                    user.mood,
                    style: const TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 15.0,
                        color: Colors.black54),
                  ),
                  leading: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Text(user.emoji,
                        style: const TextStyle(fontSize: 25.0)),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  // Redirects the user to the page where he/she will select is/her current mood. The mood will
  // be sent to firestore and it will also be displayed in the homepage.
  Widget setMoodCard() {
    return GestureDetector(
      onTap: () {
        // Handle click
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => SetMoodPage()));
      },
      child: Container(
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
        child: const Row(
          children: [
            Text(
              "Set a Mood",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
            ),
            Spacer(),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 30.0,
              color: Colors.black54,
            ),
          ],
        ),
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
