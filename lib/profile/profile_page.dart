import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'edit_profile_ui.dart';
import 'package:sample_auth/sign_in/sign_in.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final ImagePicker _picker = ImagePicker();

  Future<void> _signOut(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      final GoogleSignIn _googleSignIn = GoogleSignIn();
      await _googleSignIn.signOut();
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => SignIn()),
        (route) => false,
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
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Sign Out'),
              onPressed: () {
                Navigator.of(context).pop();
                _signOut(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(User? user) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null && user != null) {
      File imageFile = File(pickedFile.path);
      try {
        Reference storageRef = FirebaseStorage.instance
            .ref()
            .child('user_profiles')
            .child('${user.uid}.jpg');
        await storageRef.putFile(imageFile);
        String downloadURL = await storageRef.getDownloadURL();
        await user.updatePhotoURL(downloadURL);
        await user.reload();
        User? updatedUser = FirebaseAuth.instance.currentUser;

        setState(() {
          user = updatedUser;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully')),
        );
      } catch (e) {
        print('Error updating profile picture: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update profile picture')),
        );
      }
    }
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
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        backgroundColor: Colors.grey[200],
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
                      child: GestureDetector(
                        onTap: () => _pickImage(user),
                        child: Container(
                          height: 25,
                          width: 25,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink,
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                          child:
                              Icon(Icons.edit, color: Colors.white, size: 16),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                Text(
                  user?.displayName ?? 'User',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
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
                  ListTile(
                    leading: Icon(Icons.edit, color: Colors.pink),
                    title: Text('Edit profile'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => EditProfileUI(),
                        ),
                      );
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.bar_chart, color: Colors.teal),
                    title: Text('My stats'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Handle My Stats tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.lock, color: Colors.deepPurple),
                    title: Text('Change Password'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Handle Change Password tap
                    },
                  ),
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.info, color: Colors.black),
                    title: Text('About Us'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () {
                      // Handle About Us tap
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Sign Out'),
                    trailing: Icon(Icons.arrow_forward_ios),
                    onTap: () => _showSignOutDialog(context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
