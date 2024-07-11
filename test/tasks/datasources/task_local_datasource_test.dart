import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:yandex_todo_app/src/features/tasks/data/datasources/datasources.dart';
import '../helpers/test_helpers.dart';
import 'task_local_datasource_test.mocks.dart';

@GenerateMocks([SharedPreferences])
void main() {
  late MockSharedPreferences mockSharedPreferences;
  late TaskLocalDataSource dataSource;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = TaskLocalDataSource(mockSharedPreferences);
  });

  group('TaskLocalDataSource', () {
    test('getTasks returns empty list when no tasks are stored', () async {
      when(mockSharedPreferences.getStringList(TaskLocalDataSource.tasksKey))
          .thenReturn(null);

      final tasks = await dataSource.getTasks();

      expect(tasks, isEmpty);
    });

    test('getTasks returns list of tasks when tasks are stored', () async {
      final task = createTestTask();
      final tasksJson = [jsonEncode(task.toJson())];
      when(mockSharedPreferences.getStringList(TaskLocalDataSource.tasksKey))
          .thenReturn(tasksJson);

      final tasks = await dataSource.getTasks();

      expect(tasks, isNotEmpty);
      expect(tasks.length, 1);
      expect(tasks.first.id, '1');
    });

    test('saveTasks stores tasks in shared preferences', () async {
      final task = createTestTask();
      final tasks = [task];

      when(mockSharedPreferences.setStringList(
        TaskLocalDataSource.tasksKey,
        any,
      )).thenAnswer((_) async => true);

      await dataSource.saveTasks(tasks);

      verify(mockSharedPreferences.setStringList(
        TaskLocalDataSource.tasksKey,
        tasks.map((task) => jsonEncode(task.toJson())).toList(),
      )).called(1);
    });

    test('saveTask adds a task to shared preferences', () async {
      final task = createTestTask();

      when(mockSharedPreferences.getStringList(TaskLocalDataSource.tasksKey))
          .thenReturn(null);

      when(mockSharedPreferences.setStringList(
        TaskLocalDataSource.tasksKey,
        any,
      )).thenAnswer((_) async => true);

      await dataSource.saveTask(task);

      verify(mockSharedPreferences.setStringList(
        TaskLocalDataSource.tasksKey,
        [jsonEncode(task.toJson())],
      )).called(1);
    });

    test('updateTask updates an existing task in shared preferences', () async {
      final existingTask = createTestTask();
      final tasksJson = [jsonEncode(existingTask.toJson())];
      when(mockSharedPreferences.getStringList(TaskLocalDataSource.tasksKey))
          .thenReturn(tasksJson);

      when(mockSharedPreferences.setStringList(
        TaskLocalDataSource.tasksKey,
        any,
      )).thenAnswer((_) async => true);

      final updatedTask = existingTask.copyWith(text: 'Updated Task 1');

      await dataSource.updateTask(updatedTask);

      verify(mockSharedPreferences.setStringList(
        TaskLocalDataSource.tasksKey,
        [jsonEncode(updatedTask.toJson())],
      )).called(1);
    });

    test('deleteTask removes a task from shared preferences', () async {
      final existingTask = createTestTask();
      final tasksJson = [jsonEncode(existingTask.toJson())];
      when(mockSharedPreferences.getStringList(TaskLocalDataSource.tasksKey))
          .thenReturn(tasksJson);

      when(mockSharedPreferences.setStringList(
        TaskLocalDataSource.tasksKey,
        any,
      )).thenAnswer((_) async => true);

      await dataSource.deleteTask('1');

      verify(mockSharedPreferences.setStringList(
        TaskLocalDataSource.tasksKey,
        [],
      )).called(1);
    });

    test('getRevision returns revision from shared preferences', () {
      when(mockSharedPreferences.getInt(TaskLocalDataSource.revisionKey))
          .thenReturn(1);

      final revision = dataSource.getRevision();

      expect(revision, 1);
    });

    test('saveRevision stores revision in shared preferences', () async {
      when(mockSharedPreferences.setInt(
        TaskLocalDataSource.revisionKey,
        any,
      )).thenAnswer((_) async => true);

      await dataSource.saveRevision(1);

      verify(mockSharedPreferences.setInt(TaskLocalDataSource.revisionKey, 1))
          .called(1);
    });

    test(
        'isSynchronized returns synchronization status from shared preferences',
        () {
      when(mockSharedPreferences.getBool(TaskLocalDataSource.synchronizedKey))
          .thenReturn(true);

      final isSynchronized = dataSource.isSynchronized();

      expect(isSynchronized, isTrue);
    });

    test('setSynchronized stores synchronization status in shared preferences',
        () async {
      when(mockSharedPreferences.setBool(
        TaskLocalDataSource.synchronizedKey,
        any,
      )).thenAnswer((_) async => true);

      await dataSource.setSynchronized(true);

      verify(mockSharedPreferences.setBool(
              TaskLocalDataSource.synchronizedKey, true))
          .called(1);
    });
  });
}
