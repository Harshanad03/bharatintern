import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Image.network(
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcS8i0ql8z9MY_t5VJVSIs242mcvb-5FcfymfQ&usqp=CAU",
              errorBuilder: (context, error, stackTrace) {
                return Text('Image not available');
              },
            ),
          ),
          SizedBox(height: 30),
          Text(
            "Manage Your",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 10),
          Text(
            "Everyday Task List",
            style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 40),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color.fromARGB(255, 228, 231, 233),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => TaskListPage()),
                );
              },
              child: Text("Get Started"),
            ),
          ),
        ],
      ),
      backgroundColor: Color.fromARGB(255, 251, 251, 251),
    );
  }
}

class TaskListPage extends StatefulWidget {
  const TaskListPage({super.key});

  @override
  State<TaskListPage> createState() => _TaskListPageState();
}

class _TaskListPageState extends State<TaskListPage> {
  final List<Map<String, dynamic>> _tasks = [];
  final TextEditingController _textFieldController = TextEditingController();

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _addTask(String task, DateTime date, TimeOfDay time) {
    setState(() {
      _tasks.add({
        'task': task,
        'completed': false,
        'date': date,
        'time': time,
      });
    });
    _textFieldController.clear();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _displayAddTaskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add a new task'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              TextField(
                controller: _textFieldController,
                decoration: InputDecoration(hintText: 'Enter task here'),
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text(
                      'Date: ${_selectedDate.toLocal().toString().split(' ')[0]}'),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectDate(context),
                    child: Text('Select Date'),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Row(
                children: <Widget>[
                  Text('Time: ${_selectedTime.format(context)}'),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => _selectTime(context),
                    child: Text('Select Time'),
                  ),
                ],
              ),
            ],
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
                _addTask(
                    _textFieldController.text, _selectedDate, _selectedTime);
                Navigator.of(context).pop();
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          final date = task['date'];
          final time = task['time'];

          return ListTile(
            leading: Checkbox(
              value: task['completed'],
              onChanged: (bool? value) {
                setState(() {
                  task['completed'] = value!;
                });
              },
            ),
            title: Text(
              task['task'],
              style: TextStyle(
                fontSize: 18, // Adjust the font size here
                decoration: task['completed']
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
              ),
            ),
            subtitle: Text(
              '${date.toLocal().toString().split(' ')[0]} ${time.format(context)}',
              style: TextStyle(fontSize: 16),
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                _deleteTask(index);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _displayAddTaskDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}
