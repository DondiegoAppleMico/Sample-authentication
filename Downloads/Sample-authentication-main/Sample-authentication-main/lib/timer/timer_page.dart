import 'package:flutter/material.dart';
import 'dart:async';

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with TickerProviderStateMixin {
  TimeOfDay _selectedTime = TimeOfDay.now();
  bool _isTimerRunning = false;
  late Timer _timer;

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 1.0, end: 0.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (pickedTime != null && pickedTime != _selectedTime) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _startTimer() {
    int secondsUntilAlarm = _calculateSecondsUntilAlarm();

    if (secondsUntilAlarm <= 0) {
      return;
    }

    _timer = Timer(Duration(seconds: secondsUntilAlarm), () {
      _showAlarmDialog();
    });

    setState(() {
      _isTimerRunning = true;
    });

    _controller.repeat(reverse: true);
  }

  void _stopTimer() {
    _timer.cancel();
    setState(() {
      _isTimerRunning = false;
    });
    _controller.stop();
  }

  int _calculateSecondsUntilAlarm() {
    final now = DateTime.now();
    final selectedTime = DateTime(
        now.year, now.month, now.day, _selectedTime.hour, _selectedTime.minute);

    return selectedTime.difference(now).inSeconds;
  }

  void _showAlarmDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alarm'),
          content: Text('Time is up!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Timer'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimatedBuilder(
              animation: _animation,
              builder: (BuildContext context, Widget? child) {
                return Transform.scale(
                  scale: _animation.value,
                  child: Text(
                    'Selected Time: ${_selectedTime.format(context)}',
                    style: TextStyle(fontSize: 20),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _selectTime(context),
              child: Text('Select Time'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isTimerRunning ? _stopTimer : _startTimer,
              child: Text(_isTimerRunning ? 'Stop Timer' : 'Start Timer'),
            ),
          ],
        ),
      ),
    );
  }
}
