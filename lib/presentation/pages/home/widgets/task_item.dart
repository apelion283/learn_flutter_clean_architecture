import 'package:flutter/material.dart';
import 'package:to_do_app/app/resources/color_manager.dart';
import 'package:to_do_app/domain/models/task.dart';

class TaskItem extends StatefulWidget {
  final Task task;
  final ValueChanged<bool> onMarkAsComplete;
  final VoidCallback onEditTask;
  final VoidCallback onDeleteTask;

  const TaskItem(
      {super.key,
      required this.task,
      required this.onMarkAsComplete,
      required this.onEditTask,
      required this.onDeleteTask});

  @override
  State<TaskItem> createState() => _TaskItemState();
}

class _TaskItemState extends State<TaskItem> {
  @override
  Widget build(BuildContext context) {
    bool isChecked = widget.task.isDone == 1;
    return GestureDetector(
        onLongPress: () {
          widget.onDeleteTask();
        },
        onTap: () {
          widget.onEditTask();
        },
        child: Container(
          decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                  topRight: Radius.circular(8)),
              border: Border(
                  left: BorderSide(color: AppColor.buttonColor, width: 2)),
              color: AppColor.taskItemColor),
          child: ListTile(
            leading: Checkbox(
              side: const BorderSide(color: AppColor.buttonColor, width: 2),
              value: isChecked,
              onChanged: (bool? newValue) {
                setState(() {
                  isChecked = newValue!;
                  widget.task.isDone = isChecked ? 1 : 0;
                  widget.onMarkAsComplete(isChecked);
                });
              },
              activeColor: AppColor.buttonColor,
            ),
            title: Row(
              children: [
                Flexible(
                  child: Text(widget.task.name,
                      style: TextStyle(
                        color: AppColor.textColor,
                        decoration: widget.task.isDone == 1
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis),
                )
              ],
            ),
            subtitle: Text(
              getDisplayTime(DateTime.parse(widget.task.deadline)),
              style: TextStyle(
                  color: AppColor.hintColor,
                  decoration: widget.task.isDone == 1
                      ? TextDecoration.lineThrough
                      : TextDecoration.none),
            ),
            trailing: Card(
              color: AppColor.taskItemColor,
              shape: RoundedRectangleBorder(
                  side: const BorderSide(color: AppColor.buttonColor, width: 1),
                  borderRadius: BorderRadius.circular(4)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.flag_outlined,
                      color: AppColor.buttonColor,
                      size: 16,
                    ),
                    const SizedBox(
                      width: 4,
                    ),
                    Text(widget.task.priority.toString(),
                        style: const TextStyle(
                          color: AppColor.textColor,
                        ))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

String getDisplayTime(DateTime dateTime) {
  final today = DateTime.now();
  final yesterday = today.subtract(const Duration(days: 1));
  final tomorrow = today.add(const Duration(days: 1));
  final hour = dateTime.hour.toString().padLeft(2, '0');
  final minute = dateTime.minute.toString().padLeft(2, '0');

  if (dateTime.year == today.year &&
      dateTime.month == today.month &&
      dateTime.day == today.day) {
    return "Today At $hour:$minute";
  } else if (dateTime.year == tomorrow.year &&
      dateTime.month == tomorrow.month &&
      dateTime.day == tomorrow.day) {
    return "Tomorrow At $hour:$minute";
  } else if (dateTime.year == yesterday.year &&
      dateTime.month == yesterday.month &&
      dateTime.day == yesterday.day) {
    return "Yesterday At $hour:$minute";
  } else {
    return "${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} At $hour:$minute";
  }
}
