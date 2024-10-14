import 'package:dynamic_icon_flutter/dynamic_icon_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
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
  int index = 0;
  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      setState(() {
        _tabController.index;
      });
      if (_tabController.index == 0) {
        widget.taskCubit.getAllTasks();
      } else if (_tabController.index == 1) {
        widget.taskCubit.filterTask(false);
      } else if (_tabController.index == 2) {
        widget.taskCubit.filterTask(true);
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
  Widget build(BuildContext context) {
    String taskName = "", taskDescription = "";
    DateTime? selectedDate;
    TimeOfDay? selectedTime;
    const List<String> list = ["icon_1", "icon_2", "icon_3", "MainActivity"];

    return Scaffold(
      backgroundColor: AppColor.primaryBackgroundColor,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(top: 16),
          child: Text(
            widget.title,
            style: const TextStyle(color: AppColor.textColor),
            textAlign: TextAlign.center,
          ),
        ),
        backgroundColor: AppColor.primaryBackgroundColor,
      ),
      body: Column(
        children: [
          TabBar(
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
          Expanded(
            child: BlocProvider(
              create: (context) => widget.taskCubit..getAllTasks(),
              child:
                  BlocBuilder<TaskCubit, TaskState>(builder: (context, state) {
                return TabBarView(controller: _tabController, children: [
                  TabScreen(
                      taskCubit: widget.taskCubit,
                      filterValue: 0,
                      state: state),
                  TabScreen(
                      taskCubit: widget.taskCubit,
                      filterValue: 1,
                      state: state),
                  TabScreen(
                      taskCubit: widget.taskCubit, filterValue: 2, state: state)
                ]);
              }),
            ),
          )
        ],
      ),
      floatingActionButton: SpeedDial(
        overlayColor: AppColor.buttonColor,
        overlayOpacity: 0.1,
        backgroundColor: AppColor.buttonColor,
        animatedIcon: AnimatedIcons.menu_close,
        animatedIconTheme:
            const IconThemeData(color: AppColor.primaryBackgroundColor),
        spaceBetweenChildren: 5.0,
        children: [
          SpeedDialChild(
            label: "Add Task",
            labelBackgroundColor: AppColor.buttonColor,
            labelStyle: const TextStyle(
              color: AppColor.tabUnfocusedTextColor,
            ),
            child: const Icon(
              Icons.add,
              color: AppColor.primaryBackgroundColor,
            ),
            backgroundColor: AppColor.buttonColor,
            foregroundColor: AppColor.primaryBackgroundColor,
            onTap: () async {
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
                                        foregroundColor:
                                            AppColor.buttonColor))),
                            child: child!);
                      },
                      // ignore: use_build_context_synchronously
                      context: this.context,
                      initialTime: TimeOfDay.now());
                }

                if (selectedTime != null) {
                  final time = DateTime(
                      selectedDate!.year,
                      selectedDate!.month,
                      selectedDate!.day,
                      selectedTime!.hour,
                      selectedTime!.minute);

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
          ),
          SpeedDialChild(
            label: "Change App Icon",
            labelBackgroundColor: AppColor.buttonColor,
            labelStyle: const TextStyle(
              color: AppColor.tabUnfocusedTextColor,
            ),
            child: const Icon(
              Icons.all_inclusive_rounded,
              color: AppColor.primaryBackgroundColor,
            ),
            backgroundColor: AppColor.buttonColor,
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  backgroundColor: AppColor.primaryButtonColor,
                  title: const Text(
                    "Choose your App Icon",
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: AppColor.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                  content: SingleChildScrollView(
                    child: ListBody(children: [
                      ListTile(
                        title: const Text("Default Icon"),
                        leading: Image.asset(
                          "lib/app/assets/app_icon_1.png",
                          width: 50,
                          height: 50,
                        ),
                        onTap: () async {
                          try {
                            await DynamicIconFlutter.setIcon(
                                icon: 'MainActivity', listAvailableIcon: list);
                            print("Thay đổi biểu tượng ứng dụng thành công");
                          } catch (e) {
                            print("Lỗi khi thay đổi biểu tượng ứng dụng: $e");
                          }
                        },
                      ),
                      ListTile(
                        title: const Text("Gradient Icon 1"),
                        leading: Image.asset(
                          "lib/app/assets/app_icon_2.png",
                          width: 50,
                          height: 50,
                        ),
                        onTap: () async {
                          try {
                            await DynamicIconFlutter.setIcon(
                                icon: 'icon_1', listAvailableIcon: list);
                            print("Thay đổi biểu tượng ứng dụng thành công");
                          } catch (e) {
                            print("Lỗi khi thay đổi biểu tượng ứng dụng: $e");
                          }
                        },
                      ),
                      ListTile(
                        title: const Text("Gradient Icon 2"),
                        leading: Image.asset(
                          "lib/app/assets/app_icon_3.png",
                          width: 50,
                          height: 50,
                        ),
                        onTap: () async {
                          try {
                            await DynamicIconFlutter.setIcon(
                                icon: 'icon_2', listAvailableIcon: list);
                            print("Thay đổi biểu tượng ứng dụng thành công");
                          } catch (e) {
                            print("Lỗi khi thay đổi biểu tượng ứng dụng: $e");
                          }
                        },
                      ),
                      ListTile(
                        title: const Text("Gradient Icon 3"),
                        leading: Image.asset(
                          "lib/app/assets/app_icon_4.png",
                          width: 50,
                          height: 50,
                        ),
                        onTap: () async {
                          try {
                            await DynamicIconFlutter.setIcon(
                                icon: 'icon_3', listAvailableIcon: list);
                            print("Thay đổi biểu tượng ứng dụng thành công");
                          } catch (e) {
                            print("Lỗi khi thay đổi biểu tượng ứng dụng: $e");
                          }
                        },
                      ),
                    ]),
                  ),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
