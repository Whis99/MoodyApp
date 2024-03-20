import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moody/firebase_options.dart';
import 'package:moody/pages/loginPage.dart';
// import 'package:moody/pages/splashScreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //This is initial page where the app will begin
      home: Login(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
    );
  }
}
