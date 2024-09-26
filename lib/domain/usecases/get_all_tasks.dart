import 'package:to_do_app/data/repositories/task_repository.dart';

class GetAllTaskUsecase {
  TaskRepositoryImpl taskRepositoryImpl;
  GetAllTaskUsecase(this.taskRepositoryImpl);

  Future<List<Map<String, Object?>>> execute() {
    return taskRepositoryImpl.getAllTasks();
  }
}
