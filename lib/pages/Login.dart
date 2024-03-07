import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moody/pages/Sign_up.dart';
import 'package:moody/pages/mood_tracker.dart';

class Login extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Login({super.key});

  Future<void> _signInWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      final user = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
      );
      // Navigate to the next screen upon successful login
      if (user.user != null){
        Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MoodTracker()));
      }
    } catch (e) {
      // Handle login errors
      print('Error signing in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Card(
            color: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/ghosty.png', // Replace with your logo path
                    height: 70,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Welcome to Moody',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Color.fromARGB(255, 245, 245, 245),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 245, 245, 245),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      //login logic here
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();
                      _signInWithEmailAndPassword(context, email, password);
                    },
                    child: const Text('Login'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => SignUp())),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(
                          fontSize: 15,
                          color: Color.fromARGB(255, 0, 29, 158),
                        ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
