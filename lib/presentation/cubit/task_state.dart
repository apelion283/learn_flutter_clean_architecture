import 'package:equatable/equatable.dart';

class TaskState extends Equatable {
  final List<Map<String, Object?>> listTask;
  final int filterValue;

  TaskState copyWith(List<Map<String, Object?>>? data, int? filterValue) {
    return TaskState(data ?? listTask,
        filterValue: filterValue ?? this.filterValue);
  }

  const TaskState(this.listTask, {this.filterValue = 0});

  @override
  List<Object?> get props => [listTask, filterValue];
}
