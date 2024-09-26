class Task {
  final int id;
  final String name;
  final String description;
  final String createDate;
  final String deadline;
  final int priority;
  final bool isDone;

  Task(
      {required this.id,
      required this.name,
      required this.description,
      required this.createDate,
      required this.deadline,
      required this.priority,
      required this.isDone});
}
