import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:sample_auth/quiz/quiz_page.dart'; // Import the details screen you want to navigate to

void main() {
  runApp(QuizListScreen());
}

class QuizListScreen extends StatefulWidget {
  @override
  _QuizListScreenState createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  // Dummy list of quiz names, you can replace it with your actual data
  List<String> quizNames = [
    'Networking',
    'Networking liwat',
    'Networking 2',
    // Add more quiz names as needed
  ];

  // List to store colors of each quiz container
  List<Color> quizColors = [
    Color.fromARGB(255, 99, 57, 136),
    Color.fromARGB(255, 99, 57, 136),
    Color.fromARGB(255, 99, 57, 136),
    // Add more initial colors as needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz List'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: GridView.builder(
          itemCount: quizNames.length + 1,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
            mainAxisSpacing: 10.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            if (index == quizNames.length) {
              return GestureDetector(
                onTap: () {
                  _addQuiz();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width / 1,
                  height: MediaQuery.of(context).size.width / 1,
                  decoration: BoxDecoration(
                    color: Color.fromARGB(255, 158, 158, 158),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Icon(Icons.add, size: 50.0, color: Colors.white),
                ),
              );
            } else {
              return _buildQuizContainer(index);
            }
          },
        ),
      ),
    );
  }

  Widget _buildQuizContainer(int index) {
    return GestureDetector(
      onTap: () {
        // Navigate to the quiz details screen when tapped
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                QuizCreatorApp(), // Pass the quiz name to the details screen
          ),
        );
      },
      child: Hero(
        tag: 'quizContainer$index',
        child: Container(
          decoration: BoxDecoration(
            color: quizColors[index], // Use color from the quizColors list
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Text(
                    quizNames[index],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: 10.0,
                right: 0.0,
                child: Row(

                  children: [
                    TextButton(
                      onPressed: () {
                        _showColorEditDialog(index);
                      },
                      child: Icon(Icons.color_lens,
                          size: 25.0, color: Colors.white),
                    ),
                    SizedBox(width:110,),
                    TextButton(
                      onPressed: () {
                        _showEditDialog(index);
                      },
                      child: Icon(Icons.edit, size: 25.0, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditDialog(int index) {
    TextEditingController controller =
        TextEditingController(text: quizNames[index]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Quiz Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              hintText: 'Enter new name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  quizNames[index] = controller.text;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _showColorEditDialog(int index) {
    Color selectedColor = quizColors[index]; // Initial color

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Container Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: selectedColor,
              onColorChanged: (color) {
                setState(() {
                  selectedColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  quizColors[index] = selectedColor;
                });
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addQuiz() {
    setState(() {
      quizNames.add('New Quiz');
      quizColors.add(Color.fromARGB(255, 99, 57, 136),); // Add initial color for the new quiz
    });
  }
}
