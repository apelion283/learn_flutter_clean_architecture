import 'package:to_do_app/data/repositories/task_repository.dart';

class FilterTaskUsecase {
  TaskRepositoryImpl taskRepositoryImpl;
  FilterTaskUsecase(this.taskRepositoryImpl);

  Future<List<Map<String, Object?>>> excute(bool isDone) {
    return taskRepositoryImpl.filterTask(isDone);
  }
}
