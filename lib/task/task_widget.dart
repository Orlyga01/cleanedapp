import 'dart:async';

import 'package:authentication/shared/import_shared.dart';
import 'package:cleanedapp/task/task_model.dart';
import 'package:cleanedapp/misc/categories_mode.dart';
import 'package:flutter/material.dart';
import 'package:sharedor/export_common.dart';
import 'package:sharedor/widgets/DropDown.dart';
import 'package:sharedor/widgets/radio_buttons.dart';

class TaskWidget extends StatefulWidget {
  final Function(Task)? onChanged;
  final Task task;
  final GlobalKey<FormState> formKey;

  TaskWidget({Key? key, required this.formKey, this.onChanged, Task? task})
      : task = task ?? Task.empty,
        super(key: key);

  @override
  State<TaskWidget> createState() => _TaskWidgetState();
}

class _TaskWidgetState extends State<TaskWidget> {
  bool changed = false;
  Timer? debounce;
  _onTextChanged() {
    if (debounce?.isActive ?? false) debounce?.cancel();
    debounce = Timer(const Duration(milliseconds: 500), () {
      if (changed && widget.onChanged != null) {
        widget.onChanged!(widget.task);
        changed = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> lw = formFields();

    return Form(
        key: GlobalKey<FormState>(),
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Expanded(
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: lw.length,
                    itemBuilder: (BuildContext context, int index) {
                      return lw[index];
                    }),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    debounce?.cancel();
    //widget.formKey = null;
    super.dispose();
  }

  List<Widget> formFields() {
    return [
      RadioButtonWidget(
          selectedItem: widget.task.frequency,
          items: FrequencyEnum.values,
          onChange: (value) => {
                changed = true,
                widget.task.frequency = value,
                _onTextChanged()
              }),
      const SizedBox(height: 10),
      TextFormField(
          key: GlobalKey(),
          // initialValue: initialValue,
          initialValue: widget.task.title,
          decoration: InputDecoration(
            labelText: "Title".ctr(),
          ).unifiedLabel(readOnly: false),
          onChanged: (value) =>
              {changed = true, widget.task.title = value, _onTextChanged()},
          validator: (value) {
            if (value != null && value.isEmpty) {
              return "Please add the title".ctr();
            }
            return null;
          }),
      const SizedBox(height: 10),
      TextFormField(
        maxLines: 2, //or null
        // initialValue: initialValue,
        initialValue: widget.task.description,

        decoration: InputDecoration(
          labelText: "Description".ctr(),
          fillColor: Colors.transparent,
        ).unifiedLabel(),
        onChanged: (value) =>
            {widget.task.description = value, _onTextChanged()},
      ),
    ];
  }
}

// class TaskWidget extends StatelessWidget {
//   final Task task;
//   const TaskWidget({Key? key, required this.task}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//         height: 40,
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Text(task.title),
//             DropDownWidget(
//                 selectedItem: task.frequency,
//                 onChange: (value) => task.frequency,
//                 items: FrequencyEnum.values.map((FrequencyEnum classType) {
//                   return DropdownMenuItem<FrequencyEnum>(
//                       value: classType,
//                       child: Text(enumToString(classType.toString())));
//                 }).toList()),
//           ],
//         ));
//   }
// }
