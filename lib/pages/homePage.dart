import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:moody/components/firebaseService.dart';
import 'package:moody/components/homeView.dart';
import 'package:moody/pages/searchPage.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseService firebaseService = FirebaseService();
  // Index of the first page for the navigation
  int pageIndex = 0;

  // List of pages displayed in the bottom navigation bar
  final pages = [
    const HomeView(),
    const SearchPage(),
  ];

  // Icon widget for the navigation
  Icon navIcon(IconData data) {
    return Icon(
      data,
      size: 25,
      color: Colors.black54,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Icons list inthe bottomNavBar
    final items = <Icon>[
      navIcon(Icons.home),
      navIcon(Icons.search_rounded),
    ];

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
                firebaseService.userSignOut(context);
              },
            ),
          ],
        ),
      ),
      body: pages[pageIndex],
      bottomNavigationBar: bottomNavigation(
          pageIndex: pageIndex,
          items: items,
          onTap: (index) {
            setState(() {
              pageIndex = index;
              print(pageIndex);
              print(pages[pageIndex]);
            });
          }),
    );
  }

  // Bottom nagivation bar
  Widget bottomNavigation(
      {required int pageIndex,
      required List<Icon> items,
      required Function(int) onTap}) {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      animationCurve: Curves.easeInOutCirc,
      animationDuration: const Duration(milliseconds: 500),
      height: 50,
      index: pageIndex,
      items: items,
      onTap: onTap,
      letIndexChange: (index) => true,
    );
  }
}
