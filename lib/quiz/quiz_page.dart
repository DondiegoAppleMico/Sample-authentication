import 'package:flutter/material.dart';
import 'quiz_list_screen.dart';

void main() {
  runApp(QuizCreatorApp());
}

class QuizCreatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz Creator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: QuizListScreen(),
    );
  }
}
