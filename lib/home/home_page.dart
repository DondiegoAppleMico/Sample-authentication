import 'package:flutter/material.dart';

class ScreenHome extends StatefulWidget {
  @override
  _ScreenHomeState createState() => _ScreenHomeState();
}

class _ScreenHomeState extends State<ScreenHome>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'COGNISPACE',
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 25, color: Colors.amber),
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(
                icon: Icon(
                  Icons.note,
                  color: Color.fromARGB(255, 237, 218, 161),
                ),
                text: 'Notes'),
            Tab(
                icon: Icon(
                  Icons.check_box,
                  color: Color.fromARGB(255, 237, 218, 161),
                ),
                text: 'Tasks'),
            Tab(
                icon: Icon(
                  Icons.settings,
                  color: Color.fromARGB(255, 237, 218, 161),
                ),
                text: 'Settings'),
          ],
        ),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: Color.fromARGB(255, 25, 22, 29),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          NotesPage(),
          TasksPage(),
          SettingsPage(),
        ],
      ),
    );
  }
}

class NotesPage extends StatefulWidget {
  @override
  _NotesPageState createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  List<String> _notes = [];

  void _addNote() {
    setState(() {
      _notes.add('Note ${_notes.length + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_notes[index]),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addNote,
        tooltip: 'Add Note',
        child: Icon(Icons.add),
      ),
    );
  }
}

class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Tasks Page'),
    );
  }
}

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Settings Page'),
    );
  }
}
