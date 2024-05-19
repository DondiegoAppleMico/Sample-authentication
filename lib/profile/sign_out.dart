import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample_auth/sign_in/sign_in.dart'; // Replace this with the correct path to your SignIn page

class SignOutPage extends StatelessWidget {
  const SignOutPage({Key? key}) : super(key: key);

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance
          .signOut(); // Sign out of Firebase Authentication

      final GoogleSignIn _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut(); // Sign out of Google Sign-In

      print('User signed out successfully');

      // Navigate to the sign-in page
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) =>
              SignIn(), // Replace SignIn() with your sign-in page
        ),
        (route) => false, // Remove all existing routes
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Sign Out', style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.grey[200],
        elevation: 0,
      ),
      body: Center(
        child: ElevatedButton.icon(
          onPressed: () => _signOut(context),
          icon: Icon(Icons.logout, color: Colors.white),
          label: Text('Sign Out', style: TextStyle(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }
}
