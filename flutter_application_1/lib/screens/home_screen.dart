import 'package:flutter/material.dart';
import '../models/task.dart';
import '../services/storage_service.dart';
import 'add_task_screen.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> _tasks = [];
  final _storage = StorageService();

  @override
  void initState() {
    super.initState();
    _refreshTasks();
  }

  _refreshTasks() async {
    final data = await _storage.loadTasks();
    setState(() => _tasks = data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Dashboard"), elevation: 0),
      body: ListView.builder(
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Card(
            margin: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            shape: RoundedRectangleBorder(side: BorderSide(color: task.priorityColor, width: 2), borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              title: Text(task.title, style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text("${task.description}\nDue: ${DateFormat('MMM d, h:mm a').format(task.deadline)}"),
              isThreeLine: true,
              trailing: Checkbox(
                value: task.isCompleted,
                onChanged: (val) {
                  setState(() {
                    task.isCompleted = val!;
                    task.completedAt = val ? DateTime.now() : null;
                  });
                  _storage.saveTasks(_tasks);
                },
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (_) => AddTaskScreen()));
          _refreshTasks();
        },
      ),
    );
  }
}