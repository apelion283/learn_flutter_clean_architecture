import 'package:flutter/material.dart';
import 'package:to_do_app/app/resources/color_manager.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/presentation/cubit/task_cubit.dart';
import 'package:to_do_app/presentation/cubit/task_state.dart';

class HomePageScreen extends StatelessWidget {
  const HomePageScreen({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primaryBackgroundColor,
      appBar: AppBar(
        title: Text(
          title,
          style: const TextStyle(color: AppColor.primaryTextColor),
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColor.primaryBackgroundColor,
      ),
      body: BlocProvider(
        create: (context) => TaskCubit()..getAllTasks(),
        child: BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
          if (state.listTask.isEmpty) {
            // Nếu danh sách rỗng, hiển thị "Hello World"
            return const Center(
                child: Text(
              "There is no task to do, let's add one!",
              style: TextStyle(color: AppColor.secondaryTextColor),
            ));
          }
          return ListView.builder(
            itemCount: state.listTask.length,
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final item = state.listTask[index];
              return ListTile(
                title: Text(item['name'] as String),
                subtitle: Text(item['description'] as String),
                leading: Icon(
                  (item['isDone'] as bool)
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                ),
              );
            },
          );
        }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        backgroundColor: AppColor.buttonColor,
        child: const Icon(
          Icons.add,
          color: AppColor.primaryTextColor,
        ),
      ),
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "Add Task",
            style: TextStyle(color: AppColor.primaryTextColor),
          ),
          backgroundColor: AppColor.secondaryBackgroundColor,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                    hintText: "Task Name",
                    hintStyle: TextStyle(color: AppColor.secondaryTextColor),
                    contentPadding: EdgeInsets.all(6),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: AppColor.primaryBackgroundColor,
                          width: 2.0,
                        ))),
                style: const TextStyle(color: AppColor.secondaryTextColor),
              ),
              const SizedBox(
                height: 16,
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                    contentPadding: EdgeInsets.all(6),
                    hintText: "Description",
                    hintStyle: TextStyle(color: AppColor.secondaryTextColor),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        borderSide: BorderSide(
                          color: AppColor.primaryBackgroundColor,
                          width: 2.0,
                        ))),
                style: const TextStyle(color: AppColor.secondaryTextColor),
              ),
            ],
          ),
          actions: [
            TextButton(
              style: ButtonStyle(
                  backgroundColor:
                      WidgetStateProperty.all(AppColor.buttonColor),
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)))),
              child: const Text(
                "Add Task",
                style: TextStyle(color: AppColor.primaryTextColor),
              ),
              onPressed: () {
                // Thêm logic để thêm task vào database/repository
                final name = nameController.text;
                final description = descriptionController.text;

                if (name.isNotEmpty && description.isNotEmpty) {
                  // Gọi phương thức để thêm task mới
                  // Ví dụ: context.read<TaskCubit>().addTask(name, description);
                }

                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
            TextButton(
              style: ButtonStyle(
                  shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)))),
              child: const Text(
                "Cancel",
                style: TextStyle(color: AppColor.buttonColor),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Đóng dialog
              },
            ),
          ],
        );
      },
    );
  }
}
