import 'dart:developer';

import 'package:cleanedapp/helpers/global_parameters.dart';
import 'package:cleanedapp/misc/providers.dart';
import 'package:cleanedapp/room/room_controller.dart';
import 'package:cleanedapp/room/room_model.dart';
import 'package:cleanedapp/task/task_model.dart';
import 'package:cleanedapp/task/task_widget.dart';
import 'package:cleanedapp/user/be_user_controller.dart';
import 'package:flutter/material.dart';
import 'package:sharedor/export_common.dart';
import 'package:sharedor/external_export_view.dart';
import 'package:sharedor/helpers/export_helpers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reorderables/reorderables.dart';
import 'package:sharedor/widgets/first_row_list_add.dart';
import 'package:sharedor/widgets/expanded_inside_list.dart';

class TaskListWidget extends StatefulWidget {
  late final List<Task> tasks;
  final Room room;
  bool? updateTaskMode = true;
  bool tileExpanded = false;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  TaskListWidget({
    Key? key,
    required this.room,
  }) : super(key: key);
  @override
  State<TaskListWidget> createState() => TaskListWidgetState();
}

class TaskListWidgetState extends State<TaskListWidget> {
  late Map<String, GlobalKey<FormState>> gkTask = {};
  List<Task> tasks = [];
  bool editState = false;

  //     if (room != null) TaskController().setCurrentTaskList(room!.tasks);

  @override
  void initState() {
    List<Task> tasks = widget.room.roomTasks;

    for (var item in tasks) {
      print(item.id);
      gkTask[item.id] = GlobalKey<FormState>();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Make sure there is a scroll controller attached to the scroll view that contains ReorderableSliverList.
    // Otherwise an error will be thrown.

    return Consumer(builder: (consumercontext, listen, child) {
      listen(userStateChanged);
      return SizedBox(
        height: GlobalParametersFM().screenSize.height,
        child: Column(children: [
          buildListTask(widget.room.roomTasks),
        ]),
      );
    });
  }

  Widget buildListTask(List<Task> tasks) {
    List<Widget> _rows = [];
    _rows = List<Widget>.generate(
      tasks.length,
      (int index) {
        Task item = tasks[index];
        return Container(
          key: ValueKey(item.id),
          child:
              //Text("id:" + (tasks[index].id)
              Column(
            children: [
              ExapndableInList<Task>(
                  item: item,
                  title: Text(item.title),
                  formkey: widget._formkey,
                  onClickDelete: (Task item) => deleteTask(item, context),
                  expandedChild: TaskWidget(
                    formKey: gkTask[item.id]!,
                    task: tasks[index],
                    onChanged: (Task item) {
                      tasks[index] = item;
                    },
                  )),
            ],
          ),
        );
      },
    );
    Task emptytask = Task.empty;
    _rows = <Widget>[
          Container(
            key: const ValueKey('10'),
            child: NewObjectInList<Task>(
                item: emptytask,
                addTitle: "Add task",
                formkey: widget._formkey,
                //  onClick: (Task item) => ,
                expandedChild: TaskWidget(
                  formKey: widget._formkey,
                  task: emptytask,
                  onChanged: (Task item) {
                    emptytask = item;
                  },
                )),
          )
        ] +
        _rows;
    return ReorderableColumn(
      children: _rows,
      onReorder: _onReorder,
    );
  }

  void _onReorder(int oldIndex, int newIndex) {
    //abort if first row has been dragged or if try to drag above the first row
    if (oldIndex == 0 || newIndex == 0) {
      oldIndex = newIndex;
    } else {
      Task orig = tasks[oldIndex - 1];
      tasks.removeAt(oldIndex - 1);
      tasks.insert(newIndex - 1, orig);
      // tasks[newIndex] = orig;
      updateTasksList(widget.tasks);
    }
    setState(() {
      // Widget row = _rows.removeAt(oldIndex);
      // _rows.insert(newIndex, row);
    });
  }

  Future<void> updateTask(Task task) async {
    try {
      await BeUserController().updateTaskOfRoom(widget.room, task);
      setState(() {});
    } catch (e) {
      showAlertDialog(e.toString(), context);
    }
  }

  Future<void> updateTasksList(List<Task> tasks) async {
    try {
      await BeUserController().updateListTaskOfRoom(widget.room, tasks);
      setState(() {});
    } catch (e) {
      showAlertDialog(e.toString(), context);
    }
  }

  Future<bool> deleteTask(Task task, BuildContext context) async {
    try {
      await BeUserController().deleteRoomTask(widget.room, task);
      context.read(userStateChanged.notifier).setNotifyUserChange();
    } catch (e) {
      log(e.toString());
      // showAlertDialog(e.toString(), context);
      return false;
    }

    return true;
  }
}
