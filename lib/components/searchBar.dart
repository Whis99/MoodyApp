import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearchBar extends StatefulWidget {
  const UserSearchBar({super.key});

  @override
  State<UserSearchBar> createState() => _UserSearchBarState();
}

class _UserSearchBarState extends State<UserSearchBar> {
  final _searchController = TextEditingController();
  Stream<List<String>>?
      _userStream; // Stream for search results (initially null)

  Stream<List<String>> searchUsers(String query) {
    final userRef = FirebaseFirestore.instance.collection('users');
    return query.isEmpty
        ? Stream.fromIterable([]) // Empty stream for no query
        : userRef
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name',
                isLessThanOrEqualTo:
                    query) // Case-insensitive search (adjust as needed)
            .snapshots()
            .map((snapshot) =>
                snapshot.docs.map((doc) => doc['name'] as String).toList());
  }

//A dialog box that pops up that contains the results of the search
  Widget _showUserDialog(Widget content) {
    return AlertDialog(
      backgroundColor: const Color.fromARGB(255, 240, 240, 240),
      icon: const Icon(
        Icons.person_search_outlined,
        size: 20.0,
        color: Colors.black54,
      ),
      iconColor: Colors.black54,
      content: content,
      actionsAlignment: MainAxisAlignment.center,
      actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close the dialog
          },
          icon: const Icon(
            Icons.close_rounded,
            size: 20.0,
          ),
        ),
      ],
      // );
      // },
    );
  }

  Card userCard(String user) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Text(
              user,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 25.0,
                  color: Colors.black54),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => {print('$user is followed')},
              icon: const Icon(Icons.person_add_alt_1_outlined),
              iconSize: 20.0,
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: "Search for a user",
              filled: true,
              fillColor: Colors.white,
              suffixIcon: IconButton(
                onPressed: () {
                  final searchTerm = _searchController.text.trim();
                  print('SEARCHING FOR $searchTerm');
                  if (searchTerm.isNotEmpty) {
                    _userStream = searchUsers(searchTerm);
                    print("Requesting...........................");
                  }
                },
                icon: const Icon(Icons.search_rounded,
                    size: 30, color: Colors.black54),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          if (_userStream != null)
            // Display results only if stream exists
            StreamBuilder<List<String>>(
              stream: _userStream!,
              builder: (context, snapshot) {
                // print('Request complete====> $_userStream');
                print('Stream Building..........................');
                print('snapshot error...........................');

                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Error: ${snapshot.error}');
                }

                print('Snapshot data...........................');
                if (snapshot.hasData) {
                  print('Data===========> ${snapshot.data}');
                  final users = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      // Display user information here
                      print('USERNAME:====> $user');
                      return Text(user);
                    },
                  );
                }
                print('Closing request............................');
                return const Center(child: CircularProgressIndicator());
              },
            ),
        ],
      ),
    );
  }
}
