import 'package:sqflite/sqflite.dart';
import 'package:to_do_app/data/network/database_service.dart';

class TodoDatabase {
  final taskTableName = 'tasks';
  final taskId = 'id';
  final taskName = 'name';
  final taskDescription = 'description';
  final taskCreateAt = 'create_at';
  final taskDeadline = 'deadline';
  final taskPriority = 'priority';
  final taskDone = 'is_done';

  Future<void> createTaskTable(Database database) async {
    await database.execute("""CREATE TABLE IF NOT EXISTS $taskTableName (
    $taskId INTEGER PRIMARY KEY AUTOINCREMENT,
    $taskName TEXT NOT NULL,
    $taskDescription TEXT,
    $taskCreateAt TEXT NOT NULL,
    $taskDeadline TEXT NOT NULL,
    $taskPriority INTEGER NOT NULL DEFAULT 10,
    $taskDone INTEGER NOT NULL DEFAULT 0
    );""");
  }

  Future<List<Map<String, Object?>>> getAllTasks() async {
    final database = await DatabaseService().database;
    final tasks = await database
        .rawQuery('''SELECT * FROM $taskTableName ORDER BY $taskCreateAt''');
    return tasks;
  }

  Future<Map<String, Object?>> getTaskById(int taskId) async {
    final database = await DatabaseService().database;
    final task = await database
        .rawQuery('''SELECT * FROM $taskTableName WHERE $taskId = $taskId''');
    return task.first;
  }

  Future<bool> deleteTaskById(int taskId) async {
    try {
      final database = await DatabaseService().database;
      final result = await database
          .delete(taskTableName, where: '$taskId = ?', whereArgs: [taskId]);
      return result > 0;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, Object?>>> filterTask(bool isDone) async {
    try {
      final isDoneToInt = isDone ? 1 : 0;
      final database = await DatabaseService().database;
      final tasks = await database.rawQuery(
          '''SELECT * FROM $taskTableName WHERE $taskDone = $isDoneToInt''');
      return tasks;
    } catch (e) {
      e.toString();
      return [];
    }
  }

  Future<bool> updateTask(int taskId, Map<String, Object?> task) async {
    try {
      final database = await DatabaseService().database;
      final result = await database.update(taskTableName, task,
          where: '$taskId = ?', whereArgs: [taskId]);
      return result > 0;
    } catch (e) {
      e.toString();
      return false;
    }
  }
}
