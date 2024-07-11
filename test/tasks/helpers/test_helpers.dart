import 'package:yandex_todo_app/src/features/tasks/data/models/models.dart';

Task createTestTask({String id = '1', String text = 'Task 1'}) {
  return Task(
    id: id,
    text: text,
    importance: TaskImportance.low,
    deadline: DateTime.now(),
    done: false,
    createdAt: DateTime.now(),
    changedAt: DateTime.now(),
    lastUpdatedBy: 'user1',
  );
}
