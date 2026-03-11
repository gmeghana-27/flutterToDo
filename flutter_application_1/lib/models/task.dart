import 'package:flutter/material.dart';

enum Priority { low, medium, high }

class Task {
  String id;
  String title;
  String description;
  Priority priority;
  DateTime deadline;
  bool isCompleted;
  DateTime? completedAt;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.priority,
    required this.deadline,
    this.isCompleted = false,
    this.completedAt,
  });

  // Color logic based on priority
  Color get priorityColor {
    switch (priority) {
      case Priority.high: return Colors.redAccent;
      case Priority.medium: return Colors.orangeAccent;
      case Priority.low: return Colors.greenAccent;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id, 'title': title, 'description': description,
    'priority': priority.index, 'deadline': deadline.toIso8601String(),
    'isCompleted': isCompleted, 'completedAt': completedAt?.toIso8601String(),
  };

  factory Task.fromJson(Map<String, dynamic> json) => Task(
    id: json['id'], title: json['title'], description: json['description'],
    priority: Priority.values[json['priority']],
    deadline: DateTime.parse(json['deadline']),
    isCompleted: json['isCompleted'],
    completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
  );
}