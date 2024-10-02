import 'package:flutter/material.dart';
import 'package:to_do_app/app/resources/color_manager.dart';

class FilterDropdown extends StatefulWidget {
  final Function(int) onItemSelectedChange;
  final int selectedIndex;

  const FilterDropdown(
      {super.key,
      required this.onItemSelectedChange,
      required this.selectedIndex});

  @override
  State<FilterDropdown> createState() => _FilterDropDownState();
}

class _FilterDropDownState extends State<FilterDropdown> {
  var items = ["All", "In Progress", "Done"];

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height: 31,
            decoration: BoxDecoration(
                color: AppColor.taskItemColor,
                borderRadius: BorderRadius.circular(8)),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: DropdownButton<String>(
                value: items[widget.selectedIndex],
                items: items.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: const TextStyle(
                          color: AppColor.textColor, fontSize: 10),
                    ),
                  );
                }).toList(),
                dropdownColor: AppColor.taskItemColor,
                onChanged: (String? newValue) {
                  widget.onItemSelectedChange(items.indexOf(newValue!));
                },
                icon: Image.asset(
                  'lib/app/assets/ic_drop_down.png',
                  width: 16,
                  height: 16,
                ),
                underline: const SizedBox(),
                isExpanded: false,
              ),
            ))
      ],
    );
  }
}
