import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(TaskTracker());
}

class TaskTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Task Tracker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TaskTrackerHomePage(title: 'Task Tracker'),
    );
  }
}

class TaskTrackerHomePage extends StatefulWidget {
  TaskTrackerHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

@override
  _TaskTrackerHomePageState createState() => _TaskTrackerHomePageState();
}

class _TaskTrackerHomePageState extends State<TaskTrackerHomePage> {
  bool _running = false;
  int _workTime = 25 * 60;
  int _breakTime = 5 * 60;
  int _timeRemaining = 0;
  List<String> _tasks = [];
  Timer? _timer;

  void _startTimer() {
    if (!_running) {
      _running = true;
      _timer = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          _timeRemaining--;
        });
      });
    }
  }

  void _stopTimer() {
    _running = false;
    _timer?.cancel();
  }

  void _resetTimer() {
    _running = false;
    _timer?.cancel();
    setState(() {
      _timeRemaining = _workTime;
    });
  }

  Future<void> _saveTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('tasks', _tasks);
  }

  Future<void> _loadTasks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? loadedTasks = prefs.getStringList('tasks');
    if (loadedTasks != null) {
      setState(() {
        _tasks = loadedTasks;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _timeRemaining = _workTime;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: Icon(Icons.info),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('About Task Tracker'),
                    content: SingleChildScrollView(
                      child: ListBody(
                        children: <Widget>[
                          Text('Task Tracker App'),
                          Text('Version 1.0'),
                        ],
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        child: Text('OK'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Work Time: $_workTime seconds',
                  style: TextStyle(fontSize: 16),
                ),
                Text(
                  'Break Time: $_breakTime seconds',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              '$_timeRemaining',
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: _startTimer,
                  child: Text('Start'),
                ),
                ElevatedButton(
                  onPressed: _stopTimer,
                  child: Text('Stop'),
                ),
                ElevatedButton(
                  onPressed: _resetTimer,
                  child: Text('Reset'),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text(
              'Tasks',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Expanded(
              child: ListView.builder(
                itemCount: _tasks.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(_tasks[index]),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          _tasks.removeAt(index);
                        });
                      },
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        TextEditingController _controller =
                            TextEditingController();
                        return AlertDialog(
                          title: Text('Add Task'),
                          content: TextField(
                            controller: _controller,
                            decoration: InputDecoration(
                              labelText: 'Enter task',
                            ),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _tasks.add(_controller.text);
                                });
                                Navigator.pop(context);
                              },
                              child: Text('Add'),
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
                  },
                  child: Text('Add Task'),
                ),
                ElevatedButton(
  onPressed: _saveTasks,
  child: Text('Save Tasks'),
),
                ElevatedButton(
  onPressed: _loadTasks,
  child: Text('Load Tasks'),
),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

  

