class Task {
  final int id;
  String name;
  String description;
  String createDate;
  String deadline;
  int priority;
  int isDone;

  Task(
      {required this.id,
      required this.name,
      required this.description,
      required this.createDate,
      required this.deadline,
      required this.priority,
      required this.isDone});

  factory Task.fromMap(Map<String, Object?> map) {
    return Task(
      id: map['id'] as int,
      name: map['name'] as String,
      description: map['description'] as String,
      createDate: map['create_at'] as String,
      deadline: map['deadline'] as String,
      priority: map['priority'] as int,
      isDone: map['is_done'] as int,
    );
  }
}
