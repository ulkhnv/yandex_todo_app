import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yandex_todo_app/src/features/tasks/data/datasources/datasources.dart';

import '../helpers/test_helpers.dart';
import 'task_remote_datasource_test.mocks.dart';

@GenerateMocks([Dio])
void main() {
  late MockDio mockDio;
  late TaskRemoteDataSource dataSource;

  setUp(() async {
    mockDio = MockDio();
    await dotenv.load();
    dataSource = TaskRemoteDataSource(mockDio);
  });

  group('TaskRemoteDataSource', () {
    test('getTasks returns TaskResponse when the call completes successfully',
        () async {
      final task = createTestTask();
      final tasksJson = [task.toJson()];
      final responseJson = {"list": tasksJson, "revision": 1};

      when(mockDio.get(
        any,
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: responseJson,
            statusCode: 200,
          ));

      final result = await dataSource.getTasks();

      expect(result.tasks, isNotEmpty);
      expect(result.revision, 1);
      expect(result.tasks.first.id, '1');
    });

    test('getTask returns Task when the call completes successfully', () async {
      final task = createTestTask();
      final taskJson = task.toJson();

      when(mockDio.get(
        any,
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: {"element": taskJson},
            statusCode: 200,
          ));

      final result = await dataSource.getTask('1');

      expect(result.id, '1');
      expect(result.text, 'Task 1');
    });

    test('patch sends a patch request successfully', () async {
      final task = createTestTask();

      when(mockDio.patch(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
          ));

      await dataSource.patch([task], 1);

      verify(mockDio.patch(
        any,
        data: {
          'list': [task.toJson()]
        },
        options: anyNamed('options'),
      )).called(1);
    });

    test('saveTask sends a post request successfully', () async {
      final task = createTestTask();

      when(mockDio.post(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            statusCode: 200,
          ));

      await dataSource.saveTask(task, 1);

      verify(mockDio.post(
        any,
        data: {'element': task.toJson()},
        options: anyNamed('options'),
      )).called(1);
    });

    test('updateTask sends a put request successfully and returns updated Task',
        () async {
      final task = createTestTask();

      final updatedTaskJson = {
        ...task.toJson(),
        "text": "Updated Task 1",
      };

      when(mockDio.put(
        any,
        data: anyNamed('data'),
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: {"element": updatedTaskJson},
            statusCode: 200,
          ));

      final result =
          await dataSource.updateTask(task.copyWith(text: 'Updated Task 1'), 1);

      expect(result.text, 'Updated Task 1');
    });

    test(
        'deleteTask sends a delete request successfully and returns deleted Task',
        () async {
      final task = createTestTask();
      final taskJson = task.toJson();

      when(mockDio.delete(
        any,
        options: anyNamed('options'),
      )).thenAnswer((_) async => Response(
            requestOptions: RequestOptions(path: ''),
            data: {"element": taskJson},
            statusCode: 200,
          ));

      final result = await dataSource.deleteTask('1', 1);

      expect(result.id, '1');
      expect(result.text, 'Task 1');
    });
  });
}
