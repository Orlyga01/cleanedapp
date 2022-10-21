import 'dart:async';
import 'package:cleanedapp/Task/task_model.dart';
import 'package:cleanedapp/helpers/locator.dart';
import 'package:cleanedapp/tasks_list/task_list_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListController {
  TaskListController();
  final StreamController<TaskList> listItems =
      StreamController<TaskList>();
  Stream<TaskList> get getTaskList => listItems.stream;
  //UserController repository = locator.get<UserController>();
  TaskList _list = TaskList.empty();

  Future<void> setCurrentTaskList(TaskList list) async {
    _list = list;

    listItems.sink.add(_list);
  }

  // Future<void> saveTaskList() async {
  //   final menu = locator.get<UserListController>().menu;
  //   try {
  //     locator.get<FamilyController>().updateFamily(
  //         fieldName: "menuJson", fieldValue: TaskList.toJson(menu));
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  void dispose() {
    listItems.close();
  }

  Future<void> updateTaskList() async {
    //Do update menu then sink
    // we want that new or recently updated would always be the first in the list
    listItems.sink.add(_list);
  }

  List<Task> getTaskByRoom(String room) {
    return [];
  }
}

final streamTask = StreamProvider.autoDispose<TaskList>((ref) {
  ref.onDispose(() => print("controller for uid was disposed"));
  return locator.get<TaskListController>().getTaskList;
});
