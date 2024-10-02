import 'package:flutter/material.dart';
import 'package:to_do_app/app/resources/color_manager.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? hint;
  final bool isAutoFocus;

  const AppTextField(
      {super.key,
      required this.controller,
      this.hint,
      this.isAutoFocus = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
        controller: controller,
        cursorColor: AppColor.textColor,
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: AppColor.hintColor),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            enabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                borderSide: BorderSide(
                  color: Colors.transparent,
                  width: 2.0,
                )),
            focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                    color: AppColor.focusedOutlineTextFieldBorderColor,
                    width: 1.0),
                borderRadius: BorderRadius.all(Radius.circular(8)))),
        style: const TextStyle(color: AppColor.textColor),
        autofocus: isAutoFocus);
  }
}
