import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:to_do_app/app/resources/color_manager.dart';
import 'package:to_do_app/domain/models/task.dart';
import 'package:to_do_app/presentation/cubit/task_cubit.dart';
import 'package:to_do_app/presentation/cubit/task_state.dart';
import 'package:to_do_app/presentation/pages/home/widgets/edit_task_dialog.dart';
import 'package:to_do_app/presentation/pages/home/widgets/task_item.dart';

class TabScreen extends StatelessWidget {
  final TaskCubit taskCubit;
  final int filterValue;
  final TaskState state;

  const TabScreen(
      {super.key,
      required this.taskCubit,
      required this.filterValue,
      required this.state});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: state.listTask.isEmpty
            ? const Center(
                child: Text(
                  "There is no task to do, let's add one!",
                  style: TextStyle(color: AppColor.textColor),
                  textAlign: TextAlign.center,
                ),
              )
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
                                          'description': taskObject.description,
                                          'create_at': taskObject.createDate,
                                          'deadline': taskObject.deadline,
                                          'priority': taskObject.priority,
                                          'is_done': taskObject.isDone,
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
                                    backgroundColor: AppColor.taskItemColor,
                                    title: const Text(
                                      "Delete Task?",
                                      style:
                                          TextStyle(color: AppColor.textColor),
                                    ),
                                    content: const Text(
                                      "Are you sure to delete this task?",
                                      style:
                                          TextStyle(color: AppColor.hintColor),
                                    ),
                                    actions: [
                                      CupertinoDialogAction(
                                        textStyle: const TextStyle(
                                            color: AppColor.buttonColor),
                                        onPressed: () {
                                          taskCubit
                                              .deleteTaskById(taskObject.id);
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text("OK"),
                                      ),
                                      CupertinoDialogAction(
                                        textStyle: const TextStyle(
                                            color: AppColor.buttonColor),
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
    ]);
  }
}
