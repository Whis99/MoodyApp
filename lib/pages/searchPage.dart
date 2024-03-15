import 'package:flutter/material.dart';
import 'package:moody/components/searchBar.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 10),
      child: Column(
        children: [
          const UserSearchBar(),
          // const SizedBox(height: 5.0),
          // ListView(
          //   children: const [],
          // ),
        ],
      ),
    );
  }
}