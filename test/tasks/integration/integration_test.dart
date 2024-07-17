import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:yandex_todo_app/src/core/constants/theme/app_theme.dart';
import 'package:yandex_todo_app/src/core/utils/utils.dart';
import 'package:yandex_todo_app/src/features/tasks/data/models/task.dart';
import 'package:yandex_todo_app/src/features/tasks/data/repositories/task_repository.dart';
import 'package:yandex_todo_app/src/features/tasks/presentation/pages/pages.dart';
import 'package:yandex_todo_app/src/features/tasks/providers/providers.dart';
import 'integration_test.mocks.dart';

@GenerateMocks([TaskRepository])
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late MockTaskRepository mockTaskRepository;

  setUp(() {
    mockTaskRepository = MockTaskRepository();
  });

  testWidgets('should display tasks correctly', (WidgetTester tester) async {
    final task = Task(
      id: '1',
      text: 'Test Task',
      importance: TaskImportance.low,
      deadline: DateTime.now(),
      done: false,
      createdAt: DateTime.now(),
      changedAt: DateTime.now(),
      lastUpdatedBy: 'user1',
    );

    final taskState = TaskState(
      tasks: [task],
      isLoading: false,
      isCompletedVisible: true,
    );

    when(mockTaskRepository.getTasks()).thenAnswer((_) async => [task]);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          taskRepositoryProvider.overrideWith((ref) => mockTaskRepository),
          taskProvider.overrideWith(
            (ref) => TaskNotifier(mockTaskRepository)..state = taskState,
          ),
        ],
        child: MaterialApp(
          locale: S.ru,
          supportedLocales: S.supportedLocales,
          localizationsDelegates: S.localizationDelegates,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          home: const TaskPage(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    // Verify that the task is displayed
    expect(find.text('Test Task'), findsOneWidget);
  });
}
