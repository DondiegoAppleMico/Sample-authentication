import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class QuizHistoryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz History'),
        ),
        body: Center(
          child: Text('You need to be logged in to see your quiz history.'),
        ),
      );
    }

    CollectionReference quizzes = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('quizzes');

    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz History'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/Qhist.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          StreamBuilder<QuerySnapshot>(
            stream: quizzes.orderBy('timestamp', descending: true).snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

              var quizHistory = snapshot.data!.docs;

              if (quizHistory.isEmpty) {
                return Center(
                  child: Text('No quiz history available.'),
                );
              }

              return ListView.builder(
                itemCount: quizHistory.length,
                itemBuilder: (context, index) {
                  var quizData = quizHistory[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                QuizDetailPage(quizData: quizData),
                          ),
                        );
                      },
                      child: Hero(
                        tag: quizData.id,
                        child: Card(
                          color: Color.fromARGB(255, 244, 225, 225).withOpacity(
                              0.8), // Make the card slightly transparent
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(10),
                            leading: const Icon(
                              Icons.quiz,
                              color: Colors.deepPurple,
                              size: 40,
                            ),
                            title: Text(
                              quizData['quizTitle'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            subtitle: Text(
                              'Score: ${quizData['score']}/${quizData['totalQuestions']}',
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${(quizData['score'] / quizData['totalQuestions'] * 100).toStringAsFixed(0)}%',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                const Text(
                                  'Tap for details',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Color.fromARGB(255, 167, 118, 231),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class QuizDetailPage extends StatelessWidget {
  final QueryDocumentSnapshot quizData;

  QuizDetailPage({required this.quizData});

  @override
  Widget build(BuildContext context) {
    double scorePercentage = (quizData['score'] / quizData['totalQuestions']);

    return Scaffold(
      appBar: AppBar(
        title: Text(quizData['quizTitle']),
        backgroundColor: Colors.deepPurple,
      ),
      body: Stack(
        children: [
          // Background image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/Qhist.jpg'), // Replace with your image path
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Content
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Hero(
              tag: quizData.id,
              child: Card(
                color: Color.fromARGB(255, 170, 253, 252)
                    .withOpacity(0.8), // Make the card slightly transparent
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        quizData['quizTitle'],
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 25,
                          color: Colors.deepPurple,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      CircularPercentIndicator(
                        radius: 100.0,
                        lineWidth: 20.0,
                        percent: scorePercentage,
                        center: new Text(
                          "${(scorePercentage * 100).toStringAsFixed(1)}%",
                          style: TextStyle(
                            fontSize: 25.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple,
                          ),
                        ),
                        progressColor: Colors.deepPurple,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Score:',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${quizData['score']}/${quizData['totalQuestions']}',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Percentage:',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${(scorePercentage * 100).toStringAsFixed(1)}%',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.w500,
                              color: Colors.deepPurple,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
