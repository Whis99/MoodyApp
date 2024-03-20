// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moody/components/firebaseService.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  final _searchController = TextEditingController();
  final FirebaseService firebaseService = FirebaseService();

  // Stream<List<String>>?
  //     _userStream; // Stream for search results (initially null)

  Stream<QuerySnapshot<Object>> searchUsers(var query) {
    final userRef = FirebaseFirestore.instance.collection('users');
    return query == ''
        ? userRef
            .snapshots() //Stream.fromIterable([]) // Empty stream for no query
        : userRef
            .where('name', isGreaterThanOrEqualTo: query)
            .where('name',
                isLessThanOrEqualTo:
                    query) // Case-insensitive search (adjust as needed)
            .snapshots();
    // .map((snapshot) =>
    //     snapshot.docs.map((doc) => doc['name'] as String).toList());
  }

  Card userCard(var user, String userId) {
    return Card(
      elevation: 1,
      surfaceTintColor: Color.fromARGB(255, 255, 255, 255),
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
                  fontSize: 20.0,
                  color: Colors.black54),
            ),
            const Spacer(),
            IconButton(
              onPressed: () => {
                print('$user is followed'),
                firebaseService.followUser(userId),
                print('USERID=====> $userId'),
              },
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
    var search = '';
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
                  search = _searchController.text.trim();
                  print('SEARCHING FOR $search');
                  setState(() {
                    searchUsers(search);
                    print(searchUsers(search));
                  });
                },
                icon: const Icon(Icons.search_rounded,
                    size: 30, color: Colors.black54),
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(50),
              ),
            ),
          ),
          StreamBuilder<QuerySnapshot>(
              stream: searchUsers(search),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  print(snapshot.error);
                  return Text('Error: ${snapshot.error}');
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final users = snapshot.data!.docs;
                return ListView.builder(
                    shrinkWrap: true,
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      var data = users[index];
                      return userCard(data['name'], data.id.toString());
                    });
              }),
        ],
      ),
    );
  }
}
