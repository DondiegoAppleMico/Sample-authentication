import 'package:flutter/material.dart';
import 'package:sample_auth/home/home_notes.dart';
import 'package:sample_auth/home/home_tasks.dart';
import 'package:sample_auth/home/home_timer.dart';

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
                  Icons.timer,
                  color: Color.fromARGB(255, 237, 218, 161),
                ),
                text: 'Timer'),
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
          TimerPage(),
        ],
      ),
    );
  }
}
