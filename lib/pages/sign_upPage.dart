import 'package:flutter/material.dart';
import 'package:moody/components/firebaseService.dart';
import 'package:moody/components/utils.dart';
// import 'package:moody/pages/Login.dart';

class SignUp extends StatelessWidget {
  static const String id = 'signUp';

  final FirebaseService firebaseService = FirebaseService();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _password2Controller = TextEditingController();

  SignUp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 243, 243, 243),
      body: Center(
        child: SingleChildScrollView(
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
                      controller: _nameController,
                      obscureText: false,
                      keyboardType: TextInputType.name,
                      decoration: InputDecoration(
                        hintText: 'Full name',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 245, 245, 245),
                      ),
                    ),
                    const SizedBox(height: 10),
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
                    TextField(
                      controller: _password2Controller,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Confirm password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        filled: true,
                        fillColor: const Color.fromARGB(255, 245, 245, 245),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        //Firebase authentication logic
                        String name = _nameController.text.trim();
                        String email = _emailController.text.trim();
                        String password = _passwordController.text.trim();
                        String password2 = _password2Controller.text.trim();
                        if (name.isEmpty ||
                            email.isEmpty ||
                            password.isEmpty ||
                            password2.isEmpty) {
                          Utils.displayDialog(context, 'Field empty',
                              'Please fill all the fields.');
                        } else if (password != password2) {
                          Utils.displayDialog(context, 'Password not match',
                              'The passwords do not match. Please try again.');
                        } else {
                          firebaseService.signUpWithEmailAndPassword(
                              context, name, email, password);
                        }
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
      ),
    );
  }
}
