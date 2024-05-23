import 'package:flutter/material.dart';
import 'package:flip_card/flip_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'flashcard.dart';
import 'dart:convert';

class FlashcardCreator extends StatefulWidget {
  @override
  _FlashcardCreatorState createState() => _FlashcardCreatorState();
}

class _FlashcardCreatorState extends State<FlashcardCreator> {
  List<Flashcard> flashcards = [];
  String flashcardListName = 'Flashcard List';
  String question = '';
  String answer = '';

  @override
  void initState() {
    super.initState();
    _loadFlashcards();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(flashcardListName),
          backgroundColor: Color.fromARGB(255, 25, 22, 29),
          foregroundColor: Colors.amber,
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/FCCspace.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 218, 192, 98),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      onChanged: (value) {
                        question = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Question',
                      ),
                    ),
                    SizedBox(height: 8.0),
                    TextField(
                      onChanged: (value) {
                        answer = value;
                      },
                      decoration: InputDecoration(
                        labelText: 'Answer',
                      ),
                    ),
                    SizedBox(height: 8.0),
                    ElevatedButton(
                      onPressed: () {
                        _createFlashcard();
                      },
                      child: Text('Create Flashcard',
                          style: TextStyle(fontSize: 15)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: GridView.builder(
                  padding: EdgeInsets.all(25.0),
                  itemCount: flashcards.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8.0,
                    mainAxisSpacing: 8.0,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildFlashcardItem(index);
                  },
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Padding(
                  padding: EdgeInsets.all(30.0),
                  child: FloatingActionButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              FlashcardPlayer(flashcards: flashcards),
                        ),
                      );
                    },
                    child: Icon(Icons.play_arrow),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  Widget _buildFlashcardItem(int index) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: Card(
        color: Color.fromARGB(255, 196, 143, 189), // Change front color
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'Q: ${flashcards[index].question}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      back: Card(
        color: Color.fromARGB(255, 80, 101, 222), // Change back color
        child: Container(
          alignment: Alignment.center,
          child: Text('A: ${flashcards[index].answer}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber)),
        ),
      ),
    );
  }

  void _createFlashcard() {
    if (question.isNotEmpty && answer.isNotEmpty) {
      setState(() {
        flashcards.add(
          Flashcard(
            question: question,
            answer: answer,
          ),
        );
        question = '';
        answer = '';
        _saveFlashcards();
      });
    }
  }

  void _saveFlashcards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<Map<String, dynamic>> flashcardsJson =
        flashcards.map((flashcard) => flashcard.toJson()).toList();
    prefs.setStringList(
        'flashcards', flashcardsJson.map((json) => jsonEncode(json)).toList());
  }

  void _loadFlashcards() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? flashcardsJson = prefs.getStringList('flashcards');
    if (flashcardsJson != null) {
      setState(() {
        flashcards = flashcardsJson
            .map((json) => Flashcard.fromJson(jsonDecode(json)))
            .toList();
      });
    }
  }
}

class FlashcardPlayer extends StatefulWidget {
  final List<Flashcard> flashcards;

  FlashcardPlayer({required this.flashcards});

  @override
  _FlashcardPlayerState createState() => _FlashcardPlayerState();
}

class _FlashcardPlayerState extends State<FlashcardPlayer> {
  late PageController _pageController;
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flashcard Player'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: 350,
            width: 350,
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemCount: widget.flashcards.length,
              itemBuilder: (BuildContext context, int index) {
                return _buildFlashcardItem(index);
              },
            ),
          ),
          SizedBox(height: 70),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () {
                  _pageController.previousPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease);
                },
                icon: Icon(
                  Icons.arrow_back,
                  size: 35,
                ),
              ),
              Text(
                'Card ${currentIndex + 1} of ${widget.flashcards.length}',
                style: TextStyle(fontSize: 25),
              ),
              IconButton(
                onPressed: () {
                  _pageController.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.ease);
                },
                icon: Icon(Icons.arrow_forward, size: 35),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlashcardItem(int index) {
    return FlipCard(
      direction: FlipDirection.HORIZONTAL,
      front: Card(
        color: Color.fromARGB(255, 196, 143, 189), // Change front color
        child: Container(
          alignment: Alignment.center,
          child: Text(
            'Q: ${widget.flashcards[index].question}',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
      ),
      back: Card(
        color: Color.fromARGB(255, 80, 101, 222), // Change back color
        child: Container(
          alignment: Alignment.center,
          child: Text('A: ${widget.flashcards[index].answer}',
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber)),
        ),
      ),
    );
  }
}
