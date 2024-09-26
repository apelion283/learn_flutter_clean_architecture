import 'package:to_do_app/data/data_source/todo_database.dart';

abstract class TaskRepository {
  Future<List<Map<String, Object?>>> getAllTasks();
  Future<Map<String, Object?>> getTaskById(int taskId);
  Future<bool> deleteTaskById(int taskId);
  Future<List<Map<String, Object?>>> filterTask(bool isDone);
  Future<bool> updateTask(int taskId, Map<String, Object?> task);
}

class TaskRepositoryImpl implements TaskRepository {
  final TodoDatabase _database;
  TaskRepositoryImpl(this._database);
  @override
  Future<List<Map<String, Object?>>> getAllTasks() async {
    final tasks = _database.getAllTasks();
    return tasks;
  }

  @override
  Future<Map<String, Object?>> getTaskById(int taskId) {
    final task = _database.getTaskById(taskId);
    return task;
  }

  @override
  Future<bool> deleteTaskById(int taskId) {
    return _database.deleteTaskById(taskId);
  }

  @override
  Future<List<Map<String, Object?>>> filterTask(bool isDone) {
    return _database.filterTask(isDone);
  }

  @override
  Future<bool> updateTask(int taskId, Map<String, Object?> task) {
    return _database.updateTask(taskId, task);
  }
}
