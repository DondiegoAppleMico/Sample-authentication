import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_model.dart';

class QuizCreatorScreen extends StatefulWidget {
  final Quiz quiz;

  QuizCreatorScreen({required this.quiz});

  @override
  _QuizCreatorScreenState createState() => _QuizCreatorScreenState();
}

class _QuizCreatorScreenState extends State<QuizCreatorScreen>
    with SingleTickerProviderStateMixin {
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _addQuestion() {
    if (_questionController.text.isEmpty || _answerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question and Answer cannot be empty')),
      );
      return;
    }
    setState(() {
      widget.quiz.questions.add(
        Question(
          question: _questionController.text,
          answer: _answerController.text,
        ),
      );
      _questionController.clear();
      _answerController.clear();
    });
    _saveQuiz();
  }

  Future<void> _saveQuiz() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Quiz> quizzes = [];
    String? savedQuizzes = prefs.getString('savedQuizzes');
    if (savedQuizzes != null) {
      List<dynamic> decodedQuizzes = jsonDecode(savedQuizzes);
      quizzes = decodedQuizzes.map((q) => Quiz.fromJson(q)).toList();
    }
    quizzes = quizzes.map((q) {
      if (q.id == widget.quiz.id) {
        return widget.quiz;
      }
      return q;
    }).toList();
    String encodedQuizzes = jsonEncode(quizzes.map((q) => q.toJson()).toList());
    await prefs.setString('savedQuizzes', encodedQuizzes);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            _buildQuestionInput(),
            SizedBox(height: 20),
            _buildQuestionList(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionInput() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _questionController,
                decoration: InputDecoration(labelText: 'Enter your question'),
              ),
              TextField(
                controller: _answerController,
                decoration: InputDecoration(labelText: 'Enter the answer'),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addQuestion,
                child: Text('Add Question'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildQuestionList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Questions',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        for (var i = 0; i < widget.quiz.questions.length; i++)
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: Text(widget.quiz.questions[i].question),
              subtitle: Text('Answer: ${widget.quiz.questions[i].answer}'),
            ),
          ),
      ],
    );
  }
}
