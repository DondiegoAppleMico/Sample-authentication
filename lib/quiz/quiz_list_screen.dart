import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'quiz_model.dart';
import 'quiz_creator_screen.dart';
import 'quiz_taker_screen.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  List<Quiz> _quizzes = [];
  bool _deleteMode = false;
  int? _selectedIndex;

  @override
  void initState() {
    super.initState();
    _loadQuizzes();
  }

  Future<void> _loadQuizzes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedQuizzes = prefs.getString('savedQuizzes');
    if (savedQuizzes != null) {
      setState(() {
        List<dynamic> decodedQuizzes = jsonDecode(savedQuizzes);
        _quizzes = decodedQuizzes.map((q) => Quiz.fromJson(q)).toList();
      });
    }
  }

  Future<void> _saveQuizzes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodedQuizzes =
        jsonEncode(_quizzes.map((q) => q.toJson()).toList());
    await prefs.setString('savedQuizzes', encodedQuizzes);
  }

  void _createNewQuiz(String title, Color color) {
    setState(() {
      _quizzes.add(Quiz(
          id: DateTime.now().toString(),
          title: title,
          questions: [],
          color: color));
    });
    _saveQuizzes();
  }

  void _deleteQuiz(int index) {
    setState(() {
      _quizzes.removeAt(index);
    });
    _saveQuizzes();
  }

  void _changeQuizColor(int index, Color color) {
    setState(() {
      _quizzes[index] = Quiz(
        id: _quizzes[index].id,
        title: _quizzes[index].title,
        questions: _quizzes[index].questions,
        color: color,
      );
    });
    _saveQuizzes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Quiz List',
            style: TextStyle(
              color: Color.fromARGB(
                  255, 207, 179, 220), // White color for the text
              fontSize: 24.0, // Bigger font size
              fontWeight: FontWeight.bold, // Optional: to make the text bold
            ),
          ),
        ),
        backgroundColor: Color.fromARGB(255, 25, 22, 29),
        actions: [
          IconButton(
            icon: Icon(
              _deleteMode ? Icons.cancel : Icons.delete,
              size: 30,
              color: _deleteMode ? Colors.white : Colors.red,
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
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/BGspace.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: _quizzes.length,
            itemBuilder: (context, index) {
              return Card(
                color: _quizzes[index].color,
                child: GestureDetector(
                  onTap: () {
                    if (_deleteMode) {
                      setState(() {
                        _selectedIndex = index;
                      });
                      _showDeleteConfirmationDialog(index);
                    } else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              QuizCreatorScreen(quiz: _quizzes[index]),
                        ),
                      ).then((value) {
                        _saveQuizzes();
                      });
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      color: _selectedIndex == index
                          ? Colors.redAccent
                          : _quizzes[index].color,
                      borderRadius: const BorderRadius.all(Radius.circular(30)),
                    ),
                    child: ListTile(
                      title: Text(
                        _quizzes[index].title,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 37, 31, 76)),
                      ),
                      trailing: _deleteMode
                          ? IconButton(
                              icon: const Icon(
                                Icons.delete,
                                size: 30,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                _showDeleteConfirmationDialog(index);
                              },
                            )
                          : Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.color_lens,
                                    size: 30,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  onPressed: () {
                                    _showColorPickerDialog(index);
                                  },
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.play_arrow,
                                    size: 40,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => QuizTakerScreen(
                                            quiz: _quizzes[index]),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Color.fromARGB(255, 55, 5, 55),
        onPressed: () {
          _showAddQuizDialog();
        },
        child: Icon(
          Icons.add,
          color: Color.fromARGB(177, 255, 255, 255),
        ),
      ),
    );
  }

  void _showAddQuizDialog() {
    final _titleController = TextEditingController();
    Color _selectedColor = Colors.white;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors
              .transparent, // Makes the default dialog background transparent
          child: Container(
            decoration: BoxDecoration(
              color:
                  Color.fromARGB(255, 176, 141, 230), // Light purple background
              borderRadius: BorderRadius.circular(15.0), // Rounded corners
            ),
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'New Quiz',
                  style: TextStyle(
                    color: const Color.fromARGB(255, 55, 9, 136),
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Quiz Title',
                    labelStyle: TextStyle(
                        color: Color.fromARGB(255, 55, 9, 136), fontSize: 22),
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 55, 9, 136)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color.fromARGB(255, 55, 9, 136)),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    const Text(
                      'Select Color:',
                      style: TextStyle(
                          color: Color.fromARGB(255, 55, 9, 136), fontSize: 15),
                    ),
                    const SizedBox(width: 20),
                    Flexible(
                      child: TextButton(
                        onPressed: () {
                          _showColorPickerDialogForNewQuiz((color) {
                            setState(() {
                              _selectedColor = color;
                            });
                          });
                        },
                        child: const Icon(
                          Icons.color_lens,
                          size: 30,
                          color: Color.fromARGB(
                              255, 55, 9, 136), // Deep purple icon
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                            color: Color.fromARGB(255, 55, 9, 136),
                            fontSize: 18), // Deep purple text
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    SizedBox(width: 8),
                    TextButton(
                      child: const Text(
                        'Create',
                        style: TextStyle(
                            color: Color.fromARGB(255, 55, 9, 136),
                            fontSize: 18), // Deep purple text
                      ),
                      onPressed: () {
                        if (_titleController.text.isNotEmpty) {
                          _createNewQuiz(_titleController.text, _selectedColor);
                          Navigator.of(context).pop();
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showColorPickerDialog(int index) {
    Color currentColor = _quizzes[index].color ?? Colors.white;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: currentColor,
              onColorChanged: (Color color) {
                currentColor = color;
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Apply'),
              onPressed: () {
                _changeQuizColor(index, currentColor);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showColorPickerDialogForNewQuiz(Function(Color) onColorChanged) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Color'),
          content: SingleChildScrollView(
            child: BlockPicker(
              pickerColor: Colors.white,
              onColorChanged: (color) {
                onColorChanged(color);
                Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  void _showDeleteConfirmationDialog(int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Quiz'),
          content: Text('Are you sure you want to delete this quiz?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                _deleteQuiz(index);
                setState(() {
                  _deleteMode = false;
                  _selectedIndex = null;
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
