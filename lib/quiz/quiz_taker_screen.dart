import 'package:flutter/material.dart';
import 'quiz_model.dart';

class QuizTakerScreen extends StatefulWidget {
  final Quiz quiz;

  QuizTakerScreen({required this.quiz});

  @override
  _QuizTakerScreenState createState() => _QuizTakerScreenState();
}

class _QuizTakerScreenState extends State<QuizTakerScreen>
    with SingleTickerProviderStateMixin {
  int _currentQuestionIndex = 0;
  int _score = 0;
  bool _quizFinished = false;
  late AnimationController _animationController;
  late Animation<double> _animation;
  final _quizAnswerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  void _submitAnswer() {
    setState(() {
      if (_quizAnswerController.text.toLowerCase() ==
          widget.quiz.questions[_currentQuestionIndex].answer.toLowerCase()) {
        _score++;
      }
      _quizAnswerController.clear();
      if (_currentQuestionIndex < widget.quiz.questions.length - 1) {
        _currentQuestionIndex++;
        _animationController.forward(from: 0.0);
      } else {
        _quizFinished = true;
      }
    });
  }

  @override
  void dispose() {
    _quizAnswerController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _quizFinished ? _buildQuizResults() : _buildQuizQuestion(),
      ),
    );
  }

  Widget _buildQuizQuestion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question ${_currentQuestionIndex + 1}/${widget.quiz.questions.length}',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        Text(
          widget.quiz.questions[_currentQuestionIndex].question,
          style: TextStyle(fontSize: 18),
        ),
        SizedBox(height: 20),
        TextField(
          controller: _quizAnswerController,
          decoration: InputDecoration(
            labelText: 'Your answer',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            onPressed: _submitAnswer,
            child: Text('Submit Answer'),
          ),
        ),
      ],
    );
  }

  Widget _buildQuizResults() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'You scored $_score out of ${widget.quiz.questions.length}!',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  }
}
