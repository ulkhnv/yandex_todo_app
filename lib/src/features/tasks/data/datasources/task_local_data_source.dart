import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/task.dart';

class TaskLocalDataSource {
  final SharedPreferences sharedPreferences;

  TaskLocalDataSource(this.sharedPreferences);

  static const String tasksKey = 'tasks';
  static const String revisionKey = 'revision';

  Future<List<Task>> getTasks() async {
    final tasksJson = sharedPreferences.getStringList(tasksKey);
    if (tasksJson == null) {
      return [];
    }
    return tasksJson
        .map((taskJson) => Task.fromJson(jsonDecode(taskJson)))
        .toList();
  }

  Future<void> saveTasks(List<Task> tasks) async {
    final tasksJson = tasks.map((task) => jsonEncode(task.toJson())).toList();
    await sharedPreferences.setStringList(tasksKey, tasksJson);
  }

  Future<void> saveTask(Task task) async {
    final tasks = await getTasks();
    tasks.add(task);
    await saveTasks(tasks);
  }

  Future<void> updateTask(Task task) async {
    final tasks = await getTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      tasks[index] = task;
      await saveTasks(tasks);
    }
  }

  Future<void> deleteTask(String id) async {
    final tasks = await getTasks();
    tasks.removeWhere((task) => task.id == id);
    await saveTasks(tasks);
  }

  int getRevision() {
    return sharedPreferences.getInt(revisionKey) ?? 0;
  }

  Future<void> saveRevision(int revision) async {
    await sharedPreferences.setInt(revisionKey, revision);
  }
}
