import 'package:to_do_app/data/repositories/task_repository.dart';
import 'package:to_do_app/domain/models/task.dart';

class TaskUsecase {
  final TaskRepositoryImpl _taskRepositoryImpl;

  TaskUsecase(this._taskRepositoryImpl);

  Future<List<Map<String, Object?>>> getAllTask() async {
    return await _taskRepositoryImpl.getAllTasks();
  }

  Future<Map<String, Object?>> getTaskById(int taskId) async {
    return await _taskRepositoryImpl.getTaskById(taskId);
  }

  Future<bool> addTask(Task task) async {
    return await _taskRepositoryImpl.addTask(task);
  }

  Future<List<Map<String, Object?>>> filterTaskByDoneStatus(bool isDone) async {
    return await _taskRepositoryImpl.filterTask(isDone);
  }

  Future<bool> updateTaskById(int taskId, Map<String, Object?> task) async {
    return await _taskRepositoryImpl.updateTask(taskId, task);
  }

  Future<bool> deleteTaskById(int taskId) async {
    return await _taskRepositoryImpl.deleteTaskById(taskId);
  }
}
