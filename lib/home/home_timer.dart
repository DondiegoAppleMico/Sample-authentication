import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(
    home: TimerPage(),
  ));
}

class TimerPage extends StatefulWidget {
  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage>
    with SingleTickerProviderStateMixin {
  int workDuration = 25; // default 25 minutes for work
  int breakDuration = 5; // default 5 minutes for break
  int remainingTime = 0; // in seconds
  bool isRunning = false;
  bool isWorkTime = true;
  Timer? timer;
  late AnimationController _controller;

  TextEditingController workController = TextEditingController();
  TextEditingController breakController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(minutes: workDuration),
    );
    remainingTime = workDuration * 60;
  }

  void startTimer() {
    setState(() {
      isRunning = true;
    });

    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (remainingTime > 0) {
          remainingTime--;
          _controller.value =
              (workDuration * 60 - remainingTime) / (workDuration * 60);
        } else {
          if (isWorkTime) {
            remainingTime = breakDuration * 60;
            _controller.duration = Duration(minutes: breakDuration);
          } else {
            remainingTime = workDuration * 60;
            _controller.duration = Duration(minutes: workDuration);
          }
          isWorkTime = !isWorkTime;
          _controller.reset();
          _controller.forward();
        }
      });
    });

    _controller.forward();
  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isRunning = false;
    });
    _controller.stop();
  }

  void resetTimer() {
    stopTimer();
    setState(() {
      remainingTime = isWorkTime ? workDuration * 60 : breakDuration * 60;
    });
    _controller.reset();
  }

  void setDurations() {
    setState(() {
      workDuration = int.tryParse(workController.text) ?? workDuration;
      breakDuration = int.tryParse(breakController.text) ?? breakDuration;
      if (isWorkTime) {
        remainingTime = workDuration * 60;
        _controller.duration = Duration(minutes: workDuration);
      } else {
        remainingTime = breakDuration * 60;
        _controller.duration = Duration(minutes: breakDuration);
      }
      _controller.reset();
    });
  }

  String formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '$minutes:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    timer?.cancel();
    _controller.dispose();
    workController.dispose();
    breakController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pomodoro Timer',
          style: TextStyle(
            fontSize: 30,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w600,
            color: Colors.amber,
          ),
        ),
        backgroundColor: Color.fromARGB(255, 32, 10, 51),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/timerBG.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.all(20.0),
              decoration: BoxDecoration(
                color: Colors.grey.withOpacity(0.5),
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return CircularProgressIndicator(
                        value: _controller.value,
                        strokeWidth: 8.0,
                        valueColor: AlwaysStoppedAnimation<Color>(
                            isWorkTime ? Colors.red : Colors.green),
                      );
                    },
                  ),
                  SizedBox(height: 20),
                  Text(
                    formatTime(remainingTime),
                    style: TextStyle(
                      fontSize: 48,
                      color: Color.fromARGB(255, 42, 217, 80),
                      fontWeight: FontWeight.bold, // Enhancing visibility
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: isRunning ? stopTimer : startTimer,
                        child: Text(
                          isRunning ? 'Stop' : 'Start',
                          style: TextStyle(
                              fontWeight:
                                  FontWeight.bold), // Enhancing visibility
                        ),
                      ),
                      SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: resetTimer,
                        child: Text(
                          'Reset',
                          style: TextStyle(
                              fontWeight:
                                  FontWeight.bold), // Enhancing visibility
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 50.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: workController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Work Duration (minutes)',
                            labelStyle: TextStyle(
                                color: Colors.white), // Enhancing visibility
                          ),
                        ),
                        TextField(
                          controller: breakController,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: 'Break Duration (minutes)',
                            labelStyle: TextStyle(
                                color: Colors.white), // Enhancing visibility
                          ),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: setDurations,
                          child: Text(
                            'Set Durations',
                            style: TextStyle(
                                fontWeight:
                                    FontWeight.bold), // Enhancing visibility
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
