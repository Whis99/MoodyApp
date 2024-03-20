import 'package:flutter/material.dart';
import 'package:moody/components/firebaseService.dart';

class SettingsView extends StatelessWidget {
  final FirebaseService firebaseService = FirebaseService();

  SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.logout),
          tileColor: Colors.white70,
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
    );
  }
}
