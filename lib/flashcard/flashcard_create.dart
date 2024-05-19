import 'package:flutter/material.dart';
import 'creator.dart';

void main() async {
  runApp(CreateFlashcard());
}

class CreateFlashcard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: FlashcardCreator(),
    );
  }
}
