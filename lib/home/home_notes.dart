import 'package:flutter/material.dart';

// Custom class representing a note
class Note {
  final String title;
  final String subtitle;
  final String content;

  Note({
    required this.title,
    required this.subtitle,
    required this.content,
  });
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<Note> _notes = [];

  @override
  void initState() {
    super.initState();
    // Add an initial note when the NotesPage is loaded
    _addNote();
  }

  void _addNote() {
    setState(() {
      _notes.add(Note(
        title: 'Initial Title',
        subtitle: 'Initial Subtitle',
        content: 'Initial Content',
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notes',
          style: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            color: Colors.amber,
          ),
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 32, 10, 51),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/notesBG.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.builder(
          itemCount: _notes.length,
          itemBuilder: (context, index) {
            return _buildListItem(_notes[index]);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the screen where users can create a new note
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CreateNotePage()),
          );
        },
        tooltip: 'Add Note',
        child: Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.white,
      ),
    );
  }

  Widget _buildListItem(Note note) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          note.title,
          style: TextStyle(fontSize: 18),
        ),
        onTap: () {
          _navigateToNoteDetailPage(context, note);
        },
      ),
    );
  }
}

// Screen for creating a new note
class CreateNotePage extends StatefulWidget {
  @override
  _CreateNotePageState createState() => _CreateNotePageState();
}

class _CreateNotePageState extends State<CreateNotePage> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _subtitleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Note'),
        backgroundColor: Color.fromARGB(255, 32, 10, 51),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: _subtitleController,
              decoration: InputDecoration(labelText: 'Subtitle'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Content'),
              maxLines: null,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Create a new Note object with the entered data
                Note newNote = Note(
                  title: _titleController.text,
                  subtitle: _subtitleController.text,
                  content: _contentController.text,
                );

                Navigator.pop(context, newNote);
              },
              child: Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}

// Screen for viewing/editing a note
class NoteDetail extends StatefulWidget {
  final String title;
  final String subtitle;
  final String content;

  NoteDetail({
    required this.title,
    required this.subtitle,
    required this.content,
  });

  @override
  _NoteDetailState createState() => _NoteDetailState();
}

class _NoteDetailState extends State<NoteDetail> {
  late TextEditingController _titleController;
  late TextEditingController _subtitleController;
  late TextEditingController _contentController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.title);
    _subtitleController = TextEditingController(text: widget.subtitle);
    _contentController = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _subtitleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              // Save the changes
              _saveChanges();
            },
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _subtitleController,
              decoration: InputDecoration(
                labelText: 'Subtitle',
              ),
            ),
            SizedBox(height: 8),
            TextField(
              controller: _contentController,
              maxLines: null, // Allow multiple lines for content
              decoration: InputDecoration(
                labelText: 'Content',
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _saveChanges() {
    // Get the updated text from the text controllers
    String updatedTitle = _titleController.text;
    String updatedSubtitle = _subtitleController.text;
    String updatedContent = _contentController.text;

    // You can now use these updated values to save the changes or update the note in your database or state management solution.
    // For now, let's just print them.
    print('Updated Title: $updatedTitle');
    print('Updated Subtitle: $updatedSubtitle');
    print('Updated Content: $updatedContent');
  }
}

void _navigateToNoteDetailPage(BuildContext context, Note note) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => NoteDetail(
        title: note.title,
        subtitle: note.subtitle,
        content: note.content,
      ),
    ),
  );
}
