import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/task.dart';

class StorageService {
  static const String _taskKey = 'user_tasks';
  static const String _userKey = 'auth_user';

  // Save Tasks
  Future<void> saveTasks(List<Task> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = jsonEncode(tasks.map((t) => t.toJson()).toList());
    await prefs.setString(_taskKey, encoded);
  }

  // Load Tasks
  Future<List<Task>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString(_taskKey);
    if (data == null) return [];
    return (jsonDecode(data) as List).map((t) => Task.fromJson(t)).toList();
  }

  // Local JSON Auth
  Future<bool> signup(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    return await prefs.setString(_userKey, jsonEncode({'email': email, 'pass': password}));
  }

  Future<bool> login(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_userKey);
    if (data == null) return false;
    final user = jsonDecode(data);
    return user['email'] == email && user['pass'] == password;
  }
}