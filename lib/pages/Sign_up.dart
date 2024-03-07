import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:moody/pages/mood_tracker.dart';
// import 'package:moody/pages/Login.dart';

class SignUp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  SignUp({super.key});

  Future<void> _signUpWithEmailAndPassword(BuildContext context, String email, String password) async {
    try {
      final newUser = await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password);
      // Navigate to the next screen upon successful sign-up
      if (newUser.user != null){
          Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const MoodTracker()));
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        print('The account already exists for that email.');
    }
  } catch (e) {
      // Handle sign-up errors
      print('Error signing up: $e');
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
                    'Create an account',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: _emailController,
                    obscureText: false,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: const Color.fromARGB(255, 245, 245, 245),
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
                    onPressed: () async{
                      //Firebase authentication logic
                      String email = _emailController.text.trim();
                      String password = _passwordController.text.trim();                    
                      _signUpWithEmailAndPassword(context, email, password);
                    },
                    child: const Text('Sign Up'),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text(
                        "Already have an account. ",
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.black,
                          ),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: const Text(
                          "Login",
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
