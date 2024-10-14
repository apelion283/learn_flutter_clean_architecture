import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:to_do_app/presentation/cubit/task_cubit.dart';
import 'package:to_do_app/presentation/pages/home/home.dart';

void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: HomePageScreen(
      title: "Simple Up To Do",
      taskCubit: TaskCubit(),
    ),
  ));
  FlutterNativeSplash.remove();
}
