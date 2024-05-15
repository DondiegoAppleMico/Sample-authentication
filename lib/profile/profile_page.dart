import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:sample_auth/profile/sign_out.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show a loading indicator while waiting for the authentication state to change
          return const CircularProgressIndicator();
        } else {
          // Check if a user is signed in
          if (snapshot.hasData && snapshot.data != null) {
            // User is signed in, display the profile page
            User? user = snapshot.data;
            return _buildProfilePage(user);
          } else {
            // User is signed out, display a sign-in prompt or redirect to the sign-in page
            return const Center(
              child: Text('Please sign in to view your profile.'),
            );
          }
        }
      },
    );
  }

  Widget _buildProfilePage(User? user) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 60,
                backgroundImage: NetworkImage(user?.photoURL ?? ''),
              ),
              SizedBox(height: 20),
              Text(
                user?.displayName ?? '',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10),
              Text(
                user?.email ?? '',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              Text(
                'Birth Date: <Replace with birth date>',
                style: TextStyle(fontSize: 18),
              ),
              SignOutPage(),
            ],
          ),
        ),
      ),
    );
  }
}
