import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
// import 'package:firebase_auth/firebase_auth.dart';
import 'package:moody/components/firebaseService.dart';
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
        title: const Text("Moody"),
        titleSpacing: 00.0,
        centerTitle: true,
        toolbarHeight: 60.2,
        toolbarOpacity: 0.9,
        elevation: 0.00,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
        child: ListView(
          children: [
            FutureBuilder<String>(
                future: _userName,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    print(_userName);
                    return Text(
                      "Hi $_userName",
                      style: const TextStyle(
                        color: Colors.black54,
                        fontWeight: FontWeight.w600,
                        fontSize: 20.0,
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
                  // Display a loading indicator while fetching
                  return const CircularProgressIndicator();
                }),
            // SearchBar
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20),
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
            moodCard(),
            setMood(),
            userList(),
          ],
        ),
      ),
    );
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

  Container setMood() {
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

  Card moodCard() {
    return Card(
      elevation: 0,
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Padding(
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
                  "😊",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 40.0),
                ), // Display mood emoji
              ],
            ),
            SizedBox(height: 40),
            Row(
              children: [
                Text(
                  "Happy",
                  style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.0,
                      color: Colors.black54),
                ), // Display mood text
                Spacer(),
                Text("10:30 AM"), // Display mood time
              ],
            ),
          ],
        ),
      ),
    );
  }
}