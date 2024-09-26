import 'package:to_do_app/data/repositories/task_repository.dart';

class GetTaskByIdUsecase {
  TaskRepositoryImpl taskRepositoryImpl;
  GetTaskByIdUsecase(this.taskRepositoryImpl);

  Future<Map<String, Object?>> excute(int taskId) {
    return taskRepositoryImpl.getTaskById(taskId);
  }
}
