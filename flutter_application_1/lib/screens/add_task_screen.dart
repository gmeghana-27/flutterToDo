import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/task.dart';
import '../services/storage_service.dart';

class AddTaskScreen extends StatefulWidget {
  
  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  Priority _selectedPriority = Priority.low;
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();

  void _saveTask() async {
    if (_titleController.text.isEmpty) return;

    final storage = StorageService();
    final currentTasks = await storage.loadTasks();

    final fullDeadline = DateTime(
      _selectedDate.year, _selectedDate.month, _selectedDate.day,
      _selectedTime.hour, _selectedTime.minute,
    );

    final newTask = Task(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text,
      description: _descController.text,
      priority: _selectedPriority,
      deadline: fullDeadline,
    );

    currentTasks.add(newTask);
    await storage.saveTasks(currentTasks);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Create New Task")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(controller: _titleController, decoration: const InputDecoration(labelText: "Task Title", border: OutlineInputBorder())),
            const SizedBox(height: 15),
            TextField(controller: _descController, maxLines: 3, decoration: const InputDecoration(labelText: "Description", border: OutlineInputBorder())),
            const SizedBox(height: 20),
            const Text("Select Priority", style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: Priority.values.map((p) => Expanded(
                child: RadioListTile<Priority>(
                  title: Text(p.name.toUpperCase(), style: const TextStyle(fontSize: 12)),
                  value: p,
                  groupValue: _selectedPriority,
                  onChanged: (val) => setState(() => _selectedPriority = val!),
                ),
              )).toList(),
            ),
            ListTile(
              title: Text("Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
              trailing: const Icon(Icons.calendar_month),
              onTap: () async {
                final date = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2030));
                if (date != null) setState(() => _selectedDate = date);
              },
            ),
            ListTile(
              title: Text("Time: ${_selectedTime.format(context)}"),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final time = await showTimePicker(context: context, initialTime: TimeOfDay.now());
                if (time != null) setState(() => _selectedTime = time);
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(onPressed: _saveTask, child: const Text("SAVE TASK")),
            )
          ],
        ),
      ),
    );
  }
}