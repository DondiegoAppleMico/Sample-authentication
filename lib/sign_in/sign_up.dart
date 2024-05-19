import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sample_auth/sign_in/sign_in.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpScreen> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _signUp() async {
    try {
      if (_passwordController.text != _confirmPasswordController.text) {
        throw FirebaseAuthException(
          code: 'passwords-not-matching',
          message: 'The passwords do not match',
        );
      }

      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // If sign up succeeds, navigate to the next screen or perform any other action.
      // For example:
      print("Sign up successful.");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sign Up Successful"),
        backgroundColor: Colors.green,
      ));
      // Navigate to the home screen or any other screen after sign up
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => HomeScreen()),
      // );
    } on FirebaseAuthException catch (e) {
      print("Firebase Auth Error: ${e.code} - ${e.message}");
      // Display error message to the user if needed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Sign-up failed: ${e.message}"),
        backgroundColor: Colors.red,
      ));
    } catch (e) {
      print("Error: $e");
      // Display generic error message to the user if needed
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("An error occurred. Please try again later."),
        backgroundColor: Colors.red,
      ));
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignIn()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
          backgroundColor: const Color.fromARGB(255, 80, 101, 222),
          foregroundColor: const Color.fromARGB(255, 7, 5, 60),
        ),
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
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: Image.asset('assets/Cog.png'),
                  ),
                  const SizedBox(
                    height: 10,
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
                        borderRadius:
                            const BorderRadius.all(Radius.circular(25)),
                        border: Border.all(
                            color: const Color.fromARGB(255, 52, 40, 100),
                            width: 2.0),
                      ),
                      child: TextField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 10),
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
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                          border: Border.all(
                              color: const Color.fromARGB(255, 52, 40, 100),
                              width: 2.0)),
                      child: TextField(
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        obscureText: true,
                      )),
                  const SizedBox(height: 20.0),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 30),
                      Text(
                        "Confirm Password",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 52, 40, 100)),
                      ),
                      SizedBox(
                        width: 200,
                      ),
                    ],
                  ),
                  Container(
                      width: 300,
                      height: 50,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(25)),
                          border: Border.all(
                              color: const Color.fromARGB(255, 52, 40, 100),
                              width: 2.0)),
                      child: TextField(
                        controller: _confirmPasswordController,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        obscureText: true,
                      )),
                  const SizedBox(height: 40.0),
                  ElevatedButton(
                    onPressed: () => _signUp(),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 52, 40, 100),
                      ),
                    ),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}
