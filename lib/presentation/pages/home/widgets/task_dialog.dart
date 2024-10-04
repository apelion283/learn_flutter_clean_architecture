import 'package:flutter/material.dart';
import 'package:to_do_app/app/resources/color_manager.dart';
import 'package:to_do_app/presentation/pages/home/widgets/app_text_field.dart';

class TaskDialog extends StatelessWidget {
  final Function onConfirm;
  final Function onDismiss;

  const TaskDialog(
      {super.key, required this.onConfirm, required this.onDismiss});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

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
                  "Add new task",
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
              AppTextField(
                controller: descriptionController,
                hint: "Description",
              ),
              Row(
                children: [
                  Expanded(
                      child: TextButton(
                    onPressed: () {
                      onDismiss();
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
                      onConfirm(
                          nameController.text, descriptionController.text);
                    },
                    style: TextButton.styleFrom(
                        backgroundColor: AppColor.buttonColor,
                        padding: const EdgeInsets.all(8),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32))),
                    child: const Text(
                      "Dealine",
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
