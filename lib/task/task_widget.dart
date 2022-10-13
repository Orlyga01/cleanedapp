import 'package:cleanedapp/task/task_model.dart';
import 'package:cleanedapp/export_all_ui.dart';
import 'package:cleanedapp/misc/categories_mode.dart';
import 'package:flutter/material.dart';
import 'package:sharedor/common_functions.dart';
import 'package:sharedor/widgets/DropDown.dart';

class TaskWidget extends StatelessWidget {
  final Task task;
  const TaskWidget({Key? key, required this.task}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 40,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(task.title),
            DropDownWidget(
                selectedItem: task.frequency,
                onChange: (value) => task.frequency,
                items: FrequencyEnum.values.map((FrequencyEnum classType) {
                  return DropdownMenuItem<FrequencyEnum>(
                      value: classType,
                      child: Text(enumToString(classType.toString())));
                }).toList()),
          ],
        ));
  }
}
