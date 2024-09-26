class TaskState {
  List<Map<String, Object?>> listTask;
  TaskState copyWith(List<Map<String, Object?>> data) {
    return TaskState(data);
  }

  TaskState(this.listTask);
}
