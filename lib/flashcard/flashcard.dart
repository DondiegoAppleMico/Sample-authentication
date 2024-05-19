class Flashcard {
  final String question;
  final String answer;
  bool showAnswer;

  Flashcard({
    required this.question,
    required this.answer,
    this.showAnswer = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
      'showAnswer': showAnswer,
    };
  }

  factory Flashcard.fromJson(Map<String, dynamic> json) {
    return Flashcard(
      question: json['question'],
      answer: json['answer'],
      showAnswer: json['showAnswer'] ?? false,
    );
  }
}
