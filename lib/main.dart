import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:moody/firebase_options.dart';
import 'package:moody/pages/Sign_up.dart';
import 'package:moody/pages/login.dart';
import 'package:moody/pages/splashScreen.dart';

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
      home: const SplashScreen(),
      //List of all the pages will be referenced for routing
      routes: {
        SplashScreen.id: (context) => const SplashScreen(),
        SignUp.id: (context) => SignUp(),
        Login.id: (context) => Login(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
