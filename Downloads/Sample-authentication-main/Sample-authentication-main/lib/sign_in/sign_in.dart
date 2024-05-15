import 'dart:async';

import 'package:sample_auth/home/home_screen.dart';
import 'package:sample_auth/sign_in/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignUpState();
}

class _SignUpState extends State<SignIn> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  late final GoogleSignIn _googleSignIn;

  @override
  void initState() {
    super.initState();
    // Initialize GoogleSignIn with client ID
    _googleSignIn = GoogleSignIn(
      clientId:
          '655717914601-gv7nlgjoef5cedbbvpnk5jt77731gfmb.apps.googleusercontent.com',
    );
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      final User? user = userCredential.user;

      print('User signed in with Google: ${user!.displayName}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Signed in with Google: ${user.displayName}"),
        backgroundColor: Colors.green,
      ));
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } catch (e) {
      print("Google Sign-In Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to sign in with Google: $e"),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _signIn() async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // If sign in succeeds, navigate to the next screen or perform any other action.
      // For example:
      print("Sign up successful.");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sign In Successfull"),
        backgroundColor: Colors.green,
      ));
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (e) {
      print('Firebase Error: ${e.message}');
      // Display error message to the user if needed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sign-in failed: ${e.message}"),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      print('Error: $e');
      // Display generic error message to the user if needed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An error occurred. Please try again later."),
        backgroundColor: Colors.red,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color.fromARGB(255, 80, 101, 222),
            Color.fromARGB(255, 196, 143, 189),
          ],
        ),
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
          child: Column(
            children: [
              const SizedBox(
                height: 120,
              ),
              SizedBox(
                width: 200,
                height: 200,
                child: Image.asset(
                  'assets/Cognispace.png',
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Username",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 52, 40, 100)),
                  ),
                  SizedBox(
                    width: 225,
                  ),
                ],
              ),
              Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(25)),
                    border: Border.all(
                        color: const Color.fromARGB(255, 52, 40, 100),
                        width: 2.0),
                  ),
                  child: TextField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 2),
                        icon: Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Icon(
                            Icons.mail,
                            color: Color.fromARGB(255, 52, 40, 100),
                            size: 20,
                          ),
                        ),
                      ))),
              const SizedBox(
                height: 25,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Password",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 52, 40, 100)),
                  ),
                  SizedBox(
                    width: 225,
                  ),
                ],
              ),
              Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.all(Radius.circular(25)),
                      border: Border.all(
                          color: const Color.fromARGB(255, 52, 40, 100),
                          width: 2.0)),
                  child: TextField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.symmetric(horizontal: 2),
                      icon: Padding(
                        padding: EdgeInsets.only(left: 15),
                        child: Icon(
                          Icons.lock,
                          color: Color.fromARGB(255, 52, 40, 100),
                          size: 20,
                        ),
                      ),
                    ),
                    obscureText: true,
                  )),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _signIn,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(
                              255, 52, 40, 100)), // Background color
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    ),
                    child: Container(
                      width: 100,
                      height: 30,
                      alignment: Alignment.center,
                      child: const Text(
                        "Log In",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(width: 60),
                  const Text("Don't Have an Account?"),
                  const SizedBox(
                    width: 50,
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SignUpScreen()));
                    },
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 22, 25, 193)),
                    ),
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                ],
              ),
              const SizedBox(
                height: 70,
              ),
              const Text("Sign in using"),
              TextButton(
                onPressed: _signInWithGoogle,
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Image.asset(
                    'assets/google.png',
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    ));
  }
}
