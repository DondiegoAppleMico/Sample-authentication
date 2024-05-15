import 'package:flutter/material.dart';

class EditFlashcard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Flashcard'),
        backgroundColor: const Color.fromARGB(
            255, 145, 33, 243), // Set your desired color here
        automaticallyImplyLeading: false, // This removes the back button
      ),
      body: Center(
        child: Text('This is the Edit Flashcard page'),
      ),
    );
  }
}
