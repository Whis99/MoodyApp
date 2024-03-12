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
                    query + 'zzz') // Case-insensitive search (adjust as needed)
            .snapshots()
            .map((snapshot) =>
                snapshot.docs.map((doc) => doc['name'] as String).toList());
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
              // prefixIcon:
              //     const Icon(Icons.search, size: 30, color: Colors.black54),
              suffixIcon: IconButton(
                onPressed: () {
                  final searchTerm = _searchController.text.trim();
                  if (searchTerm.isNotEmpty) {
                    setState(() {
                      _userStream = searchUsers(searchTerm);
                    });
                  }
                },
                icon:
                    Icon(Icons.search_rounded, size: 30, color: Colors.black54),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            // onChanged: (searchTerm) {
            //   print(searchTerm);
            //   if (searchTerm.isEmpty) {
            //     setState(() {
            //       _userStream = null; // Clear stream if search term is empty
            //     });
            //   } else {
            //     _userStream = searchUsers(searchTerm);
            //     print(
            //         'USER RESULT===>: $_userStream'); // Trigger search on non-empty term
            //   }
            // },
          ),
          if (_userStream != null) // Display results only if stream exists
            StreamBuilder<List<String>>(
              stream: _userStream!,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.hasData) {
                  final users = snapshot.data!;
                  return ListView.builder(
                    shrinkWrap:
                        true, // Prevent list from expanding unnecessarily
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      // ... display user information here
                      print('USERNAME:====> $user');
                      return Text(user);
                    },
                  );
                }

                return const Center(child: CircularProgressIndicator());
              },
            ),
        ],
      ),
    );
  }
}
