import 'package:cleanedapp/master_page.dart';
import 'package:cleanedapp/tasks_list/task_list_controller.dart';
import 'package:cleanedapp/tasks_list/task_list_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:sharedor/export_common.dart';
import 'package:cleanedapp/helpers/locator.dart';
import 'package:cleanedapp/export_all_ui.dart';
import 'package:sharedor/helpers/export_helpers.dart';

class TaskListScreen extends StatelessWidget {
  TaskListScreen({Key? key});
  //FamilyM family = locator.get<FamilyController>().family;
  Widget build(BuildContext context) {
    return AppMainTemplate(isHome: true, title: Text("Clean App"), children: [
      // Consumer(builder: (context, watch, child) {
      //   AsyncValue<InsTaskList> streammeet = watch(streamTask);
      //   return streammeet.when(
      //       data: (value) => buildList(value),
      //       loading: () => Text("hi"), //LogoSpinner(height: 100),
      //       error: (error, stack) => Text(error.toString()));
      // }),

      // TaskListWidget()
    ]);
  }
}
