import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_model.dart';
import 'quiz_creator_screen.dart';
import 'quiz_taker_screen.dart';

class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  List<Quiz> _quizzes = [];

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedQuizzes = prefs.getString('savedQuizzes');
    if (savedQuizzes != null) {
      setState(() {
        List<dynamic> decodedQuizzes = jsonDecode(savedQuizzes);
        _quizzes = decodedQuizzes.map((q) => Quiz.fromJson(q)).toList();
      });
    }
  }

  Future<void> _saveQuizzes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedQuizzes =
        jsonEncode(_quizzes.map((q) => q.toJson()).toList());
    await prefs.setString('savedQuizzes', encodedQuizzes);
  }

  void _createNewQuiz(String title) {
    setState(() {
      _quizzes.add(
          Quiz(id: DateTime.now().toString(), title: title, questions: []));
    });
    _saveQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz List'),
      ),
      body: ListView.builder(
        itemCount: _quizzes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_quizzes[index].title),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QuizCreatorScreen(quiz: _quizzes[index]),
                ),
              ).then((value) {
                _saveQuizzes();
              });
            },
            trailing: IconButton(
              icon: Icon(Icons.play_arrow),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        QuizTakerScreen(quiz: _quizzes[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddQuizDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddQuizDialog() {
    final _titleController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Quiz'),
          content: TextField(
            controller: _titleController,
            decoration: InputDecoration(labelText: 'Quiz Title'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Create'),
              onPressed: () {
                if (_titleController.text.isNotEmpty) {
                  _createNewQuiz(_titleController.text);
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
