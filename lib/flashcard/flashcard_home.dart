import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'creator.dart';

class FlashcardListHome extends StatefulWidget {
  @override
  _FlashcardListHomeState createState() => _FlashcardListHomeState();
}

class _FlashcardListHomeState extends State<FlashcardListHome> {
  List<String> flashcardNames = ['Flashcard 1', 'Flashcard 2'];
  List<Color> flashcardColors = [
    Color.fromARGB(255, 122, 19, 166),
    const Color.fromARGB(255, 122, 19, 166)
  ]; // Initial colors
  bool _deleteMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Flashcards',
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
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/FCCspace.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        padding: EdgeInsets.all(20.0),
        child: GridView.builder(
          itemCount: flashcardNames.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 30.0,
            mainAxisSpacing: 20.0,
          ),
          itemBuilder: (BuildContext context, int index) {
            return _buildFlashcardContainer(index);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _addFlashcard();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildFlashcardContainer(int index) {
    return GestureDetector(
      onTap: () {
        if (!_deleteMode) {
          _navigateToDetail(flashcardNames[index]);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          color: flashcardColors[index],
          borderRadius: BorderRadius.circular(15.0),
          // Rounded borders
        ),
        padding: EdgeInsets.all(10.0), // Add padding around the container
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    flashcardNames[index],
                    style: TextStyle(
                      fontWeight: FontWeight.bold, // Make text bold
                      fontSize: 18.0, // Optional: Adjust font size
                      color: Color.fromARGB(
                          255, 177, 203, 209), // Optional: Set text color
                    ),
                    textAlign: TextAlign.center, // Center align the text
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: TextButton(
                onPressed: () {
                  _showEditDialog(context, index);
                },
                child: Icon(
                  Icons.edit,
                  size: 25,
                  color: const Color.fromARGB(255, 42, 32, 4),
                ),
              ),
            ),
            if (_deleteMode)
              Positioned(
                top: 0,
                right: 0,
                child: IconButton(
                  icon: Icon(
                    Icons.delete,
                    color: Colors.red,
                    size: 35,
                  ),
                  onPressed: () {
                    _deleteFlashcard(index);
                  },
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              child: TextButton(
                onPressed: () {
                  _showColorPickerDialog(context, index);
                },
                child: Icon(
                  Icons.color_lens,
                  size: 25,
                  color: Color.fromARGB(255, 44, 3, 3),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addFlashcard() {
    setState(() {
      flashcardNames.add('Flashcard ${flashcardNames.length + 1}');
      flashcardColors.add(const Color.fromARGB(
          255, 206, 201, 201)); // Add default color for new flashcard
    });
  }

  void _navigateToDetail(String flashcardName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlashcardCreator(),
      ),
    );
  }

  void _editFlashcardName(int index, String newName) {
    setState(() {
      flashcardNames[index] = newName;
    });
  }

  void _deleteFlashcard(int index) {
    setState(() {
      flashcardNames.removeAt(index);
      flashcardColors.removeAt(index);
    });
  }

  void _showEditDialog(BuildContext context, int index) {
    TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Flashcard Name'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: 'New Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String newName = controller.text;
                _editFlashcardName(index, newName);
                Navigator.pop(context);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _showColorPickerDialog(BuildContext context, int index) {
    Color pickerColor = flashcardColors[index];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select Color'),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: pickerColor,
              onColorChanged: (Color color) {
                setState(() {
                  pickerColor = color;
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  flashcardColors[index] = pickerColor;
                });
                Navigator.of(context).pop();
              },
              child: Text('Select'),
            ),
          ],
        );
      },
    );
  }
}
