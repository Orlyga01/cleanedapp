import 'dart:async';
import 'package:cleanedapp/task/task_model.dart';
import 'package:cleanedapp/todo/todo_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TaskListController {
  TaskListController();
  final StreamController<TodoList> listItems = StreamController<TodoList>();
  Stream<TodoList> get getTaskList => listItems.stream;
  //UserController repository = locator.get<UserController>();
  TodoList _list = TodoList.empty;

  Future<void> setCurrentTaskList(TodoList list) async {
    _list = list;

    listItems.sink.add(_list);
  }

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

final streamTask = StreamProvider.autoDispose<TodoList>((ref) {
  ref.onDispose(() => print("controller for uid was disposed"));
  return TaskListController().getTaskList;
});
