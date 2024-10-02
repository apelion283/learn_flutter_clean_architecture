import 'package:bloc/bloc.dart';
import 'package:to_do_app/data/data_source/todo_database.dart';
import 'package:to_do_app/data/repositories/task_repository.dart';
import 'package:to_do_app/domain/models/task.dart';
import 'package:to_do_app/domain/usecases/task_usecase.dart';
import 'package:to_do_app/presentation/cubit/task_state.dart';

class TaskCubit extends Cubit<TaskState> {
  TaskCubit() : super(const TaskState([]));

  final TaskUsecase _taskUsecase =
      TaskUsecase(TaskRepositoryImpl(TodoDatabase()));

  void getAllTasks() async {
    try {
      final tasks = await _taskUsecase.getAllTask();
      //print("$tasks");
      emit(state.copyWith(tasks, 0));
    } catch (e) {
      //error state
    }
  }

  void getTaskById(int taskId) async {
    try {
      final task = await _taskUsecase.getTaskById(taskId);
      List<Map<String, Object?>> newList = [];
      newList.add(task);
      updateFilterValue(state.filterValue);
    } catch (e) {
      //error state
    }
  }

  void filterTask(bool isDone) async {
    try {
      final tasks = await _taskUsecase.filterTaskByDoneStatus(isDone);
      emit(state.copyWith(tasks, isDone ? 2 : 1));
    } catch (e) {
      //error state
    }
  }

  void updateFilterValue(int value) {
    if (value == 0) {
      getAllTasks();
    } else if (value == 1) {
      filterTask(false);
    } else {
      filterTask(true);
    }
  }

  void addTask(Task task) async {
    try {
      bool isSuccess = await _taskUsecase.addTask(task);
      if (isSuccess) {
        getAllTasks();
      }
    } catch (e) {
      //error state
    }
  }

  void deleteTaskById(int taskId) async {
    try {
      final isSuccess = await _taskUsecase.deleteTaskById(taskId);
      if (isSuccess) {
        getAllTasks();
      } else {
        //error state
      }
    } catch (e) {
      //error state
    }
  }

  void updateTask(
      int taskId, Map<String, Object?> task, int filterValue) async {
    try {
      final isSuccess = await _taskUsecase.updateTaskById(taskId, task);
      if (isSuccess) {
        updateFilterValue(state.filterValue);
      } else {
        //error State
      }
    } catch (e) {
      // error state
    }
  }
}
