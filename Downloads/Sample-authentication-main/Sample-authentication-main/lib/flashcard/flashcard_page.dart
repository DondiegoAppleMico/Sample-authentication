import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';

class FlashcardPage extends StatefulWidget {
  @override
  _FlashcardPageState createState() => _FlashcardPageState();
}

class _FlashcardPageState extends State<FlashcardPage> {
  List<String> questions = ['unsang unsaon?', 'pato?', 'sheeshh'];
  List<String> answers = ['Ing ana', 'toya', 'shesh'];

  int currentQuestionIndex = 0;

  void nextQuestion() {
    setState(() {
      currentQuestionIndex = (currentQuestionIndex + 1) % questions.length;
    });
  }

  void previousQuestion() {
    setState(() {
      currentQuestionIndex =
          (currentQuestionIndex - 1 + questions.length) % questions.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Flashcards',
          style: TextStyle(
            fontFamily: 'Roboto',
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FlipCard(
                direction: FlipDirection.HORIZONTAL,
                front: Flashcard(
                  text: questions[currentQuestionIndex],
                  onTap: () {
                    setState(() {
                      currentQuestionIndex++;
                      if (currentQuestionIndex >= questions.length) {
                        currentQuestionIndex = 0;
                      }
                    });
                  },
                ),
                back: Flashcard(
                  text: answers[currentQuestionIndex],
                  onTap: () {
                    setState(() {
                      currentQuestionIndex++;
                      if (currentQuestionIndex >= questions.length) {
                        currentQuestionIndex = 0;
                      }
                    });
                  },
                ),
              ),
              SizedBox(height: 20.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: previousQuestion,
                    child: Text(
                      'Previous',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                  SizedBox(width: 20.0),
                  ElevatedButton(
                    onPressed: nextQuestion,
                    child: Text(
                      'Next',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Flashcard extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const Flashcard({required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Container(
          width: 300,
          height: 200,
          alignment: Alignment.center,
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
