import 'package:flutter/material.dart';

class Quiz {
  String id;
  String title;
  List<Question> questions;
  final Color color;

  Quiz(
      {required this.id,
      required this.title,
      required this.questions,
      required this.color});

  factory Quiz.fromJson(Map<String, dynamic> json) {
    return Quiz(
      id: json['id'],
      title: json['title'],
      questions:
          (json['questions'] as List).map((q) => Question.fromJson(q)).toList(),
      color: Color(json['color'] ?? 0xFFFFFFFF),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'questions': questions.map((q) => q.toJson()).toList(),
      'color': color.value,
    };
  }
}

class Question {
  String question;
  String answer;

  Question({required this.question, required this.answer});

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      question: json['question'],
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}
