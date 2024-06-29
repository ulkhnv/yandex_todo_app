enum TaskImportance {
  low("Низкая"),
  basic("Нет"),
  important("!! Высокая");

  const TaskImportance(this.name);

  final String name;
}

class Task {
  final String id;
  final String text;
  final TaskImportance importance;
  final DateTime? deadline;
  final bool done;

  Task({
    required this.id,
    required this.text,
    required this.importance,
    this.deadline,
    required this.done,
  });
}
