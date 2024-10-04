import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_app/app/resources/color_manager.dart';
import 'package:to_do_app/domain/models/task.dart';
import 'package:to_do_app/presentation/cubit/task_cubit.dart';
import 'package:to_do_app/presentation/cubit/task_state.dart';
import 'package:to_do_app/presentation/pages/home/widgets/tab_screen.dart';
import 'package:to_do_app/presentation/pages/home/widgets/task_dialog.dart';

class HomePageScreen extends StatefulWidget {
  const HomePageScreen(
      {super.key, required this.title, required this.taskCubit});

  final String title;
  final TaskCubit taskCubit;

  @override
  State<HomePageScreen> createState() => _HomePageScreenState();
}

class _HomePageScreenState extends State<HomePageScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        setState(() {});
        if (_tabController.index == 0) {
          widget.taskCubit.getAllTasks();
        } else if (_tabController.index == 1) {
          widget.taskCubit.filterTask(false);
        } else if (_tabController.index == 2) {
          widget.taskCubit.filterTask(true);
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(Object context) {
    String taskName = "", taskDescription = "";
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    return Scaffold(
      backgroundColor: AppColor.primaryBackgroundColor,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(color: AppColor.textColor),
          textAlign: TextAlign.center,
        ),
        backgroundColor: AppColor.primaryBackgroundColor,
        bottom: TabBar(
          padding: const EdgeInsets.all(16),
          labelPadding: EdgeInsets.zero,
          controller: _tabController,
          isScrollable: false,
          indicatorColor: Colors.transparent,
          dividerColor: Colors.transparent,
          labelColor: AppColor.primaryBackgroundColor,
          unselectedLabelColor: AppColor.tabUnfocusedTextColor,
          tabs: [
            Tab(
              iconMargin: const EdgeInsets.all(0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _tabController.index == 0
                      ? AppColor.buttonColor
                      : AppColor.tabUnfocusedBackgroundColor,
                ),
                child: const Center(child: Text("All")),
              ),
            ),
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _tabController.index == 1
                      ? AppColor.buttonColor
                      : AppColor.tabUnfocusedBackgroundColor,
                ),
                child: const Center(
                    child: Text(
                  "In Progress",
                  maxLines: 1,
                )),
              ),
            ),
            Tab(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: _tabController.index == 2
                      ? AppColor.buttonColor
                      : AppColor.tabUnfocusedBackgroundColor,
                ),
                child: const Center(child: Text("Done", maxLines: 1)),
              ),
            )
          ],
        ),
      ),
      body: DefaultTabController(
          length: 3,
          child: BlocProvider(
            create: (context) => widget.taskCubit..getAllTasks(),
            child: BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
              return TabBarView(controller: _tabController, children: [
                TabScreen(
                    taskCubit: widget.taskCubit, filterValue: 0, state: state),
                TabScreen(
                    taskCubit: widget.taskCubit, filterValue: 1, state: state),
                TabScreen(
                    taskCubit: widget.taskCubit, filterValue: 2, state: state)
              ]);
            }),
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await showDialog(
              context: this.context,
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
              builder: (context, child) {
                return Theme(
                    data: Theme.of(context).copyWith(
                        colorScheme: const ColorScheme.light(
                            primary: AppColor.buttonColor,
                            onPrimary: AppColor.primaryBackgroundColor,
                            onSurface: AppColor.buttonColor),
                        textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                                foregroundColor: AppColor.buttonColor))),
                    child: child!);
              },
              // ignore: use_build_context_synchronously
              context: this.context,
              firstDate: DateTime(1900),
              lastDate: DateTime(3000),
              initialDate: DateTime.now(),
              initialEntryMode: DatePickerEntryMode.input,
              confirmText: "Choose Date",
            );

            if (selectedDate != null) {
              selectedTime = await showTimePicker(
                  builder: (context, child) {
                    return Theme(
                        data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                                primary: AppColor.buttonColor,
                                onPrimary: AppColor.primaryBackgroundColor,
                                onSurface: AppColor.buttonColor),
                            textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                    foregroundColor: AppColor.buttonColor))),
                        child: child!);
                  },
                  // ignore: use_build_context_synchronously
                  context: this.context,
                  initialTime: TimeOfDay.now());
            }

            if (selectedTime != null) {
              final time = DateTime(selectedDate!.year, selectedDate!.month,
                  selectedDate!.day, selectedTime!.hour, selectedTime!.minute);

              widget.taskCubit.addTask(Task(
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
          color: AppColor.primaryBackgroundColor,
        ),
      ),
    );
  }
}
