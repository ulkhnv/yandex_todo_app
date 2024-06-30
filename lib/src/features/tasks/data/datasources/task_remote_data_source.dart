import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/models.dart';

class TaskRemoteDataSource {
  final Dio _dio;
  final String baseUrl = "https://beta.mrdekk.ru/todo";
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": dotenv.env['AUTHORIZATION']!,
  };

  TaskRemoteDataSource(this._dio);

  Future<List<Task>> getTasks() async {
    try {
      final response = await _dio.get(
        '$baseUrl/list',
        options: Options(headers: headers),
      );
      final List<dynamic> jsonTasks = response.data['list'];
      final tasks =
          jsonTasks.map((taskJson) => Task.fromJson(taskJson)).toList();
      return tasks;
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<Task> getTask(String id) async {
    try {
      final response = await _dio.get(
        '$baseUrl/list/$id',
        options: Options(headers: headers),
      );
      final task = Task.fromJson(response.data['element']);
      return task;
    } catch (e) {
      throw Exception('Failed to load task: $e');
    }
  }

  Future<void> patch(List<Task> tasks, int revision) async {
    try {
      await _dio.patch(
        '$baseUrl/list/',
        data: tasks.map((task) => task.toJson()).toList(),
        options: Options(
          headers: {
            ...headers,
            "X-Last-Known-Revision": "$revision",
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to patch tasks: $e');
    }
  }

  Future<void> saveTask(Task task, int revision) async {
    try {
      await _dio.post(
        '$baseUrl/list/',
        data: task.toJson(),
        options: Options(
          headers: {
            ...headers,
            "X-Last-Known-Revision": "$revision",
          },
        ),
      );
    } catch (e) {
      throw Exception('Failed to save task: $e');
    }
  }

  Future<Task> updateTask(Task task, int revision) async {
    try {
      final response = await _dio.put(
        '$baseUrl/list/${task.id}',
        data: task.toJson(),
        options: Options(
          headers: {
            ...headers,
            "X-Last-Known-Revision": "$revision",
          },
        ),
      );
      final updatedTask = Task.fromJson(response.data['element']);
      return updatedTask;
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  Future<Task> deleteTask(String id, int revision) async {
    try {
      final response = await _dio.delete(
        '$baseUrl/list/$id',
        options: Options(
          headers: {
            ...headers,
            "X-Last-Known-Revision": "$revision",
          },
        ),
      );
      final deletedTask = Task.fromJson(response.data['element']);
      return deletedTask;
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }
}
