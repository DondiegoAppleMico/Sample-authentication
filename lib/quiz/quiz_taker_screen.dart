import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart'; // Import CircularPercentIndicator
import 'quiz_model.dart';
import 'quiz_percentage.dart';
import 'package:confetti/confetti.dart'; // Import Confetti package

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
  late Animation<Offset> _animation;
  final _quizAnswerController = TextEditingController();
  late ConfettiController _confettiController = ConfettiController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration:
          const Duration(seconds: 1), // 1-second duration for the animation
      vsync: this,
    );
    _animation = Tween<Offset>(
      begin: Offset(1.0, 0.0),
      end: Offset(0.0, 0.0),
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _animationController.forward();
    _confettiController = ConfettiController(duration: Duration(seconds: 5));
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

  void _skipQuestion() {
    setState(() {
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
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.quiz.title),
        backgroundColor: Colors.deepPurple,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 109, 60, 245),
              Color.fromARGB(255, 218, 115, 194)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _quizFinished ? _buildQuizResults() : _buildQuizQuestion(),
        ),
      ),
    );
  }

  Widget _buildQuizQuestion() {
    return Center(
      child: SlideTransition(
        position: _animation,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              'Question ${_currentQuestionIndex + 1}/${widget.quiz.questions.length}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 227, 214, 173),
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              widget.quiz.questions[_currentQuestionIndex].question,
              style: const TextStyle(
                  fontSize: 22,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            TextField(
              controller: _quizAnswerController,
              decoration: const InputDecoration(
                labelText: 'Your answer',
                labelStyle: TextStyle(color: Color.fromARGB(255, 43, 40, 138)),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 43, 40, 138), width: 3),
                ),
                enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                        color: Color.fromARGB(255, 43, 40, 138), width: 3),
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                      color: Color.fromARGB(255, 43, 40, 138), width: 3),
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                ),
              ),
              style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _skipQuestion,
                  child: Text(
                    'Skip',
                    style: TextStyle(
                        fontSize: 14,
                        color: Color.fromARGB(255, 196, 191, 191)),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 104, 44, 116),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
                ElevatedButton(
                  onPressed: _submitAnswer,
                  child: Text(
                    'Submit',
                    style: TextStyle(fontSize: 18, color: Colors.amber),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 67, 17, 70),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuizResults() {
    String message;
    if (_score / widget.quiz.questions.length < 0.41) {
      message = "Nice Try!";
    } else if (_score / widget.quiz.questions.length < 0.81) {
      message = "Well Done!";
    } else {
      message = "Excellent!!";
      _confettiController?.play();
      // Start confetti animation
      // You can use a package like 'flutter_confetti' for confetti animation
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'You scored $_score out of ${widget.quiz.questions.length}!',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 217, 231, 148),
            ),
          ),
          SizedBox(height: 20),
          Text(
            message,
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 217, 231, 148),
            ),
          ),
          SizedBox(height: 20),
          // Display quiz statistics with circular percentage animation
          CircularPercentIndicator(
            radius: 90.0,
            lineWidth: 25.0,
            percent: _score / widget.quiz.questions.length,
            center: Text(
              "${(_score / widget.quiz.questions.length * 100).toStringAsFixed(0)}%",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            progressColor: Color.fromARGB(255, 64, 50, 224),
          ),
          SizedBox(height: 80),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Icon(
              Icons.arrow_forward,
              size: 25,
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 217, 231, 148),
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
          ),
          ConfettiWidget(
            confettiController: _confettiController,
            blastDirectionality: BlastDirectionality.explosive,
            emissionFrequency: 0.05,
            numberOfParticles: 20,
            maxBlastForce: 100,
            minBlastForce: 80,
            gravity: 0.05,
          ),
        ],
      ),
    );
  }
}
