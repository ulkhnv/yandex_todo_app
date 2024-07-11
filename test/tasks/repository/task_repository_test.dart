import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:yandex_todo_app/src/features/tasks/data/datasources/datasources.dart';
import 'package:yandex_todo_app/src/features/tasks/data/dto/dto.dart';
import 'package:yandex_todo_app/src/features/tasks/data/repositories/task_repository.dart';

import '../helpers/test_helpers.dart';
import 'task_repository_test.mocks.dart';

@GenerateMocks([TaskRemoteDataSource, TaskLocalDataSource, Connectivity])
void main() {
  late MockTaskRemoteDataSource mockRemoteDataSource;
  late MockTaskLocalDataSource mockLocalDataSource;
  late MockConnectivity mockConnectivity;
  late TaskRepository repository;

  setUp(() {
    mockRemoteDataSource = MockTaskRemoteDataSource();
    mockLocalDataSource = MockTaskLocalDataSource();
    mockConnectivity = MockConnectivity();
    repository = TaskRepository(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      connectivity: mockConnectivity,
    );
  });

  group('TaskRepository', () {
    test('getTasks returns local tasks when there is no connectivity',
        () async {
      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);
      when(mockLocalDataSource.getTasks())
          .thenAnswer((_) async => [createTestTask()]);

      final tasks = await repository.getTasks();

      expect(tasks, isNotEmpty);
      verify(mockLocalDataSource.getTasks()).called(1);
    });

    test('getTasks returns remote tasks and updates local storage when online',
        () async {
      final task = createTestTask();
      final taskResponse = TaskResponse(tasks: [task], revision: 1);

      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
      when(mockRemoteDataSource.getTasks())
          .thenAnswer((_) async => Future.value(taskResponse));
      when(mockLocalDataSource.isSynchronized()).thenReturn(true);

      final tasks = await repository.getTasks();

      expect(tasks, [task]);
      verify(mockRemoteDataSource.getTasks()).called(1);
      verify(mockLocalDataSource.saveTasks(taskResponse.tasks)).called(1);
      verify(mockLocalDataSource.saveRevision(taskResponse.revision)).called(1);
    });

    test('saveTask saves task locally and sets unsynchronized when offline',
        () async {
      final task = createTestTask();

      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);
      when(mockLocalDataSource.getRevision()).thenAnswer((_) => 1);

      await repository.saveTask(task);

      verify(mockLocalDataSource.saveTask(task)).called(1);
      verify(mockLocalDataSource.setSynchronized(false)).called(1);
    });

    test('saveTask saves task remotely and updates revision when online',
        () async {
      final task = createTestTask();

      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
      ;
      when(mockLocalDataSource.getRevision()).thenAnswer((_) => 1);

      await repository.saveTask(task);

      verify(mockRemoteDataSource.saveTask(task, 1)).called(1);
      verify(mockLocalDataSource.saveRevision(2)).called(1);
    });

    test('updateTask updates task locally and sets unsynchronized when offline',
        () async {
      final task = createTestTask();

      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);
      when(mockLocalDataSource.getRevision()).thenAnswer((_) => 1);

      await repository.updateTask(task);

      verify(mockLocalDataSource.updateTask(task)).called(1);
      verify(mockLocalDataSource.setSynchronized(false)).called(1);
    });

    test('updateTask updates task remotely and updates revision when online',
        () async {
      final task = createTestTask();

      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
      when(mockLocalDataSource.getRevision()).thenReturn(1);

      await repository.updateTask(task);

      verify(mockLocalDataSource.getRevision()).called(1);
      verify(mockRemoteDataSource.updateTask(task, 1)).called(1);
      ;
    });

    test('deleteTask deletes task locally and sets unsynchronized when offline',
        () async {
      final task = createTestTask();

      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.none);
      when(mockLocalDataSource.getRevision()).thenAnswer((_) => 1);

      await repository.deleteTask(task.id);

      verify(mockLocalDataSource.deleteTask(task.id)).called(1);
      verify(mockLocalDataSource.setSynchronized(false)).called(1);
    });

    test('deleteTask deletes task remotely and updates revision when online',
        () async {
      final task = createTestTask();

      when(mockConnectivity.checkConnectivity())
          .thenAnswer((_) async => ConnectivityResult.wifi);
      when(mockLocalDataSource.getRevision()).thenAnswer((_) => 1);

      await repository.deleteTask(task.id);

      verify(mockRemoteDataSource.deleteTask(task.id, 1)).called(1);
      verify(mockLocalDataSource.setSynchronized(false)).called(1);
    });
  });
}
