import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:sample_auth/home/home_page.dart';
import 'package:sample_auth/quiz/quiz_list.dart';
import 'package:sample_auth/flashcard/flashcard_page.dart';
import 'package:sample_auth/profile/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

User? user = FirebaseAuth.instance.currentUser;

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePage(), // Placeholder for Home Page content
     QuizListScreen(),
     FlashcardPage(),
    const ProfilePage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: GNav(
        backgroundColor: Color.fromARGB(255, 32, 10, 51),
        color: Colors.white,
        activeColor: Color.fromARGB(255, 120, 118, 245),
        tabBackgroundColor: Color.fromARGB(255, 64, 52, 75),
        gap: 8,
        onTabChange: (index) {
          _onItemTapped(index);
        },
        tabs: const [
          GButton(icon: Icons.home, text: 'Home'),
          GButton(icon: Icons.quiz, text: 'Quiz'),
          GButton(icon: Icons.space_dashboard, text: 'Flashcard'),
          GButton(icon: Icons.person, text: 'Profile'),
        ],
      ),
    );
  }
}
