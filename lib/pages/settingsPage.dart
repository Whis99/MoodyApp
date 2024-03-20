import 'package:flutter/material.dart';
import 'package:moody/components/settingsView.dart';

class Settings extends StatelessWidget {
  const Settings({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
      child: SettingsView(),
    );
  }
}
