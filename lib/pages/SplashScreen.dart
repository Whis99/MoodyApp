import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moody/pages/Login.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to the Login screen after a delay of ... seconds 
    Timer(
        const Duration(seconds: 3),
        () => Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => Login())));
  }
  
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Expanded(
        child: Center(
          child: Image(
            image: AssetImage(
              'assets/ghosty.png'            
            ),
            height: 150,
          ),
        ),
      ),
    );
  }
}