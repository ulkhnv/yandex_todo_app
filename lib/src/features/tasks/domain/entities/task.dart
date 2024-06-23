import 'dart:ui';

enum TaskImportance {
  basic(),
  low(),
  important(),
}

class Task {
  final String id;
  final String text;
  final TaskImportance importance;
  final String? deadline;
  final bool done;
  final Color? color;
  final DateTime createdAt;
  final DateTime changedAt;
  final String lastUpdatedBy;

  Task(
      {required this.id,
      required this.text,
      required this.importance,
      this.deadline,
      required this.done,
      this.color,
      required this.createdAt,
      required this.changedAt,
      required this.lastUpdatedBy});
}
