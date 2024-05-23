import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'edit_profile_ui.dart'; // Adjust this import as needed
import 'package:sample_auth/sign_in/sign_in.dart'; // Adjust this import as needed
import 'package:sample_auth/quiz/quiz_history.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sign Out'),
          content: Text('Are you sure you want to sign out?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Sign Out'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                _signOut(context); // Sign out the user
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          if (snapshot.hasData && snapshot.data != null) {
            User? user = snapshot.data;
            return _buildProfilePage(context, user);
          } else {
            return const Center(
              child: Text('Please sign in to view your profile.'),
            );
          }
        }
      },
    );
  }

  Widget _buildProfilePage(BuildContext context, User? user) {
    return FutureBuilder<DocumentSnapshot>(
      future:
          FirebaseFirestore.instance.collection('users').doc(user?.uid).get(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData && snapshot.data != null) {
          var userData = snapshot.data!.data() as Map<String, dynamic>?;
          return Scaffold(
            backgroundColor: Color.fromARGB(255, 241, 178, 245),
            appBar: AppBar(
              backgroundColor: Color.fromARGB(255, 241, 178, 245),
              elevation: 0,
              automaticallyImplyLeading: false,
              title: Text(
                'COGNISPACE',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 25,
                  color: Colors.black,
                ),
              ),
              centerTitle: true,
            ),
            body: Column(
              children: [
                Center(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(user?.photoURL ??
                                    'https://cdn.pixabay.com/photo/2024/05/11/06/47/tropical-8754092_640.jpg'),
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              height: 25,
                              width: 25,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.pink,
                                border:
                                    Border.all(color: Colors.white, width: 2),
                              ),
                              child: Icon(Icons.edit,
                                  color: Colors.white, size: 16),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        userData?['username'] ?? user?.displayName ?? 'User',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Text(
                        user?.email ?? 'user@example.com',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: ListView(
                      children: [
                        SizedBox(
                          height: 40,
                        ),
                        ListTile(
                          leading: Icon(Icons.edit, color: Colors.pink),
                          title: Text(
                            'Edit profile',
                            style: TextStyle(fontSize: 17),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 20,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditProfile(userData: userData),
                              ),
                            ).then((_) {
                              // Refresh the profile page after returning from edit
                              (context as Element).reassemble();
                            });
                          },
                        ),
                        ListTile(
                          leading: Icon(Icons.bar_chart, color: Colors.teal),
                          title:
                              Text('My stats', style: TextStyle(fontSize: 17)),
                          trailing: Icon(Icons.arrow_forward_ios, size: 20),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => QuizHistoryPage()),
                            );
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Divider(),
                        SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          leading: Icon(Icons.logout, color: Colors.red),
                          title:
                              Text('Sign Out', style: TextStyle(fontSize: 17)),
                          trailing: Icon(Icons.arrow_forward_ios, size: 20),
                          onTap: () => _showSignOutDialog(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        } else {
          return const Center(
            child: Text('Failed to load profile data.'),
          );
        }
      },
    );
  }
}
