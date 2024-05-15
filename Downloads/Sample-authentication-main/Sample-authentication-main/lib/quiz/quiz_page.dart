import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sample_auth/quiz/quiz_list.dart';

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
      home: QuizCreatorHomePage(),
    );
  }
}

class QuizCreatorHomePage extends StatefulWidget {
  @override
  _QuizCreatorHomePageState createState() => _QuizCreatorHomePageState();
}

class _QuizCreatorHomePageState extends State<QuizCreatorHomePage>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> _questions = [];
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  final _quizAnswerController = TextEditingController();

  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizStarted = false;
  bool _quizFinished = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadQuiz();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  Future<void> _loadQuiz() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedQuiz = prefs.getString('savedQuiz');
    if (savedQuiz != null) {
      setState(() {
        List<dynamic> decodedQuiz = jsonDecode(savedQuiz);
        _questions.addAll(
            decodedQuiz.map((q) => Map<String, String>.from(q)).toList());
      });
    }
  }

  Future<void> _saveQuiz() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedQuiz = jsonEncode(_questions);
    await prefs.setString('savedQuiz', encodedQuiz);
  }

  void _addQuestion() {
    if (_questionController.text.isEmpty || _answerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Question and Answer cannot be empty')),
      );
      return;
    }
    setState(() {
      _questions.add({
        'question': _questionController.text,
        'answer': _answerController.text,
      });
      _questionController.clear();
      _answerController.clear();
    });
    _saveQuiz();
  }

  void _startQuiz() {
    setState(() {
      _quizStarted = true;
      _quizFinished = false;
      _currentQuestionIndex = 0;
      _score = 0;
    });
    _animationController.forward(from: 0.0);
  }

  void _submitAnswer() {
    setState(() {
      if (_quizAnswerController.text.toLowerCase() ==
          _questions[_currentQuestionIndex]['answer']!.toLowerCase()) {
        _score++;
      }
      _quizAnswerController.clear();
      if (_currentQuestionIndex < _questions.length - 1) {
        _currentQuestionIndex++;
        _animationController.forward(from: 0.0);
      } else {
        _quizFinished = true;
        _quizStarted = false;
      }
    });
  }

  void _resetQuiz() {
    setState(() {
      _quizFinished = false;
      _questions.clear();
    });
    _saveQuiz();
  }

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    _quizAnswerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz Creator'),
        actions: [
          IconButton(
            icon: Icon(Icons.list),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => QuizListScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (!_quizStarted && !_quizFinished) ...[
              _buildQuestionInput(),
              SizedBox(height: 20),
              _buildQuestionList(),
              if (_questions.isNotEmpty) ...[
                SizedBox(height: 20),
                _buildStartQuizButton(),
              ],
            ],
            if (_quizStarted) ...[
              _buildQuizQuestion(),
            ],
            if (_quizFinished) ...[
              _buildQuizResults(),
            ],
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
        for (var i = 0; i < _questions.length; i++)
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            padding: EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: ListTile(
              title: Text(_questions[i]['question']!),
              subtitle: Text('Answer: ${_questions[i]['answer']}'),
            ),
          ),
      ],
    );
  }

  Widget _buildStartQuizButton() {
    return ElevatedButton(
      onPressed: _startQuiz,
      child: Text('Start Quiz'),
    );
  }

  Widget _buildQuizQuestion() {
    return FadeTransition(
      opacity: _animation,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${_currentQuestionIndex + 1}/${_questions.length}',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.yellow[100],
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _questions[_currentQuestionIndex]['question']!,
                  style: TextStyle(fontSize: 18),
                ),
                TextField(
                  controller: _quizAnswerController,
                  decoration: InputDecoration(labelText: 'Your answer'),
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _submitAnswer,
                  child: Text('Submit Answer'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuizResults() {
    return Column(
      children: [
        Text(
          'You scored $_score out of ${_questions.length}!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        ElevatedButton(
          onPressed: _resetQuiz,
          child: Text('Create a new Quiz'),
        ),
      ],
    );
  }
}
