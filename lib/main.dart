import 'package:flutter/material.dart';
import 'package:to_do_app/presentation/cubit/task_cubit.dart';
import 'package:to_do_app/presentation/pages/home/home.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePageScreen(
      title: "Simple Up To Do",
      taskCubit: TaskCubit(),
    ),
  ));
}
