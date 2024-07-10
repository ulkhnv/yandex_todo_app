enum TaskImportance {
  low(),
  basic(),
  important();

  factory TaskImportance.fromJson(String value) {
    return TaskImportance.values.byName(value);
  }
}

class Task {
  final String id;
  final String text;
  final TaskImportance importance;
  final DateTime? deadline;
  final bool done;
  final String? color;
  final DateTime createdAt;
  final DateTime changedAt;
  final String lastUpdatedBy;

  Task({
    required this.id,
    required this.text,
    required this.importance,
    this.deadline,
    this.done = false,
    this.color,
    required this.createdAt,
    required this.changedAt,
    required this.lastUpdatedBy,
  });

  Task copyWith({
    String? id,
    String? text,
    TaskImportance? importance,
    DateTime? deadline,
    bool? done,
    String? color,
    DateTime? createdAt,
    DateTime? changedAt,
    String? lastUpdatedBy,
  }) {
    return Task(
      id: id ?? this.id,
      text: text ?? this.text,
      importance: importance ?? this.importance,
      deadline: deadline ?? this.deadline,
      done: done ?? this.done,
      color: color ?? this.color,
      createdAt: createdAt ?? this.createdAt,
      changedAt: changedAt ?? this.changedAt,
      lastUpdatedBy: lastUpdatedBy ?? this.lastUpdatedBy,
    );
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'] as String,
      text: json['text'] as String,
      importance: TaskImportance.fromJson(json['importance']),
      deadline: json['deadline'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['deadline'] as int)
          : null,
      done: json['done'] as bool,
      color: json['color'] as String?,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['created_at'] as int),
      changedAt: DateTime.fromMillisecondsSinceEpoch(json['changed_at'] as int),
      lastUpdatedBy: json['last_updated_by'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'text': text,
      'importance': importance.name,
      'deadline': deadline?.millisecondsSinceEpoch,
      'done': done,
      'color': color,
      'created_at': createdAt.millisecondsSinceEpoch,
      'changed_at': changedAt.millisecondsSinceEpoch,
      'last_updated_by': lastUpdatedBy,
    };
  }
}
