import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/models/models.dart';
import '../data/repositories/repositories.dart';
import 'providers.dart';

class TaskNotifier extends StateNotifier<TaskState> {
  final TaskRepository _taskRepository;

  TaskNotifier(this._taskRepository) : super(TaskState.initial()) {
    fetchTasks();
  }

  void fetchTasks() async {
    try {
      final tasks = await _taskRepository.getTasks();
      state = state.copyWith(tasks: tasks, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }

  int getCompletedTaskCount() {
    return state.tasks.where((task) => task.done).length;
  }

  void saveTask(Task task) {
    final updatedTasks = List<Task>.from(state.tasks)..add(task);
    state = state.copyWith(tasks: updatedTasks);
    _taskRepository.saveTask(task);
  }

  void updateTask(Task task) {
    final updatedTasks =
        state.tasks.map((t) => t.id == task.id ? task : t).toList();
    state = state.copyWith(tasks: updatedTasks);
    _taskRepository.updateTask(task);
  }

  void toggleCompletedVisibility() {
    state = state.copyWith(isCompletedVisible: !state.isCompletedVisible);
  }

  void markTaskAsDone(Task task) {
    final updatedTask = task.copyWith(done: true);
    final updatedTasks =
        state.tasks.map((t) => t.id == task.id ? updatedTask : t).toList();
    state = state.copyWith(tasks: updatedTasks);
    _taskRepository.updateTask(updatedTask);
  }

  void deleteTask(Task task) {
    final updatedTasks = state.tasks.where((t) => t.id != task.id).toList();
    state = state.copyWith(tasks: updatedTasks);
    _taskRepository.deleteTask(task.id);
  }
}
