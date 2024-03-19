// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserSearchBar extends StatefulWidget {
  const UserSearchBar({super.key});

  @override
  State<UserSearchBar> createState() => _UserSearchBarState();
}

class _UserSearchBarState extends State<UserSearchBar> {
  final _searchController = TextEditingController();
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

//A dialog box that pops up that contains the results of the search
  // Widget _showUserDialog(Widget content) {
  //   return AlertDialog(
  //     backgroundColor: const Color.fromARGB(255, 240, 240, 240),
  //     icon: const Icon(
  //       Icons.person_search_outlined,
  //       size: 20.0,
  //       color: Colors.black54,
  //     ),
  //     iconColor: Colors.black54,
  //     content: content,
  //     actionsAlignment: MainAxisAlignment.center,
  //     actions: [
  //       IconButton(
  //         onPressed: () {
  //           Navigator.of(context).pop(); // Close the dialog
  //         },
  //         icon: const Icon(
  //           Icons.close_rounded,
  //           size: 20.0,
  //         ),
  //       ),
  //     ],
  //     // );
  //     // },
  //   );
  // }

  Card userCard(var user) {
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
    var search = '';
    // var search;
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
                // print(snapshot.data!.docs.first['name']);
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
                      return userCard(data['name']);
                    });
              }),
        ],
      ),
    );
  }
}
