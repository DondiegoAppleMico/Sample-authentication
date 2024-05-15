import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sample_auth/sign_in/sign_in.dart';

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
                SignIn()), // Replace SignIn() with your sign-in page
        (route) => false, // Remove all existing routes
      );
    } catch (e) {
      print('Error signing out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _signOut(context),
      child: Text('Sign Out'),
    );
  }
}
