import 'package:cleanedapp/master_page.dart';
import 'package:cleanedapp/tasks_list/tasks_list_widget.dart';

import 'package:flutter/material.dart';

class TaskListScreen extends StatelessWidget {
  final GlobalKey<TaskListWidgetState> _key = GlobalKey<TaskListWidgetState>();
  final String roomId;
  // ignore: use_key_in_widget_constructors
  TaskListScreen({Key? key, required this.roomId});
  @override
  Widget build(BuildContext context) {
    return AppMainTemplate(
        isHome: true,
        title: const Text("Tasks"),
        floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
        children: [
          TaskListWidget(
            key: _key,
            roomId: roomId,
          )
        ]);
  }
}
