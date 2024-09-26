import 'package:bloc/bloc.dart';
import 'package:to_do_app/data/data_source/todo_database.dart';
import 'package:to_do_app/data/repositories/task_repository.dart';
import 'package:to_do_app/domain/usecases/delete_task_by_id.dart';
import 'package:to_do_app/domain/usecases/filter_task.dart';
import 'package:to_do_app/domain/usecases/get_all_tasks.dart';
import 'package:to_do_app/domain/usecases/get_task_by_id.dart';
import 'package:to_do_app/domain/usecases/update_task.dart';
import 'package:to_do_app/presentation/cubit/task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(TaskState([]));

  final GetAllTaskUsecase getAllTaskUsecase =
      GetAllTaskUsecase(TaskRepositoryImpl(TodoDatabase()));

  final GetTaskByIdUsecase getTaskByIdUsecase =
      GetTaskByIdUsecase(TaskRepositoryImpl(TodoDatabase()));

  final UpdateTaskUseCase updateTaskUseCase =
      UpdateTaskUseCase(TaskRepositoryImpl(TodoDatabase()));

  final FilterTaskUsecase filterTaskUsecase =
      FilterTaskUsecase(TaskRepositoryImpl(TodoDatabase()));

  final DeleteTaskByIdUseCase deleteTaskByIdUseCase =
      DeleteTaskByIdUseCase(TaskRepositoryImpl(TodoDatabase()));

  void getAllTasks() async {
    try {
      final tasks = await getAllTaskUsecase.execute();
      emit(state.copyWith(tasks));
    } catch (e) {
      //error state
    }
  }

  void getTaskById(int taskId) async {
    try {
      final task = await getTaskByIdUsecase.excute(taskId);
      List<Map<String, Object?>> newList = [];
      newList.add(task);
      emit(state.copyWith(newList));
    } catch (e) {
      //error state
    }
  }

  void filterTask(bool isDone) async {
    try {
      final tasks = await filterTaskUsecase.excute(isDone);
      emit(state.copyWith(tasks));
    } catch (e) {
      //error state
    }
  }

  void deleteTaskById(int taskId) async {
    try {
      final isSuccess = await deleteTaskByIdUseCase.excute(taskId);
      if (isSuccess) {
        final tasks = await getAllTaskUsecase.execute();
        emit(state.copyWith(tasks));
      } else {
        //error state
      }
    } catch (e) {
      //error state
    }
  }

  void updateTask(int taskId, Map<String, Object?> task) async {
    try {
      final isSuccess = await updateTaskUseCase.excute(taskId, task);
      if (isSuccess) {
        final tasks = await getAllTaskUsecase.execute();
        emit(state.copyWith(tasks));
      } else {
        //error State
      }
    } catch (e) {
      // error state
    }
  }
}
