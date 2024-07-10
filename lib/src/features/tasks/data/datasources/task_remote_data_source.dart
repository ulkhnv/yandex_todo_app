import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../models/models.dart';
import '../models/task_response.dart';

class TaskRemoteDataSource {
  final Dio _dio;
  final String baseUrl = "https://beta.mrdekk.ru/todo/list";
  final Map<String, String> headers = {
    "Content-Type": "application/json",
    "Authorization": dotenv.env['AUTHORIZATION']!,
  };

  TaskRemoteDataSource(this._dio);

  Future<TaskResponse> getTasks() async {
    try {
      final response = await _dio.get(
        baseUrl,
        options: Options(headers: headers),
      );
      final List<dynamic> jsonTasks = response.data['list'];
      final tasks =
          jsonTasks.map((taskJson) => Task.fromJson(taskJson)).toList();
      final revision = response.data['revision'];
      return TaskResponse(tasks: tasks, revision: revision);
    } catch (e) {
      throw Exception('Failed to load tasks: $e');
    }
  }

  Future<Task> getTask(String id) async {
    try {
      final response = await _dio.get(
        '$baseUrl/$id',
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
        baseUrl,
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
        baseUrl,
        data: {
          'element': task.toJson(),
        },
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
        '$baseUrl/${task.id}',
        data: {
          'element': task.toJson(),
        },
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
        '$baseUrl/$id',
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
