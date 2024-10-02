import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/app/resources/color_manager.dart';
import 'package:to_do_app/domain/models/task.dart';
import 'package:to_do_app/presentation/cubit/task_cubit.dart';
import 'package:to_do_app/presentation/cubit/task_state.dart';
import 'package:to_do_app/presentation/pages/home/widgets/edit_task_dialog.dart';
import 'package:to_do_app/presentation/pages/home/widgets/filter_dropdown.dart';
import 'package:to_do_app/presentation/pages/home/widgets/task_dialog.dart';
import 'package:to_do_app/presentation/pages/home/widgets/task_item.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen(
      {super.key, required this.title, required this.taskCubit});

  final String title;
  final TaskCubit taskCubit;

  @override
  Widget build(BuildContext context) {
    String taskName = "", taskDescription = "";
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    int filterValue = 0;

    return Scaffold(
      backgroundColor: AppColor.primaryBackgroundColor,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: AppColor.textColor),
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColor.primaryBackgroundColor,
      ),
      body: BlocProvider(
          create: (context) => taskCubit..getAllTasks(),
          child: BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: FilterDropdown(
                    onItemSelectedChange: (value) =>
                        {taskCubit.updateFilterValue(value)},
                    selectedIndex: state.filterValue,
                  ),
                ),
                Expanded(
                  child: state.listTask.isEmpty
                      ? const Padding(
                          padding: EdgeInsets.all(16),
                          child: Expanded(
                              child: Center(
                            child: Text(
                              "There is no task to do, let's add one!",
                              style: TextStyle(color: AppColor.textColor),
                              textAlign: TextAlign.center,
                            ),
                          )))
                      : ListView.builder(
                          itemCount: state.listTask.length,
                          padding: const EdgeInsets.all(16),
                          itemBuilder: (context, index) {
                            final item = state.listTask[index];
                            Task taskObject = Task.fromMap(item);
                            return Column(
                              children: [
                                TaskItem(
                                  task: taskObject,
                                  onMarkAsComplete: (value) {
                                    taskCubit.updateTask(
                                        taskObject.id,
                                        {
                                          'id': taskObject.id,
                                          'name': taskObject.name,
                                          'description': taskObject.description,
                                          'create_at': taskObject.createDate,
                                          'deadline': taskObject.deadline,
                                          'priority': taskObject.priority,
                                          'is_done': value ? 1 : 0,
                                        },
                                        filterValue);
                                  },
                                  onEditTask: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) => EditTaskDialog(
                                            task: taskObject,
                                            onConfirm: (updateTask) {
                                              taskCubit.updateTask(
                                                  taskObject.id,
                                                  {
                                                    'id': taskObject.id,
                                                    'name': taskObject.name,
                                                    'description':
                                                        taskObject.description,
                                                    'create_at':
                                                        taskObject.createDate,
                                                    'deadline':
                                                        taskObject.deadline,
                                                    'priority':
                                                        taskObject.priority,
                                                    'is_done':
                                                        taskObject.isDone,
                                                  },
                                                  filterValue);
                                            },
                                            onDismiss: () {
                                              Navigator.of(context).pop();
                                            }));
                                  },
                                  onDeleteTask: () {
                                    showDialog(
                                        context: context,
                                        barrierDismissible: true,
                                        builder: (context) => AlertDialog(
                                              backgroundColor:
                                                  AppColor.taskItemColor,
                                              title: const Text(
                                                "Delete Task?",
                                                style: TextStyle(
                                                    color: AppColor.textColor),
                                              ),
                                              content: const Text(
                                                "Are you sure to delete this task?",
                                                style: TextStyle(
                                                    color: AppColor.hintColor),
                                              ),
                                              actions: [
                                                CupertinoDialogAction(
                                                  textStyle: const TextStyle(
                                                      color:
                                                          AppColor.buttonColor),
                                                  onPressed: () {
                                                    taskCubit.deleteTaskById(
                                                        taskObject.id);
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("OK"),
                                                ),
                                                CupertinoDialogAction(
                                                  textStyle: const TextStyle(
                                                      color:
                                                          AppColor.buttonColor),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: const Text("No"),
                                                )
                                              ],
                                            ));
                                  },
                                ),
                                const SizedBox(
                                  height: 8,
                                )
                              ],
                            );
                          }),
                )
              ],
            );
          })),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
              context: context,
              builder: (context) => TaskDialog(
                    onConfirm: (name, description) {
                      if (name.toString().isNotEmpty) {
                        taskName = name;
                        taskDescription = description;
                        Navigator.of(context).pop([name, description]);
                      }
                    },
                    onDismiss: () {
                      taskName = "";
                      taskDescription = "";
                      Navigator.of(context).pop();
                    },
                  ));
          if (result != null) {
            selectedDate = await showDatePicker(
              // ignore: use_build_context_synchronously
              context: context,
              firstDate: DateTime(1900),
              lastDate: DateTime(3000),
              initialDate: DateTime.now(),
              initialEntryMode: DatePickerEntryMode.input,
              confirmText: "Choose Date",
            );

            if (selectedDate != null) {
              selectedTime = await showTimePicker(
                  // ignore: use_build_context_synchronously
                  context: context,
                  initialTime: TimeOfDay.now());
            }

            if (selectedTime != null) {
              final time = DateTime(selectedDate!.year, selectedDate!.month,
                  selectedDate!.day, selectedTime!.hour, selectedTime!.minute);

              taskCubit.addTask(Task(
                  id: 0,
                  name: taskName,
                  description: taskDescription,
                  createDate: DateTime.now().toIso8601String(),
                  deadline: time.toIso8601String(),
                  priority: 1,
                  isDone: 0));
            }
          } else {
            taskName = "";
            taskDescription = "";
          }
        },
        backgroundColor: AppColor.buttonColor,
        child: const Icon(
          Icons.add,
          color: AppColor.textColor,
        ),
      ),
    );
  }
}
