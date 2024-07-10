import 'models.dart';

class TaskResponse {
  final List<Task> tasks;
  final int revision;

  TaskResponse({required this.tasks, required this.revision});
}