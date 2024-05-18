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
  bool _deleteMode = false;
  int? _selectedIndex;

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
        title: Text(widget.quiz.title,
            style: const TextStyle(
                color: Color.fromARGB(255, 249, 170, 232),
                fontSize: 28,
                fontWeight: FontWeight.bold)),
        backgroundColor: Color.fromARGB(255, 45, 23, 77),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,
              color: Colors.white), // Adjust color here
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.delete,
              size: 30,
              color: _deleteMode
                  ? Colors.red
                  : Colors.white, // Change color to indicate delete mode
            ),
            onPressed: () {
              setState(() {
                _deleteMode = !_deleteMode;
                _selectedIndex = null;
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/BGspace.jpg"), // Adjust image path
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              _buildQuestionInput(),
              SizedBox(height: 20),
              _buildQuestionList(),
            ],
          ),
        ),
      ),
      backgroundColor: Color.fromARGB(255, 224, 154, 154),
    );
  }

  Widget _buildQuestionInput() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(30.0),
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 162, 218, 226),
            borderRadius: BorderRadius.circular(15.0),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 234, 65, 217).withOpacity(0.5),
                spreadRadius: 10,
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _questionController,
                decoration: InputDecoration(
                  labelText: 'Enter your question',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _answerController,
                decoration: const InputDecoration(
                  labelText: 'Enter the answer',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                ),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _addQuestion,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  padding: EdgeInsets.symmetric(horizontal: 26, vertical: 12),
                  textStyle: TextStyle(fontSize: 18),
                ),
                child: Text('Add Question',
                    style: TextStyle(
                      color: Color.fromARGB(255, 234, 230,
                          236), // White color for the text // Bigger font size
                      fontWeight:
                          FontWeight.bold, // Optional: to make the text bold
                    )),
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
        SizedBox(
          height: 50,
        ),
        Text(
          'Questions',
          style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 237, 220, 220)),
        ),
        SizedBox(height: 10),
        for (var i = 0; i < widget.quiz.questions.length; i++)
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            padding: EdgeInsets.all(15.0),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 142, 179, 214),
              borderRadius: BorderRadius.circular(15.0),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                widget.quiz.questions[i].question,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              subtitle: Text('Answer: ${widget.quiz.questions[i].answer}',
                  style: TextStyle(fontSize: 16)),
              trailing: _deleteMode
                  ? IconButton(
                      icon: Icon(
                        Icons.delete,
                        color: Colors.red,
                        size: 30,
                      ),
                      onPressed: () {
                        setState(() {
                          widget.quiz.questions.removeAt(i);
                          _saveQuiz();
                        });
                      },
                    )
                  : null,
            ),
          ),
      ],
    );
  }
}
