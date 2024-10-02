import 'package:to_do_app/data/data_source/todo_database.dart';
import 'package:to_do_app/domain/models/task.dart';

abstract class TaskRepository {
  Future<List<Map<String, Object?>>> getAllTasks();
  Future<bool> addTask(Task task);
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
    final tasks = await _database.getAllTasks();
    return tasks;
  }

  @override
  Future<Map<String, Object?>> getTaskById(int taskId) async {
    final task = await _database.getTaskById(taskId);
    return task;
  }

  @override
  Future<bool> addTask(Task task) async {
    return await _database.addTask(task);
  }

  @override
  Future<bool> deleteTaskById(int taskId) async {
    return await _database.deleteTaskById(taskId);
  }

  @override
  Future<List<Map<String, Object?>>> filterTask(bool isDone) async {
    return await _database.filterTask(isDone);
  }

  @override
  Future<bool> updateTask(int taskId, Map<String, Object?> task) async {
    return await _database.updateTask(taskId, task);
  }
}
