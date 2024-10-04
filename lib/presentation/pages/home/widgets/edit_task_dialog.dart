import 'package:flutter/material.dart';
import 'package:to_do_app/app/resources/color_manager.dart';
import 'package:to_do_app/domain/models/task.dart';
import 'package:to_do_app/presentation/pages/home/widgets/app_text_field.dart';

class EditTaskDialog extends StatefulWidget {
  final Task task;
  final Function(Task) onConfirm;
  final Function onDismiss;

  const EditTaskDialog(
      {super.key,
      required this.task,
      required this.onConfirm,
      required this.onDismiss});

  @override
  State<EditTaskDialog> createState() => _EditTaskDialogState();
}

class _EditTaskDialogState extends State<EditTaskDialog> {
  late TextEditingController nameController;
  late TextEditingController descriptionController;
  late DateTime taskDeadline;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    descriptionController = TextEditingController();
    nameController.text = widget.task.name;
    descriptionController.text = widget.task.description;
    taskDeadline = DateTime.parse(widget.task.deadline);
  }

  @override
  void dispose() {
    nameController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  void setPriority(int priority) {
    setState(() {
      widget.task.priority = priority;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime taskDeadline = DateTime.parse(widget.task.deadline);
    return Dialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        backgroundColor: AppColor.taskItemColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Edit task",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: AppColor.textColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              AppTextField(
                controller: nameController,
                hint: "Task Name",
                isAutoFocus: true,
              ),
              const SizedBox(
                height: 8,
              ),
              AppTextField(
                controller: descriptionController,
                hint: "Description",
              ),
              const SizedBox(
                height: 8,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () async {
                        DateTime? selectedDate = await showDatePicker(
                          builder: (context, child) {
                            return Theme(
                                data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                        primary: AppColor.buttonColor,
                                        onPrimary:
                                            AppColor.primaryBackgroundColor,
                                        onSurface: AppColor.buttonColor),
                                    textButtonTheme: TextButtonThemeData(
                                        style: TextButton.styleFrom(
                                            foregroundColor:
                                                AppColor.buttonColor))),
                                child: child!);
                          },
                          context: context,
                          firstDate: DateTime(1900),
                          lastDate: DateTime(3000),
                          initialDate: DateTime(taskDeadline.year,
                              taskDeadline.month, taskDeadline.day),
                          initialEntryMode: DatePickerEntryMode.input,
                          confirmText: "Choose Date",
                        );

                        if (selectedDate != null) {
                          TimeOfDay? selectedTime = await showTimePicker(
                              builder: (context, child) {
                                return Theme(
                                    data: Theme.of(context).copyWith(
                                        colorScheme: const ColorScheme.light(
                                            primary: AppColor.buttonColor,
                                            onPrimary:
                                                AppColor.primaryBackgroundColor,
                                            onSurface: AppColor.buttonColor),
                                        textButtonTheme: TextButtonThemeData(
                                            style: TextButton.styleFrom(
                                                foregroundColor:
                                                    AppColor.buttonColor))),
                                    child: child!);
                              },
                              // ignore: use_build_context_synchronously
                              context: context,
                              initialTime: TimeOfDay(
                                  hour: taskDeadline.hour,
                                  minute: taskDeadline.minute));
                          if (selectedTime != null) {
                            DateTime updateTime = DateTime(
                                selectedDate.year,
                                selectedDate.month,
                                selectedDate.day,
                                selectedTime.hour,
                                selectedTime.minute);
                            setState(() {
                              taskDeadline = updateTime;
                              widget.task.deadline =
                                  updateTime.toIso8601String();
                            });
                          }
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                            color: AppColor.primaryBackgroundColor,
                            borderRadius: BorderRadius.circular(8)),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.timer_outlined,
                              color: AppColor.hintColor,
                            ),
                            const SizedBox(
                              width: 4,
                            ),
                            Text(
                              "${taskDeadline.day.toString().padLeft(2, '0')}/${taskDeadline.month.toString().padLeft(2, '0')} At ${taskDeadline.hour.toString().padLeft(2, '0')}:${taskDeadline.minute.toString().padLeft(2, '0')}",
                              style: const TextStyle(color: AppColor.hintColor),
                            )
                          ],
                        ),
                      )),
                  GestureDetector(
                    onTap: () {
                      int selectedIndex = widget.task.priority - 1;
                      showDialog<int>(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.zero),
                              backgroundColor: AppColor.taskItemColor,
                              content:
                                  StatefulBuilder(builder: (context, setState) {
                                return Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      "Task Priority",
                                      style:
                                          TextStyle(color: AppColor.textColor),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 0),
                                    ),
                                    const Divider(
                                      height: 1,
                                      color: AppColor
                                          .focusedOutlineTextFieldBorderColor,
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 0),
                                    ),
                                    SizedBox(
                                      height: 200,
                                      child: GridView.builder(
                                          gridDelegate:
                                              const SliverGridDelegateWithFixedCrossAxisCount(
                                                  crossAxisCount: 4),
                                          itemCount: 10,
                                          itemBuilder: (context, index) {
                                            return GestureDetector(
                                                onTap: () {
                                                  setState(() {
                                                    selectedIndex = index;
                                                  });
                                                },
                                                child: Card(
                                                  color: index == selectedIndex
                                                      ? AppColor.buttonColor
                                                      : AppColor
                                                          .primaryButtonColor,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            4),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      children: [
                                                        Icon(
                                                            Icons.flag_outlined,
                                                            size: 16,
                                                            color: index ==
                                                                    selectedIndex
                                                                ? AppColor
                                                                    .primaryBackgroundColor
                                                                : AppColor
                                                                    .buttonColor),
                                                        const SizedBox(
                                                          width: 4,
                                                        ),
                                                        Text(
                                                            (index + 1)
                                                                .toString(),
                                                            style: TextStyle(
                                                                color: index ==
                                                                        selectedIndex
                                                                    ? AppColor
                                                                        .primaryBackgroundColor
                                                                    : AppColor
                                                                        .buttonColor,
                                                                fontSize: 12))
                                                      ],
                                                    ),
                                                  ),
                                                ));
                                          }),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                            child: TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          style: TextButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(4)),
                                              backgroundColor:
                                                  AppColor.primaryButtonColor,
                                              padding: const EdgeInsets.all(8)),
                                          child: const Text(
                                            "Cancel",
                                            style: TextStyle(
                                              color: AppColor.buttonColor,
                                            ),
                                          ),
                                        )),
                                        const SizedBox(
                                          width: 16,
                                        ),
                                        Expanded(
                                            child: TextButton(
                                          onPressed: () {
                                            setPriority(selectedIndex + 1);
                                            Navigator.of(context).pop();
                                          },
                                          style: TextButton.styleFrom(
                                              backgroundColor:
                                                  AppColor.buttonColor,
                                              padding: const EdgeInsets.all(8),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4))),
                                          child: const Text(
                                            "Save",
                                            style: TextStyle(
                                              color: AppColor
                                                  .primaryBackgroundColor,
                                            ),
                                          ),
                                        ))
                                      ],
                                    )
                                  ],
                                );
                              }));
                        },
                      );
                    },
                    child: Card(
                      color: AppColor.taskItemColor,
                      shape: RoundedRectangleBorder(
                          side: const BorderSide(
                              color: AppColor.buttonColor, width: 1),
                          borderRadius: BorderRadius.circular(4)),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
                  )
                ],
              ),
              const SizedBox(
                height: 4,
              ),
              Row(
                children: [
                  Expanded(
                      child: TextButton(
                    onPressed: () {
                      widget.onDismiss();
                    },
                    style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32)),
                        backgroundColor: AppColor.primaryButtonColor,
                        padding: const EdgeInsets.all(8)),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        color: AppColor.buttonColor,
                      ),
                    ),
                  )),
                  const SizedBox(
                    width: 16,
                  ),
                  Expanded(
                      child: TextButton(
                    onPressed: () {
                      if (nameController.text.isNotEmpty) {
                        widget.task.name = nameController.text;
                        widget.task.description = descriptionController.text;
                        widget.onConfirm(widget.task);
                        Navigator.of(context).pop();
                      } else {}
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: AppColor.buttonColor,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32))),
                    child: const Text(
                      "Confirm",
                      style: TextStyle(
                        color: AppColor.primaryBackgroundColor,
                      ),
                    ),
                  ))
                ],
              )
            ],
          ),
        ));
  }
}
