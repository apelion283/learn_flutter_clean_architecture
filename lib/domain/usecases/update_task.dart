import 'package:to_do_app/data/repositories/task_repository.dart';

class UpdateTaskUseCase {
  TaskRepositoryImpl taskRepositoryImpl;
  UpdateTaskUseCase(this.taskRepositoryImpl);

  Future<bool> excute(int taskId, Map<String, Object?> task) {
    return taskRepositoryImpl.updateTask(taskId, task);
  }
}
