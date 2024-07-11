import '../data/models/models.dart';

class TaskState {
  final List<Task> tasks;
  final bool isLoading;
  final bool isCompletedVisible;

  TaskState({
    required this.tasks,
    required this.isLoading,
    this.isCompletedVisible = true,
  });

  factory TaskState.initial() => TaskState(tasks: [], isLoading: true);

  TaskState copyWith({
    List<Task>? tasks,
    bool? isLoading,
    bool? isCompletedVisible,
  }) {
    return TaskState(
      tasks: tasks ?? this.tasks,
      isLoading: isLoading ?? this.isLoading,
      isCompletedVisible: isCompletedVisible ?? this.isCompletedVisible,
    );
  }
}
