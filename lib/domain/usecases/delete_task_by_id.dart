import 'package:to_do_app/data/repositories/task_repository.dart';

class DeleteTaskByIdUseCase {
  TaskRepositoryImpl taskRepositoryImpl;
  DeleteTaskByIdUseCase(this.taskRepositoryImpl);

  Future<bool> excute(int taskId) {
    return taskRepositoryImpl.deleteTaskById(taskId);
  }
}
